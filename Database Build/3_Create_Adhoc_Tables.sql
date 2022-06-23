DROP TABLE txp_admin.client_adhoc PURGE;
DROP TABLE txp_admin.supplier_adhoc;
DROP TABLE txp_admin.product_supplier_adhoc;
DROP TABLE txp_admin.booking_adhoc;
DROP TABLE txp_admin.travellers_per_booking;
DROP TABLE txp_admin.travellers_per_trip;
DROP TABLE txp_admin.trip_adhoc;
DROP TABLE txp_admin.commission_adhoc;
DROP TABLE txp_admin.payment_adhoc;

CREATE TABLE txp_admin.client_adhoc
(client_id      NUMBER(6) CONSTRAINT client_adhoc_pk PRIMARY KEY,
 firstname     VARCHAR2(20),
 lastname      VARCHAR2(20),
 pref_agent     VARCHAR2(2),
 email          VARCHAR2(25),
 home_phone     VARCHAR2(10),
 business_phone VARCHAR2(10),
 birthdate      DATE,
 address        VARCHAR2(50),
 city           VARCHAR2(30),
 postal_code    VARCHAR2(7),
 province       VARCHAR2(30),
 country        VARCHAR2(30)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.supplier_adhoc
(supplier_id      NUMBER(8),
 product_id       NUMBER(3),
 office           NUMBER(2),
 contact_name     VARCHAR2(30),
 company          VARCHAR2(80),
 address_line1    VARCHAR2(80),
 address_line2    VARCHAR2(50),
 city             VARCHAR2(30),
 province         VARCHAR2(30),
 zip_code         VARCHAR2(7),
 country          VARCHAR2(30),
 phone            VARCHAR2(10),
 fax_no           VARCHAR2(10),
 email            VARCHAR2(60),
 website          VARCHAR2(60),
CONSTRAINT supplier_adhoc_pk PRIMARY KEY (supplier_id, product_id, office)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.product_supplier_adhoc
(prod_supplier_id NUMBER(8),
 supplier_id      NUMBER(8),
 product_id       VARCHAR2(3),
 office           NUMBER(2),
 prod_desc        VARCHAR2(50),
 company          VARCHAR2(80),
 rep              VARCHAR2(80),
 affiliation_code VARCHAR2(8),
 CONSTRAINT product_supplier_adhoc_pk PRIMARY KEY (supplier_id, product_id, office)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.booking_adhoc
(booking_no        VARCHAR2(8),
 sale_date         DATE, 
 itinerary_no      NUMBER(8),
 client_id         NUMBER(6),
 agent             VARCHAR2(2),
 product_id        NUMBER(3),
 supplier_id       NUMBER(8),
 office            NUMBER(2),
 comm_amt          NUMBER(7,2),
 fee_code          VARCHAR2(3),
 class_code        VARCHAR2(5),
 base_price        NUMBER(7,2),
 total_price       NUMBER(7,2),
 prod_start        DATE,
 prod_end          DATE,
 trip_start        DATE,
 trip_end          DATE,
 num_of_travellers NUMBER(2),
 destination       VARCHAR2(40),
 description       VARCHAR2(50),
 continent         VARCHAR2(5),
 CONSTRAINT booking_adhoc_pk PRIMARY KEY (sale_date, client_id, itinerary_no)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.travellers_per_booking
(itinerary_no NUMBER(8),
 prod_category_id NUMBER(3),
 num_of_travellers       NUMBER(2)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.travellers_per_trip
(itinerary_no NUMBER(8),
 num_of_travellers   NUMBER(2)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.trip_adhoc
(itinerary_no NUMBER(8),
 sale_date    DATE,
 client_id    NUMBER(6),
 prod_start   DATE,
 prod_end     DATE,
 dest_code    VARCHAR2(5),
 trip_start   DATE,
 trip_end     DATE,
 CONSTRAINT trip_adhoc_pk PRIMARY KEY (trip_start, trip_end, client_id)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.commission_adhoc
(sale_date    DATE,
 client_id    NUMBER(6),
 itinerary_no NUMBER(8),
 booking_no   NUMBER(8),
 prod_start   DATE,
 prod_end     DATE,
 comm_amt     NUMBER(7,2),
 CONSTRAINT commission_adhoc_pk PRIMARY KEY (sale_date, client_id, itinerary_no)
) TABLESPACE adhoc;

CREATE TABLE txp_admin.payment_adhoc
(payment_no   NUMBER(8),
 booking_no   NUMBER(8),
 sale_date    DATE,
 client_id    NUMBER(6),
 itinerary_no NUMBER(8),
 card_no      VARCHAR2(16),
 payment_amt  NUMBER(7,2),
 payment_date DATE,
 payment_desc VARCHAR2(15)
) TABLESPACE adhoc;