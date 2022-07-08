SET SERVEROUTPUT ON
SET VERIFY OFF

SPOOL 'C:\DBA\Travel_Experts\scripts\Reports\Output\Add_New_Booking3.sql'

DECLARE
  ddl_stmt VARCHAR2(200);
BEGIN
  
-- Creates a a sequence to generate the booking numbers

  SELECT 'CREATE SEQUENCE txp_admin.booking_id_seq START WITH ' || MAX(booking_no) || ' INCREMENT BY 1'
  INTO ddl_stmt
  FROM booking;

  EXECUTE IMMEDIATE ddl_stmt; 

END;
/

-- Prompt user for booking info

PROMPT ************************************************************************************************
PROMPT Before booking a product for a trip, the following must be done first...
PROMPT
PROMPT 1) The customer MUST already exist (Add a new customer by running the Add_New_Customer.sql script)
PROMPT 2) the trip MUST have already been added by running the Add_New_Trip.sql script
PROMPT
PROMPT If BOTH the trip and customer already exist, then you can continue on
PROMPT ************************************************************************************************
PROMPT

ACCEPT itinerary_no NUMBER PROMPT "Enter the itinerary number for the trip this product is being booked for: "
ACCEPT sale_date DATE FORMAT 'YYYY-MM-DD' PROMPT "Enter the booking date for this product (format YYYY-MM-DD): "
ACCEPT supplier CHAR PROMPT "Enter the product supplier name: "
ACCEPT prod_category NUMBER PROMPT "Enter the product category ID: "
ACCEPT class_code CHAR FORMAT 'A5' PROMPT "Enter the product class code (i.e. FS for First Class, DELX for Deluxe): "
ACCEPT description CHAR FORMAT 'A50' PROMPT "Enter a brief description of the product: "
ACCEPT start_date DATE FORMAT 'YYYY-MM-DD' PROMPT "Enter the product start date (format YYYY-MM-DD): "
ACCEPT end_date DATE FORMAT 'YYYY-MM-DD' PROMPT "Enter the product expiry date (format YYYY-MM-DD): " 
ACCEPT fee_code CHAR PROMPT "Enter the Agency fee code for the product (i.e. Enter 'NC' for No Charge): "
ACCEPT price NUMBER PROMPT "Enter the product price EXCLUDING tax: "
ACCEPT tax NUMBER PROMPT "Enter the total product sales tax amount: "
ACCEPT commission NUMBER PROMPT "Enter the commission amount: "
ACCEPT comm_due_date DATE FORMAT 'YYYY-MM-DD' PROMPT "Enter the payment due date (format YYYY-MM-DD): "
ACCEPT agent_id NUMBER FORMAT '999' PROMPT "Enter the agent ID for the agent booking this trip: "

DECLARE

  v_null NUMBER(6);
  v_prod_supplier_id product_supplier.prod_supplier_id%TYPE;
  v_office           product_supplier.office%TYPE;
  v_company          product_supplier.company%TYPE := UPPER('&supplier');
  v_supplier_id      rep_contact.rep_id%TYPE; 
  v_prod_category    product_supplier.prod_category%TYPE;
  v_client_id        client.client_id%TYPE;
  v_client_name      VARCHAR2(40);
  v_prod_desc        product.description%TYPE;
 
BEGIN

-- Update sequence values to the very next value after the current largest booking number or itinerary number
   
  SELECT txp_admin.booking_id_seq.NEXTVAL
  INTO v_null
  FROM dual;

  SELECT prod_supplier_id, office
  INTO v_prod_supplier_id, v_office
  FROM product_supplier
  WHERE company LIKE UPPER('&supplier%')
  AND prod_category = &prod_category
  AND rownum <= 1;

 SELECT client_id, firstname || ' ' || lastname
 INTO v_client_id, v_client_name
 FROM trip
 JOIN client USING (client_id)
 WHERE itinerary_no = &&itinerary_no;

 SELECT description
 INTO v_prod_desc
 FROM product
 WHERE category_id = &prod_category;

  INSERT INTO booking
  VALUES (txp_admin.booking_id_seq.NEXTVAL,
            &itinerary_no,
            v_client_id,
            v_prod_supplier_id,
            v_office,
            &prod_category,
            '&sale_date',
            UPPER('&fee_code'),
            &price,
            &tax,
            '&start_date',
            '&end_date',
            UPPER('&class_code'),
            &agent_id,
            '&description'
           );

  INSERT INTO commission
  VALUES (txp_admin.booking_id_seq.CURRVAL,
          &commission,
          '&comm_due_date',
          'OWING'
          );

  DBMS_OUTPUT.PUT_LINE(CHR(10) || 'You''ve entered the following information for a product booking.....' || CHR(10));  
  DBMS_OUTPUT.PUT_LINE ('Itinerary No: ' || &itinerary_no);
  DBMS_OUTPUT.PUT_LINE ('Client: ' || v_client_name ||  ' - ' || v_client_id);
  DBMS_OUTPUT.PUT_LINE ('Booking No: ' || txp_admin.booking_id_seq.CURRVAL);
  DBMS_OUTPUT.PUT_LINE ('Sales Date: ' || '&sale_date');
  DBMS_OUTPUT.PUT_LINE ('Product Category: ' || v_prod_desc || ' - ' || &prod_category );
  DBMS_OUTPUT.PUT_LINE ('Fees: ' || '&fee_code');
  DBMS_OUTPUT.PUT_LINE ('Price:' || TO_CHAR(&price, '$99,999.99'));
  DBMS_OUTPUT.PUT_LINE ('Tax:' || TO_CHAR(&tax, '$999.99'));
  DBMS_OUTPUT.PUT_LINE ('Commission: ' || &commission);
  DBMS_OUTPUT.PUT_LINE ('Payment Due Date: ' || '&comm_due_date');
  DBMS_OUTPUT.PUT_LINE ('Start Date: ' || '&start_date');
  DBMS_OUTPUT.PUT_LINE ('End Date: ' || '&end_date');
  DBMS_OUTPUT.PUT_LINE ('Supplier: ' || '&supplier');
  DBMS_OUTPUT.PUT_LINE ('Product Class: ' || '&class_code');
  DBMS_OUTPUT.PUT_LINE ('Agent ID: ' || &agent_id);
  DBMS_OUTPUT.PUT_LINE ('Product Description: ' || '&description');

EXCEPTION
  
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE (CHR(10) || 'ERROR! Check that the trip itinerary number has already been added to the database');
    DBMS_OUTPUT.PUT_LINE ('Check that you entered the correct name and product category for the supplier and product');

END;
/

ACCEPT confirm PROMPT 'If the booking information is correct, press ''Y'' to save. Press ''N'' to exit without saving: '
              
BEGIN
  
  IF (UPPER('&confirm') = 'Y' OR '&confirm' = 'YES') THEN
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'A NEW booking has been added for itinerary number #' || &itinerary_no);
  ELSE 
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'The previously entered booking information was NOT saved');
  END IF;
 
END;
/

DROP SEQUENCE txp_admin.booking_id_seq;
SPOOL OFF