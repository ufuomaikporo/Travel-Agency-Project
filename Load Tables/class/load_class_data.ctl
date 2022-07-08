OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\class\class_type_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\class\class_type_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\class\class_type_data.dsc'

REPLACE INTO TABLE class
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(code        CHAR,
 description CHAR
)