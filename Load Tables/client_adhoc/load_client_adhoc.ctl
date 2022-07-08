OPTIONS(skip=1, direct=false, errors=300)

LOAD DATA
INFILE 'C:\DBA\Travel Experts\scripts\Loading_tables\client_adhoc\client_data.csv'
BADFILE 'C:\DBA\Travel Experts\scripts\Loading_tables\client_adhoc\client_data.bad'
DISCARDFILE 'C:\DBA\Travel Experts\scripts\Loading_tables\client_adhoc\client_data.dsc'

REPLACE INTO TABLE client_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(client_id      INTEGER EXTERNAL,
 firstname      CHAR,
 lastname       CHAR,
 pref_agent     CHAR,
 email          CHAR,
 home_phone     CHAR,
 business_phone CHAR,
 birthdate      DATE "MM/DD/YYYY",
 address        CHAR,
 city           CHAR,
 postal_code    CHAR,
 province       CHAR,
 country        CHAR
)