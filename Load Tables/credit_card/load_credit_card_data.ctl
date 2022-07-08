OPTIONS(skip=1, direct=false, errors=2000)

LOAD DATA
INFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\Sales_data\sales_data.csv'
BADFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\credit_card\credit_card_data.bad'
DISCARDFILE 'C:\TXPDB\C_Drive\scripts\Loading_tables\credit_card\credit_card_data.dsc'

REPLACE INTO TABLE credit_card
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS  
(sale_date        FILLER,
 client_id        INTEGER EXTERNAL,
 itinerary_no     FILLER,
 agent            FILLER,
 booking_no       FILLER,
 product_id       FILLER,
 supplier_id      FILLER,
 office           FILLER,
 prod_start       FILLER,
 prod_end         FILLER,
 class_code       FILLER,
 travellers       FILLER,
 prod_name        FILLER,
 description      FILLER,
 destination      FILLER,
 continent        FILLER,
 type             CHAR,
 expiry_date      DATE "MM/DD/YYYY",
 card_no          CHAR,
 payment_date     FILLER,
 payment_desc     FILLER,
 base_price       FILLER,
 total_price      FILLER,
 payment_amt      FILLER,
 fee_code         FILLER,
 fee_amt          FILLER,
 comm_amt         FILLER,
 trip_start       FILLER,
 trip_end         FILLER
)