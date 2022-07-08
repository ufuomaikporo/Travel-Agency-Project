SET SERVEROUTPUT ON
SET VERIFY OFF
SET LINES 300

SPOOL 'C:\DBA\Travel_Experts\scripts\Reports\Output\Add_New_Trip.out'

PROMPT
PROMPT **************************************************************************************
PROMPT If the customer this trip is being planned for has not not been added to the database
PROMPT run the Add_New_Customer.sql script first
PROMPT **************************************************************************************
PROMPT
ACCEPT client_id NUMBER PROMPT "Enter the client ID for this trip: "
ACCEPT start_date DATE FORMAT 'YYYY-MM-DD' PROMPT "Enter the trip start date (Format YYYY-MM-DD): "
ACCEPT end_date DATE FORMAT 'YYYY-MM-DD' PROMPT "Enter the trip end date (Format YYYY-MM-DD): "
ACCEPT dest_code CHAR FORMAT 'A5' PROMPT "Enter the trip destination code (i.e. MED for Mediterranean): "
ACCEPT trip_type CHAR FORMAT 'A1' PROMPT "Enter The trip type (i.e. 'B' for Business, 'L' for Leisure, or 'G' for Group trip): "
ACCEPT num_of_travellers NUMBER FORMAT '99' PROMPT "Enter the number of travellers for this trip: "
ACCEPT travellers CHAR FORMAT 'A120' PROMPT "Enter the names of the travellers in a comma-delimited list (i.e. Jim Evans, Jane Evans,...): "
ACCEPT agent NUMBER FORMAT '999' PROMPT "Enter the agent ID for the agent booking this trip: "
PROMPT
PROMPT Is this trip being planned for a special date such as a birthday or anniversary?
PROMPT
ACCEPT special_date DATE PROMPT "Enter the special date (i.e. format: YYYY-MM-DD) or enter 1111-11-11 if not applicable: "
ACCEPT special_date_desc CHAR FORMAT 'A80' PROMPT "What is the significance of the special date (i.e. birthday, anniversary): "

DECLARE
  ddl_stmt VARCHAR2(200);
BEGIN
  
-- Creates a a sequence to generate the itinerary numbers

  SELECT 'CREATE SEQUENCE txp_admin.trip_id_seq START WITH ' || MAX(itinerary_no) || ' INCREMENT BY 1'
  INTO ddl_stmt
  FROM trip;

  EXECUTE IMMEDIATE ddl_stmt;

  SELECT 'CREATE SEQUENCE txp_admin.special_date_seq START WITH ' || NVL(MAX(id), 100) || ' INCREMENT BY 1'
  INTO ddl_stmt
  FROM special_date;

  EXECUTE IMMEDIATE ddl_stmt;

END;
/

DECLARE

  v_null NUMBER(6);
  v_client_name VARCHAR2(40);
  v_type VARCHAR2(8);
  v_dest VARCHAR2(30);
  v_start_date DATE := '&start_date';

-- User-Defined errors
  
  e_invalid_client EXCEPTION;

BEGIN
  
-- Updates the sequence for generating itinerary numbers

 SELECT txp_admin.trip_id_seq.NEXTVAL
 INTO v_null
 FROM dual; 

-- Updates the sequence for generating primary key values for special_date table

 SELECT txp_admin.special_date_seq.NEXTVAL
 INTO v_null
 FROM dual;

-- Gets the full name of the client using the client ID

 SELECT firstname || ' ' || lastname
 INTO v_client_name
 FROM client 
 WHERE client_id = &client_id;

 IF SQL%NOTFOUND THEN 
   RAISE e_invalid_client;
 END IF;

-- Gets the description for the trip type given the trip_type code

 SELECT description
 INTO v_type
 FROM trip_type
 WHERE code = UPPER('&trip_type');

 SELECT description
 INTO v_dest
 FROM destination
 WHERE code = UPPER('&dest_code');
  
 INSERT INTO trip
 VALUES (txp_admin.trip_id_seq.NEXTVAL,
         &client_id,
        '&start_date',
        '&end_date',
        UPPER('&dest_code'),
        UPPER('&trip_type'),
        &num_of_travellers,
        UPPER('&travellers')
        );

-- Add a special date to the special_date table

 IF ('&special_date' != '1111-11-11') THEN
   INSERT INTO special_date
    VALUES(txp_admin.special_date_seq.NEXTVAL, 
           &client_id, 
           '&special_date', 
           UPPER('&special_date_desc')
           ); 
 END IF;

 DBMS_OUTPUT.PUT_LINE('You have entered the following information for a new planned trip...' || CHR(10));
 DBMS_OUTPUT.PUT_LINE ('Itinerary No. --> ' || txp_admin.trip_id_seq.CURRVAL);
 DBMS_OUTPUT.PUT_LINE('Client --> ' || v_client_name );

 IF ('&special_date' != '1111-11-11') THEN
   DBMS_OUTPUT.PUT_LINE ('Special Date --> ' || TO_CHAR(TO_DATE('&special_date', 'YYYY-MM-DD'), 'DD-MON-YYYY'));
   DBMS_OUTPUT.PUT_LINE ('Special Date Description --> ' || UPPER('&special_date_desc'));
 END IF; 

 DBMS_OUTPUT.PUT_LINE ('Trip Start Date --> ' || TO_CHAR(TO_DATE('&start_date', 'YYYY-MM-DD'), 'DD-MON-YYYY'));
 DBMS_OUTPUT.PUT_LINE ('Trip End Date --> ' || TO_CHAR(TO_DATE('&end_date', 'YYYY-MM-DD'), 'DD-MON-YYYY'));
 DBMS_OUTPUT.PUT_LINE ('Destination --> ' || v_dest);
 DBMS_OUTPUT.PUT_LINE ('Trip Type --> ' || v_type);
 DBMS_OUTPUT.PUT_LINE ('Number of Travellers --> ' || &num_of_travellers);
 DBMS_OUTPUT.PUT_LINE ('Travellers --> ' || '&travellers' );

EXCEPTION

  WHEN e_invalid_client THEN
   DBMS_OUTPUT.PUT_LINE ('The client ID is invalid. Run the Add_New_Customer.sql script to Add a new client');

END;
/

ACCEPT confirm PROMPT 'If the Trip information is correct, press ''Y'' to save. Press ''N'' to exit without saving: '
              
BEGIN
  
  IF (UPPER('&confirm') = 'Y' OR '&confirm' = 'YES') THEN
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'A NEW Trip has been added. The itinerary number is ' || txp_admin.trip_id_seq.CURRVAL
                         || CHR(10) || 
                         'Make a note of the itinerary number above');
    DBMS_OUTPUT.PUT_LINE ('Run the Add_New_Booking.sql script to add each product booking individually to this trip');
  ELSE 
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'The previously entered booking information was NOT saved');
  END IF;
 
END;
/


DROP SEQUENCE txp_admin.trip_id_seq;

DROP SEQUENCE txp_admin.special_date_seq;

SET LINES 100
SPOOL OFF