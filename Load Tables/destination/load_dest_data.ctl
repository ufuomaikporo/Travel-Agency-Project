OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\destination\destination_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\destination\destination_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\destination\destination_data.dsc'

REPLACE INTO TABLE destination
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(code        CHAR,
 description CHAR
)