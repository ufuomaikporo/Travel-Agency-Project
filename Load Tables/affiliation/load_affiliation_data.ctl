OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\affiliation\affiliation_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\affiliation\affiliation_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\affiliation\affiliation_data.dsc'

REPLACE INTO TABLE affiliation
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(code        CHAR,
 description CHAR
)