SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGES 999 LINES 500

SPOOL 'C:\DBA\Travel_Experts\scripts\Reports\Output\Add_New_Customer.out'

DECLARE
  ddl_stmt VARCHAR2(200);
BEGIN
  
-- Creates a a sequence to generate the client id numbers

  SELECT 'CREATE SEQUENCE txp_admin.client_id_seq START WITH ' || MAX(client_id) || ' INCREMENT BY 1'
  INTO ddl_stmt
  FROM client;

  EXECUTE IMMEDIATE ddl_stmt;  

END;
/
-- Prompt user to enter new customer info

PROMPT
PROMPT 'Please enter the new customer information below'
PROMPT
ACCEPT fname CHAR FORMAT 'A20' PROMPT 'Enter the customer''s first name: '
ACCEPT lname CHAR FORMAT 'A20' PROMPT 'Enter the customer''s last name: '
ACCEPT home_phone CHAR FORMAT 'A10' PROMPT 'Enter the customer''s home phone number without hyphens (i.e. 4034664556): '
ACCEPT business_phone CHAR FORMAT 'A10' PROMPT 'Enter the customer''s business phone number without hyphens (i.e. 4034664556): '
ACCEPT address CHAR FORMAT 'A50' PROMPT 'Enter the customer''s street number and address: '
ACCEPT city CHAR FORMAT 'A30' PROMPT 'Enter the customer''s city: '
ACCEPT postal_code CHAR FORMAT 'A7' PROMPT 'Enter the customer postal code or zipcode: '
ACCEPT province CHAR FORMAT 'A30' PROMPT 'Enter the customer''s province or state initials (i.e. AB for Alberta): '
ACCEPT country CHAR FORMAT 'A30' PROMPT 'Enter the customer''s country: '
ACCEPT email CHAR FORMAT 'A25' PROMPT 'Enter the customer''s email address: '
ACCEPT birthdate DATE FORMAT 'YYYY-MM-DD' PROMPT 'Enter the customer birthdate in the format ''YYYY-MM-DD'': '
ACCEPT pref_agent NUMBER FORMAT '999' PROMPT 'Enter the agent ID for the customer: '

DECLARE
  v_null NUMBER(6);
BEGIN

-- Inserts input values from user into the client table

   SELECT txp_admin.client_id_seq.NEXTVAL INTO v_null
   FROM dual;

  INSERT INTO txp_admin.client 
  VALUES (txp_admin.client_id_seq.NEXTVAL, 
          INITCAP('&fname'),
          INITCAP('&lname'), 
          '&address',
          INITCAP('&city'),
          UPPER('&postal_code'),
          UPPER('&province'),
          INITCAP('&country'),
          '&email',
          '&home_phone', 
          '&business_phone',
          '&birthdate',
          &pref_agent
          ); 

-- Prints the users input to screen

  DBMS_OUTPUT.PUT_LINE (CHR(10) || 'You''ve enterd the following information for client ID: ' || client_id_seq.CURRVAL || 
                        CHR(10) || CHR(10) || 'NAME: ' || INITCAP('&fname') || ' ' || INITCAP('&lname') || 
                        CHR(10) || 'ADDRESS: ' || '&address' || ' ' || INITCAP('&city') || ', ' || 
                        UPPER('&province') ||' ' || UPPER('&postal_code') || ', ' || INITCAP('&country') || 
                        CHR(10) || 'HOME PHONE: ' || 
                        SUBSTR('&home_phone', 0, 3) || '-' ||
                        SUBSTR('&home_phone', 4, 3) || '-' || SUBSTR('&home_phone', 6, 4) ||
                        CHR(10) || 'BUSINESS PHONE: ' ||
                        SUBSTR('&business_phone', 0, 3) || '-' || 
                        SUBSTR('&business_phone', 4, 3)  || '-' || SUBSTR('&business_phone', 6, 4) ||
                        CHR(10) || 'BIRTHDATE: ' || TO_CHAR(TO_DATE('&birthdate', 'YYYY-MM-DD'), 'MonthDD YYYY') ||
                        CHR(10) || 'AGENT: ' || &pref_agent
                       ); 
              
END;
/ 

ACCEPT confirm PROMPT 'If the customer information is correct, press ''Y'' to save. Press ''N'' to exit without saving: '
              
BEGIN
  
  IF (UPPER('&confirm') = 'Y' OR '&confirm' = 'YES') THEN
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'A NEW customer has been added to the client table');
  ELSE 
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'The customer information was NOT saved');
  END IF;
 
END;
/

DROP SEQUENCE client_id_seq;

SPOOL OFF
