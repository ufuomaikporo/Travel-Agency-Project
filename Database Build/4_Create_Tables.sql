-- Dropping tables

DROP TABLE txp_admin.client CASCADE CONSTRAINTS;
DROP TABLE txp_admin.reward_card CASCADE CONSTRAINTS;
DROP TABLE txp_admin.trip_type CASCADE CONSTRAINTS;
DROP TABLE txp_admin.applied_reward CASCADE CONSTRAINTS;
DROP TABLE txp_admin.booking CASCADE CONSTRAINTS;
DROP TABLE txp_admin.destination CASCADE CONSTRAINTS;
DROP TABLE txp_admin.commission CASCADE CONSTRAINTS;
DROP TABLE txp_admin.class CASCADE CONSTRAINTS;
DROP TABLE txp_admin.fee CASCADE CONSTRAINTS;
DROP TABLE txp_admin.affiliation CASCADE CONSTRAINTS;
DROP TABLE txp_admin.supplier CASCADE CONSTRAINTS;
DROP TABLE txp_admin.product_supplier CASCADE CONSTRAINTS;
DROP TABLE txp_admin.product CASCADE CONSTRAINTS;
DROP TABLE txp_admin.credit_card CASCADE CONSTRAINTS;
DROP TABLE txp_admin.agent CASCADE CONSTRAINTS;
DROP TABLE txp_admin.payment CASCADE CONSTRAINTS;
DROP TABLE txp_admin.trip CASCADE CONSTRAINTS;
DROP TABLE txp_admin.special_date CASCADE CONSTRAINTS;

PURGE RECYCLEBIN;

-- Table creation

