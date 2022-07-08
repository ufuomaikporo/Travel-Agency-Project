OPTIONS(direct=false, errors=0)

LOAD DATA
INFILE 'C:\DBA\Travel Experts\scripts\Loading_tables\client_adhoc\client_data_bad.csv'
BADFILE 'C:\DBA\Travel Experts\scripts\Loading_tables\client_adhoc\client_data_bad.bad'
DISCARDFILE 'C:\DBA\Travel Experts\scripts\Loading_tables\client_adhoc\client_data_bad.dsc'

APPEND INTO TABLE client_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(client_id      INTEGER EXTERNAL,
 firstname      CHAR,
 lastname       CHAR,
 pref_agent     CHAR,
 email          CHAR,
 home_phone     FILLER,
 business_phone CHAR,
 birthdate      DATE "MM/DD/YYYY",
 address        CHAR,
 city           CHAR,
 postal_code    CHAR,
 province       CHAR,
 country        CHAR
)