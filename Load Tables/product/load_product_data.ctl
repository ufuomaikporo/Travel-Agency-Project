OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\product\product_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\product\product_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\product\product_data.dsc'

REPLACE INTO TABLE product
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(category_id INTEGER EXTERNAL,
 description CHAR
)