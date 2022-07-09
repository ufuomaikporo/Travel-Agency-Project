#!/bin/ksh
#
# this is orahot.sh - used to perform full hot backup of any database passed to it in the first parameter

#########################################################################################
# Author: Ufuoma
# Date: April 30 2022
# change log:
#########################################################################################

#########################################################################################
# Funtion Declarations
#########################################################################################

. /home/oracle/scripts/functions.ksh

#########################################################################################
# File Declarations
#########################################################################################

export TMPFILE2=/tmp/orahot$$_2.txt
export TMPFILE=/tmp/orahot$$.txt
export FILE_ID=$(date +"%Y%m%d%H%M%S")
export LOGFILE=/home/oracle/logs/orahot_$1_${FILE_ID}.log

#########################################################################################
# Check for the right number of input parameters
#########################################################################################

echo_msg "\norahot.sh called on $(date)"
echo_msg "Created logfile ${LOGFILE}"

if [ $# = 0 ]; then
  echo_msg "orahot.sh must have 1 argument"
  exit 1
elif [ $# -gt 1 ]; then
  echo_msg "orahot.sh cannot have more than 1 argument"
  exit 1
fi

#########################################################################################
# Check that the database service name has a valid Oracle Home
#########################################################################################

export ORACLE_SID=$1
dbhome > /dev/null 2>&1

if [ $? != 0 ]; then
  echo_msg "There is no Oracle Home set for ${ORACLE_SID}"
  exit 1
fi

#########################################################################################
# Set Oracle Environment
#########################################################################################

export ORAENV_ASK=NO
. oraenv > /dev/null 2>&1

if [ $? != 0 ]; then
  echo_msg "Could not set the Oracle environment"
  exit 1
fi

#########################################################################################
# Check that the database is open
#########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE}
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set lines 100
set head off
select open_mode from v\$database;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Unable to query the status of the database"
  exit 1
fi

if [ "$(grep READ ${TMPFILE})" != "READ WRITE" ]; then
  echo_msg "The database is not open in READ WRITE mode"
  exit 1
fi

#########################################################################################
# Check that the database is in archivelog mode
#########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE}
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set lines 100
set head off
select log_mode from v\$database;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Could not determine the log mode of the database"
  exit 1
fi

if [ $(grep ARCHIVE ${TMPFILE}) != ARCHIVELOG ]; then
  echo_msg "The database is not in ARCHIVELOG mode"
  exit 1
fi

#########################################################################################
# Check if a hot backup is already running
#########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE}
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set lines 100
set head off
select status from v\$backup;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Could not obtain the backup status of the database"
  exit 1
fi

if [ "$(grep '^ACTIVE' ${TMPFILE})" = "ACTIVE" ]; then
  echo_msg "A backup is currently in progress"
  exit 1
fi

###########################################################################################
# Set Backup location
###########################################################################################

BU_LOCATION=/backup01/hot/${ORACLE_SID}/${FILE_ID}

if [ ! -d ${BU_LOCATION} ]; then
  mkdir -p ${BU_LOCATION}
fi

if [ ! -d ${BU_LOCATION} ]; then
 echo_msg "Failed to create the backup location"
  exit 1
else
  echo_msg "Hot backups will be sent to ${BU_LOCATION}"
fi

##########################################################################################
# Create recovery script
##########################################################################################

touch ${BU_LOCATION}/orahot_recovery_${ORACLE_SID}.sh
RECOVERY_SCRIPT=${BU_LOCATION}/orahot_recovery_${ORACLE_SID}.sh

if [ $? != 0 ]; then
  echo_msg "Failed to create recovery script"
  exit 1
else
  echo_msg "Created the recovery script ${BU_LOCATION}/orahot_recovery_${ORACLE_SID}.sh"
fi

echo "#!/bin/ksh" >> ${RECOVERY_SCRIPT}

##########################################################################################
# Find all datafiles in the database and save them to a temporary file
##########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE}
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set lines 100
set head off
set feedback off
col tablespace_name format a15
col file_name format a60
select tablespace_name, file_name from dba_data_files;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Failed to get the location of database data files"
  exit 1
fi

echo_msg "Beginning database backup"

##########################################################################################
# Get the current log sequence number before backuping up data files
##########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE2}
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set lines 100
set head off
select status, sequence# from v\$log;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Failed to get the current log sequence"
  exit 1
fi

START_SEQ=$(grep CURRENT ${TMPFILE2} | awk '{ print $2}')

echo_msg "\nThe log sequence number at the beginning of data file backups is ${START_SEQ}"

##########################################################################################
# Backup data files using a nested loop
##########################################################################################

echo_msg "\nStarting Backup of datafiles"

echo -e "\n# Recover Datafiles" >> ${RECOVERY_SCRIPT}

# Beginning of outer loop to place tablespaces in and out of backup mode

grep -v '^$' ${TMPFILE} | awk '{ print $1 }' | sort -u | while read TBS  
do
sqlplus -s /nolog << EOF > /dev/null 2>&1 
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
alter tablespace ${TBS} begin backup;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Failed to place ${TBS} tablespace in backup mode"
  exit 1
fi

# Beginning of inner loop to copy data files and update recovery script
  
  grep ${TBS} ${TMPFILE} | awk '{ print $2 }' | while read DTF
  do
    echo_msg "Copying datafile ${DTF} to ${BU_LOCATION}/$(basename ${DTF})" 
    cp ${DTF} ${BU_LOCATION}

# Add data file recovery commands to the recovery script
 
    echo "#cp ${BU_LOCATION}/$(basename ${DTF}) ${DTF}" >> ${RECOVERY_SCRIPT}
  done

sqlplus -s /nolog << EOF > /dev/null 2>&1
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
alter tablespace ${TBS} end backup;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Failed to remove ${TBS} tablespace from backup mode"
  exit 1
fi
done

#########################################################################################
# Perform a log switch and get log sequence number after data file backup
#########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE}
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set lines 100
set head off
alter system archive log current;
select status, sequence# from v\$log;
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Failed to get the current log sequence"
  exit 1
fi

END_SEQ=$(grep CURRENT ${TMPFILE} | awk '{ print $2}')

echo_msg "\nThe log sequence number at the end of data file backups is ${END_SEQ}"

#########################################################################################
# Backup archived redo log files
#########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE}
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set pages 999 lines 250
set head off
set feedback off
col name format a200
select sequence#, name from v\$archived_log
where sequence# between ${START_SEQ} and ${END_SEQ};
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Failed to get location of archived redo log files"
  exit 1
fi

if [ $END_SEQ != $START_SEQ ]; then
  
  echo_msg "\nStarting backup of archived redo log files"
  
  echo -e "\n# Recover Archived Redo Logs" >> ${RECOVERY_SCRIPT} 

  
# loop to backup archive log files

  grep -v '^$' ${TMPFILE} | awk '{ print $2 }'| while read ARC_FILE 
  do
    echo_msg "Copying ${ARC_FILE} to ${BU_LOCATION}/$(basename ${ARC_FILE})"
    cp ${ARC_FILE} ${BU_LOCATION}

# Add recovery commands for archived logs to the recovery script

    echo "#cp ${BU_LOCATION}/$(basename ${ARC_FILE}) ${ARC_FILE}" >> ${RECOVERY_SCRIPT}
  done
fi

##########################################################################################
# Backup Control File (binary and logical)
##########################################################################################

echo_msg "\nStarting binary and logical backups of control file"

sqlplus -s /nolog << EOF > ${TMPFILE}	
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
alter database backup controlfile to trace as '${BU_LOCATION}/control.txt';
alter database backup controlfile to '${BU_LOCATION}/control.bin'; 
exit
EOF

if [ $? != 0 ]; then
  echo_msg "Failed to backup control file"
  exit 1
fi

echo_msg "Control file is backed up to ${BU_LOCATION}"

########################################################################################
# Get location of control files and add control file recovery commands to recovery script
########################################################################################

sqlplus -s /nolog << EOF > ${TMPFILE}	
whenever sqlerror exit 2
connect system/oracle@${ORACLE_SID}
set head off
set lines 60
select name from v\$controlfile;
exit
EOF

if [ $? != 0 ]; then
  echo _msg "Failed to get location of control files"
  exit 1
fi

echo -e "\n# Recover Control Files" >> ${RECOVERY_SCRIPT} 

grep -v '^$' ${TMPFILE} | while read FILE
do
  echo "#cp ${BU_LOCATION}/control.bin ${FILE}" >> ${RECOVERY_SCRIPT}
done

#########################################################################################
# Backup spfile
#########################################################################################

echo_msg "\nStarting backup of spfile"
SPFILE=$(find $ORACLE_HOME -name "spfile${ORACLE_SID}*" -print)
echo_msg "copying spfile ${SPFILE} to ${BU_LOCATION}/$(basename ${SPFILE})"
cp ${SPFILE} ${BU_LOCATION}

# Add recovery command for spfile to recovery script

echo -e "\n# Recover spfile" >> ${RECOVERY_SCRIPT}
echo "#cp ${BU_LOCATION}/$(basename ${SPFILE}) ${SPFILE}" >> ${RECOVERY_SCRIPT}

#######################################################################################
# Cleanup 
#######################################################################################

echo_msg "Backup Completed on $(date)"
echo_msg ""

rm -f ${TMPFILE}
rm -f ${TMPFILE2}
