OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\supplier_adhoc\supplier_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\product_supplier_adhoc\load_prod_supplier_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\product_supplier_adhoc\load_prod_supplier_data.dsc'

REPLACE INTO TABLE product_supplier_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(supplier_id      INTEGER EXTERNAL,
 product_id       INTEGER EXTERNAL,
 office           INTEGER EXTERNAL,
 prod_desc        CHAR,
 contact_name     FILLER,
 company          CHAR,
 address_1        FILLER,
 address_2        FILLER,
 city             FILLER,
 province         FILLER,
 zip_code         FILLER,
 country          FILLER,
 phone            FILLER,
 fax_no           FILLER,
 email            FILLER,
 website          FILLER,
 rep              CHAR,
 affiliation_code CHAR,
 prod_supplier_id SEQUENCE(200,1) 
)