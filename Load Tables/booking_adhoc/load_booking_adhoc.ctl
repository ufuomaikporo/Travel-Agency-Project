OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\Sales_data\sales_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\booking_adhoc\booking_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\booking_adhoc\booking_data.dsc'

REPLACE INTO TABLE booking_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(sale_date         DATE "MM/DD/YYYY",
 client_id         INTEGER EXTERNAL,
 itinerary_no      INTEGER EXTERNAL,
 agent             CHAR,
 booking_num       FILLER,
 product_id        INTEGER EXTERNAL,
 supplier_id       INTEGER EXTERNAL,
 office            INTEGER EXTERNAL,
 prod_start        DATE "MM/DD/YYYY",
 prod_end          DATE "MM/DD/YYYY",
 class_code        CHAR,
 num_of_travellers INTEGER EXTERNAL,
 prod_name         FILLER,
 description       CHAR,
 destination       CHAR,
 continent         CHAR,
 card_type         FILLER,
 card_expiry       FILLER,
 card_no           FILLER,
 payment_date      FILLER,
 payment_desc      FILLER,
 base_price        DECIMAL EXTERNAL,
 total_price      DECIMAL EXTERNAL,
 payment_amt      FILLER,
 fee_code         CHAR,
 fee_amt          FILLER,
 comm_amt         DECIMAL EXTERNAL,
 trip_start       DATE "MM/DD/YYYY",
 trip_end         DATE "MM/DD/YYYY",
 booking_no       SEQUENCE(100,1)
)