CREATE TABLE txp_admin.client
(client_id      NUMBER(6) CONSTRAINT client_pk PRIMARY KEY,
 firstname      VARCHAR2(20) CONSTRAINT client_firstname_nn NOT NULL,
 lastname       VARCHAR2(20) CONSTRAINT client_lastname_nn NOT NULL,
 address        VARCHAR2(50) CONSTRAINT client_address_nn NOT NULL,
 city           VARCHAR2(30) CONSTRAINT client_city_nn NOT NULL,
 postal_code    VARCHAR2(7) CONSTRAINT client_postal_code_nn NOT NULL,
 province       VARCHAR2(30) CONSTRAINT client_province_nn NOT NULL,
 country        VARCHAR2(30) CONSTRAINT client_country_nn NOT NULL,
 email          VARCHAR2(25),
 home_phone     VARCHAR2(10),
 business_phone VARCHAR2(10),
 birthdate      DATE,
 pref_agent     NUMBER(3)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.reward_card
(card_no   VARCHAR2(16) CONSTRAINT reward_card_pk PRIMARY KEY,
 reward    VARCHAR2(30) CONSTRAINT reward_card_name_nn NOT NULL,
 client_id NUMBER(6) CONSTRAINT reward_card_client_id_nn NOT NULL
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.applied_reward
(card_no VARCHAR2(16),
 booking_no     NUMBER(8),
 comments       VARCHAR2(30),
 CONSTRAINT applied_reward_pk PRIMARY KEY (card_no, booking_no)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.trip_type
(code  VARCHAR2(1) CONSTRAINT trip_type_pk PRIMARY KEY,
 description VARCHAR2(8)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.booking
(booking_no       NUMBER(8) CONSTRAINT booking_pk PRIMARY KEY,
 itinerary_no     NUMBER(8),
 client_id        NUMBER(6),
 prod_supplier_id NUMBER(8),
 office           NUMBER(2),
 prod_category    NUMBER(3),
 sale_date        DATE CONSTRAINT booking_sale_date_nn NOT NULL,
 fee_code         VARCHAR2(3) CONSTRAINT booking_fee_code_nn NOT NULL,
 base_price       NUMBER(7,2) CONSTRAINT booking_base_price_nn NOT NULL,
 tax              NUMBER(7,2) CONSTRAINT booking_tax_nn NOT NULL,
 prod_start       DATE CONSTRAINT booking_prod_start_nn NOT NULL,
 prod_end         DATE CONSTRAINT booking_prod_end_nn NOT NULL,
 class_code       VARCHAR2(5),
 agent_id         NUMBER(3),
 description      VARCHAR2(50)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.destination
(code        VARCHAR2(5) CONSTRAINT destination_pk PRIMARY KEY,  
 description VARCHAR2(30)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.commission
(booking_no NUMBER(8) CONSTRAINT commission_pk PRIMARY KEY, 
 amount     NUMBER(7,2) CONSTRAINT commission_amount_nn NOT NULL,
 due_date   DATE CONSTRAINT commission_due_date_nn NOT NULL,
 status     VARCHAR2(11)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.class
(code        VARCHAR2(5) CONSTRAINT class_pk PRIMARY KEY,
 description VARCHAR2(20) CONSTRAINT class_description_nn NOT NULL
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.fee
(code    VARCHAR2(3) CONSTRAINT fee_pk PRIMARY KEY,
 amount      NUMBER(7,2) CONSTRAINT fee_amount_nn NOT NULL,
 description VARCHAR2(20) CONSTRAINT fee_description_nn NOT NULL
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.affiliation
(code        VARCHAR2(8) CONSTRAINT affiliation_pk PRIMARY KEY,
 description VARCHAR2(80)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.supplier
(supplier_id       NUMBER(8),
 office            NUMBER(2),
 company           VARCHAR2(80) CONSTRAINT supplier_supplier_nn NOT NULL,
 phone             VARCHAR2(10),
 address_line1     VARCHAR2(50),
 address_line2     VARCHAR2(50),
 contact_name      VARCHAR2(30),
 email             VARCHAR2(60),
 fax_no            VARCHAR2(10),
 website           VARCHAR2(60),
 city              VARCHAR2(30),
 province          VARCHAR2(30),
 country           VARCHAR2(30),
 zip_code          VARCHAR2(7),
 CONSTRAINT supplier_pk PRIMARY KEY (supplier_id, office)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.product
(category_id  NUMBER(3) CONSTRAINT product_pk PRIMARY KEY,
 description VARCHAR2(40) CONSTRAINT product_description_nn NOT NULL
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.product_supplier
(prod_supplier_id NUMBER(8),
 office           NUMBER(2) CONSTRAINT product_supplier_office_nn NOT NULL,
 prod_category    NUMBER(3) CONSTRAINT product_supplier_prod_category_nn NOT NULL,
 rep              NUMBER(8) CONSTRAINT product_supplier_supplier_id_nn NOT NULL,
 company          VARCHAR2(80) CONSTRAINT product_supplier_company_nn NOT NULL,
 affiliation_code VARCHAR2(8),
 CONSTRAINT product_supplier_pk PRIMARY KEY (prod_supplier_id, office, prod_category)
) TABLESPACE data 
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.credit_card
(card_no     VARCHAR2(16) CONSTRAINT credit_card_pk PRIMARY KEY,
 client_id   NUMBER(6) CONSTRAINT credit_card_client_id_nn NOT NULL,
 type        VARCHAR2(10) CONSTRAINT credit_card_type_nn NOT NULL,
 expiry_date DATE CONSTRAINT credit_card_expiry_date_nn NOT NULL
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.agent
(agent_id NUMBER(3) CONSTRAINT agent_pk PRIMARY KEY, 
 initials VARCHAR2(2) CONSTRAINT agent_initials_nn NOT NULL,
 firstname VARCHAR2(20) CONSTRAINT agent_firstname_nn NOT NULL,
 lastname  VARCHAR2(20) CONSTRAINT agent_lastname_nn NOT NULL
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.payment
(payment_no   NUMBER(8) CONSTRAINT payment_pk PRIMARY KEY,
 booking_no   NUMBER(8),
 client_id    NUMBER(6),
 card_no      VARCHAR2(16),
 amount       NUMBER(7,2) CONSTRAINT payment_amount_nn NOT NULL,
 payment_date DATE CONSTRAINT payment_payment_date_nn NOT NULL,
 description  VARCHAR2(15)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.trip
(itinerary_no      NUMBER(8) CONSTRAINT trip_pk PRIMARY KEY,
 client_id         NUMBER(6),
 start_date        DATE CONSTRAINT trip_start_date_nn NOT NULL,
 end_date          DATE CONSTRAINT trip_end_date_nn NOT NULL,
 dest_code         VARCHAR2(5),
 trip_type         VARCHAR2(1),
 num_of_travellers NUMBER(2),
 travellers        VARCHAR2(120)
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;

CREATE TABLE txp_admin.special_date
(id           NUMBER(6) CONSTRAINT special_date_pk PRIMARY KEY,
 client_id    NUMBER(6),
 special_date DATE CONSTRAINT special_date_date_nn NOT NULL,
 description  VARCHAR2(80) CONSTRAINT special_date_description_nn NOT NULL
) TABLESPACE data
ENABLE PRIMARY KEY USING INDEX TABLESPACE index_tbs;