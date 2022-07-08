OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\Sales_data\sales_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\commission\commission_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\commission\commission_data.dsc'

REPLACE INTO TABLE commission_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(sale_date        DATE "MM/DD/YYYY",
 client_id        INTEGER EXTERNAL,
 itinerary_no     INTEGER EXTERNAL,
 agent            FILLER,
 booking_num      FILLER,
 product_id       FILLER,
 supplier_id      FILLER,
 office           FILLER,
 prod_start       DATE "MM/DD/YYYY",
 prod_end         DATE "MM/DD/YYYY",
 class_code       FILLER,
 travellers       FILLER,
 prod_name        FILLER,
 description      FILLER,
 destination      FILLER,
 continent        FILLER,
 card_type        FILLER,
 card_expiry      FILLER,
 card_no          FILLER,
 payment_date     FILLER,
 payment_desc     FILLER,
 base_price       FILLER,
 total_price      FILLER,
 payment_amt      FILLER,
 fee_code         FILLER,
 fee_amt          FILLER,
 comm_amt         DECIMAL EXTERNAL,
 trip_start       FILLER,
 trip_end         FILLER
)