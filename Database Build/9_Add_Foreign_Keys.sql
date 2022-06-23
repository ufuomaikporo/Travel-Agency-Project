-- Drop constraints

ALTER TABLE txp_admin.applied_reward DROP CONSTRAINT applied_reward_booking_fk;
ALTER TABLE txp_admin.applied_reward DROP CONSTRAINT applied_reward_reward_card_fk;
ALTER TABLE txp_admin.client DROP CONSTRAINT client_agent_fk;
ALTER TABLE txp_admin.booking DROP CONSTRAINT booking_trip_fk;
ALTER TABLE txp_admin.booking DROP CONSTRAINT booking_client_fk;
ALTER TABLE txp_admin.booking DROP CONSTRAINT booking_agent_fk;
ALTER TABLE txp_admin.booking DROP CONSTRAINT booking_product_supplier_fk;
ALTER TABLE txp_admin.booking DROP CONSTRAINT booking_fee_fk; 
ALTER TABLE txp_admin.booking DROP CONSTRAINT booking_class_fk; 
ALTER TABLE txp_admin.commission DROP CONSTRAINT commission_booking_fk;
ALTER TABLE txp_admin.credit_card DROP CONSTRAINT credit_card_client_fk; 
ALTER TABLE txp_admin.payment DROP CONSTRAINT payment_booking_fk; 
ALTER TABLE txp_admin.payment DROP CONSTRAINT payment_credit_card_fk; 
ALTER TABLE txp_admin.payment DROP CONSTRAINT payment_client_fk; 
ALTER TABLE txp_admin.product_supplier DROP CONSTRAINT product_supplier_supplier_fk;
ALTER TABLE txp_admin.product_supplier DROP CONSTRAINT product_supplier_product_fk; 
ALTER TABLE txp_admin.reward_card DROP CONSTRAINT reward_card_client_fk; 
ALTER TABLE txp_admin.product_supplier DROP CONSTRAINT product_supplier_affiliation_fk;
ALTER TABLE txp_admin.trip DROP CONSTRAINT trip_client_fk;
ALTER TABLE txp_admin.trip DROP CONSTRAINT trip_trip_type_fk; 
ALTER TABLE txp_admin.trip DROP CONSTRAINT trip_destination_fk;
ALTER TABLE txp_admin.special_date DROP CONSTRAINT special_date_client_fk;

-- Delete not null constraint from commission table

ALTER TABLE txp_admin.commission DROP CONSTRAINT commission_status_nn;

-- Add not null constraint to commission table

ALTER TABLE txp_admin.commission 
MODIFY status CONSTRAINT commission_status_nn NOT NULL;

-- Add foreign keys to tables

ALTER TABLE txp_admin.applied_reward
ADD CONSTRAINT applied_reward_booking_fk FOREIGN KEY (booking_no)
    REFERENCES booking (booking_no) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.applied_reward
ADD CONSTRAINT applied_reward_reward_card_fk FOREIGN KEY (card_no)
    REFERENCES reward_card (card_no) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.booking
ADD CONSTRAINT booking_trip_fk FOREIGN KEY (itinerary_no)
    REFERENCES trip(itinerary_no) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.booking
ADD CONSTRAINT booking_client_fk FOREIGN KEY (client_id)
    REFERENCES client(client_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.booking
ADD CONSTRAINT booking_agent_fk FOREIGN KEY (agent_id)
    REFERENCES agent(agent_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.booking
ADD CONSTRAINT booking_product_supplier_fk FOREIGN KEY (prod_supplier_id, office, prod_category)
    REFERENCES product_supplier(prod_supplier_id, office, prod_category) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.booking
ADD CONSTRAINT booking_fee_fk FOREIGN KEY (fee_code)
    REFERENCES fee(code) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.booking
ADD CONSTRAINT booking_class_fk FOREIGN KEY (class_code)
    REFERENCES class(code) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.client
ADD CONSTRAINT client_agent_fk FOREIGN KEY (pref_agent)
    REFERENCES agent(agent_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.commission
ADD CONSTRAINT commission_booking_fk FOREIGN KEY (booking_no)
    REFERENCES booking(booking_no) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.credit_card
ADD CONSTRAINT credit_card_client_fk FOREIGN KEY (client_id)
    REFERENCES client (client_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.payment
ADD CONSTRAINT payment_booking_fk FOREIGN KEY (booking_no)
    REFERENCES booking (booking_no) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.payment
ADD CONSTRAINT payment_credit_card_fk FOREIGN KEY (card_no)
    REFERENCES credit_card (card_no) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.payment
ADD CONSTRAINT payment_client_fk FOREIGN KEY (client_id)
    REFERENCES client(client_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.product_supplier
ADD CONSTRAINT product_supplier_supplier_fk FOREIGN KEY (rep, office)
    REFERENCES rep_contact (rep_id, office) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.product_supplier
ADD CONSTRAINT product_supplier_product_fk FOREIGN KEY (prod_category)
    REFERENCES product (category_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.product_supplier
ADD CONSTRAINT product_supplier_affiliation_fk FOREIGN KEY (affiliation_code)
    REFERENCES affiliation(code) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.reward_card
ADD CONSTRAINT reward_card_client_fk FOREIGN KEY(client_id)
    REFERENCES client(client_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.trip
ADD CONSTRAINT trip_client_fk FOREIGN KEY (client_id)
    REFERENCES client (client_id) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.trip
ADD CONSTRAINT trip_trip_type_fk FOREIGN KEY (trip_type)
    REFERENCES trip_type (code) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.trip
ADD CONSTRAINT trip_destination_fk FOREIGN KEY (dest_code)
    REFERENCES destination (code) DEFERRABLE ENABLE VALIDATE;

ALTER TABLE txp_admin.special_date
ADD CONSTRAINT special_date_client_fk FOREIGN KEY (client_id)
    REFERENCES client (client_id) DEFERRABLE ENABLE VALIDATE;