OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\Sales_data\sales_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\trip_adhoc\load_trip_adhoc.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\trip_adhoc\load_trip_adhoc.dsc'

REPLACE INTO TABLE trip_adhoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(sale_date         DATE "MM/DD/YYYY",
 client_id         INTEGER EXTERNAL,
 itinerary         FILLER,
 agent             FILLER,
 booking_no        FILLER,
 product_id        FILLER,
 supplier_id       FILLER,
 office            FILLER,
 prod_start        DATE "MM/DD/YYYY",
 prod_end          DATE "MM/DD/YYYY",
 class_code        FILLER,
 num_of_travellers FILLER,
 prod_name         FILLER,
 description       FILLER,
 destination       FILLER,
 dest_code         CHAR,
 card_type         FILLER,
 card_expiry       FILLER,
 card_no           FILLER,
 payment_date      FILLER,
 payment_desc      FILLER,
 base_price        FILLER,
 total_price       FILLER,
 payment_amt       FILLER,
 fee_code          FILLER,
 fee_amt           FILLER,
 comm_amt          FILLER,
 trip_start        DATE "MM/DD/YYYY",
 trip_end          DATE "MM/DD/YYYY",
 itinerary_no      SEQUENCE(130,1)
)