OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\supplier_adhoc\supplier_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\supplier_adhoc\load_supplier_adhoc.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\supplier_adhoc\load_supplier_adhoc.dsc'

REPLACE INTO TABLE supplier_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(supplier_id      INTEGER EXTERNAL,
 product_id       INTEGER EXTERNAL,
 office           INTEGER EXTERNAL,
 prod_desc        FILLER,
 contact_name     CHAR,
 company          CHAR,
 address_line1    CHAR,
 address_line2    CHAR,
 city             CHAR,
 province         CHAR,
 zip_code         CHAR,
 country          CHAR,
 phone            CHAR,
 fax_no           CHAR,
 email            CHAR,
 website          CHAR
)