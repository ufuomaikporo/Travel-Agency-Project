-- Delete and drop tables to be used in this script 

TRUNCATE TABLE supplier;

-- Create a table to hold temporary data

CREATE GLOBAL TEMPORARY TABLE supplier_temp 
(supplier_id NUMBER(8), 
 office      NUMBER(2),
 company     VARCHAR2(80), 
 rep         VARCHAR2(80)
) ON COMMIT DELETE ROWS;

DECLARE

-- Record-type variable to store each supplier record for inserts

  TYPE rep_record_type IS RECORD
  (id        supplier_adhoc.supplier_id%TYPE,
   office    supplier_adhoc.office%TYPE,
   contact   supplier_adhoc.contact_name%TYPE,
   address_1 supplier_adhoc.address_line1%TYPE,
   address_2 supplier_adhoc.address_line2%TYPE,
   city      supplier_adhoc.city%TYPE,
   province  supplier_adhoc.province%TYPE,
   zip_code  supplier_adhoc.zip_code%TYPE,
   country   supplier_adhoc.country%TYPE,
   phone     supplier_adhoc.phone%TYPE,
   fax_no    supplier_adhoc.fax_no%TYPE,
   email     supplier_adhoc.email%TYPE,
   website   supplier_adhoc.website%TYPE
  );
  rep_rec rep_record_type;

-- Cursor to looping through each unique supplier id 

  CURSOR supplier_cursor IS
    SELECT DISTINCT(supplier_id), office
    FROM product_supplier_adhoc
    ORDER BY supplier_id;

-- Declare local variables for this PLSQL block

  v_count       NUMBER(3);
  v_null_count  NUMBER(3);
  v_rep         product_supplier_adhoc.rep%TYPE;
   
BEGIN

-- Beginning of loop for looping through each unique supplier id

  FOR record IN supplier_cursor LOOP

-- Get the count for the number of entries for each supplier in the product_supplier_adhoc table

    SELECT count(supplier_id) 
    INTO v_count
    FROM product_supplier_adhoc
    WHERE supplier_id = record.supplier_id;

-- Store some info for the current supplier (in the loop) in a table temporarily

    INSERT INTO supplier_temp
      SELECT supplier_id, office, company, NVL(rep, ' ') AS rep
      FROM product_supplier_adhoc
      WHERE supplier_id = record.supplier_id;

-- Get the number of entries for the current supplier id with a null value for their representive field
    
    SELECT count(rep)
    INTO v_null_count
    FROM supplier_temp
    WHERE supplier_id = record.supplier_id
    AND rep = ' ';
    
-- IF-ELSE statement gets the name of the representative for the current supplier id

    IF (v_count > v_null_count) THEN 

      SELECT rep 
      INTO v_rep
      FROM supplier_temp
      WHERE supplier_id = record.supplier_id
      AND rep != ' '
      AND rownum = 1;

     ELSE

      SELECT company
      INTO v_rep
      FROM supplier_temp
      WHERE supplier_id = record.supplier_id
      AND rownum = 1;

     END IF; 

-- Get the supplier information and insert it into the record variable
     
     SELECT supplier_id,
             -- office,
             contact_name,
             address_line1,
             address_line2,
             city,
             province,
             zip_code,
             country,
             phone,
             fax_no,
             email,
             website
      INTO rep_rec.id,
          -- rep_rec.office,
           rep_rec.contact,
           rep_rec.address_1,
           rep_rec.address_2,
           rep_rec.city,
           rep_rec.province,
           rep_rec.zip_code,
           rep_rec.country,
           rep_rec.phone,
           rep_rec.fax_no,
           rep_rec.email,
           rep_rec.website
      FROM supplier_adhoc
      WHERE supplier_id = record.supplier_id
      AND rownum = 1;

-- Insert supplier information into supplier table

      INSERT INTO supplier
      VALUES (rep_rec.id,
              record.office,
              v_rep,
              rep_rec.phone,
              rep_rec.address_1,
              rep_rec.address_2,
              rep_rec.contact,
              rep_rec.email,
              rep_rec.fax_no,
              rep_rec.website,   
              rep_rec.city,
              rep_rec.province,
              rep_rec.country,
              rep_rec.zip_code); 
     
      COMMIT;

  END LOOP;

END;
/

DROP TABLE supplier_temp PURGE;