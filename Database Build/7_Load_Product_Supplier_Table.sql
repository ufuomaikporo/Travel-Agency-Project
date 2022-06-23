-- Delete and drop tables to be used in this script 

CREATE SEQUENCE txp_admin.prod_supplier_seq
START WITH 13597
INCREMENT BY 1;

CREATE TABLE product_supplier_temp
AS SELECT * FROM product_supplier;

CREATE TABLE booking_temp
AS SELECT * FROM booking; 

ALTER TABLE booking_temp
ADD prod_supplier_new_id NUMBER(8);

TRUNCATE TABLE product_supplier;

DECLARE 

  CURSOR supplier_cursor IS
   SELECT DISTINCT(ps.prod_supplier_id),
          ps.office,
          ps.prod_category,
          ps.rep,
          ps.company AS stock,
          s.company AS company2,
          ps.affiliation_code
  FROM product_supplier_temp ps
   LEFT JOIN supplier s
   ON (ps.rep = s.supplier_id)
   ORDER BY 4;

BEGIN

  FOR record IN supplier_cursor LOOP
    IF (record.stock = record.company2) THEN
      INSERT INTO product_supplier
      VALUES (record.rep,
              record.office,
              record.prod_category,
              record.rep,  
              record.company2,
              record.affiliation_code
             );
     
      UPDATE booking_temp
      SET prod_supplier_new_id = record.rep
      WHERE prod_supplier_id = record.prod_supplier_id; 

    ELSE
      INSERT INTO product_supplier
      VALUES (txp_admin.prod_supplier_seq.NEXTVAL, 
              record.office, 
              record.prod_category, 
              record.rep, 
              record.stock,
              record.affiliation_code
             );

      UPDATE booking_temp
      SET prod_supplier_new_id = txp_admin.prod_supplier_seq.CURRVAL 
      WHERE prod_supplier_id = record.prod_supplier_id;
    
    END IF;
  END LOOP;
END;
/

TRUNCATE TABLE booking;

INSERT INTO booking
SELECT booking_no,
       itinerary_no,
       client_id,
       prod_supplier_new_id,
       office,
       prod_category,
       sale_date,
       fee_code,
       base_price,
       tax,
       prod_start,
       prod_end,
       class_code,
       agent_id,
       description
FROM booking_temp;

ALTER TABLE supplier
DROP COLUMN company;

ALTER TABLE supplier
RENAME TO rep_contact;

ALTER TABLE rep_contact
RENAME COLUMN supplier_id TO rep_id;

DROP SEQUENCE txp_admin.prod_supplier_seq;
DROP TABLE product_supplier_temp;
DROP TABLE booking_temp;

COMMIT;
