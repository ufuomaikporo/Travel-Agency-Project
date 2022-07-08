OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\Sales_data\sales_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\payment_adhoc\payment_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\payment_adhoc\payment_data.dsc'

REPLACE INTO TABLE payment_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(sale_date         DATE "MM/DD/YYYY",
 client_id         INTEGER EXTERNAL,
 itinerary_no      INTEGER EXTERNAL,
 agent             FILLER,
 booking_num       FILLER,
 product_id        FILLER,
 supplier_id       FILLER,
 office            FILLER,
 prod_start        FILLER,
 prod_end          FILLER,
 class_code        FILLER,
 num_of_travellers FILLER,
 prod_name         FILLER,
 description       FILLER,
 destination       FILLER,
 continent         FILLER,
 card_type         FILLER,
 card_expiry       FILLER,
 card_no           CHAR,
 payment_date      DATE "MM/DD/YYYY",
 payment_desc      CHAR,
 base_price        FILLER,
 total_price       FILLER,
 payment_amt       DECIMAL EXTERNAL,
 fee_code          FILLER,
 fee_amt           FILLER,
 comm_amt          FILLER,
 start_date        FILLER,
 end_date          FILLER,
 payment_no        SEQUENCE(30, 1)
)