SET SERVEROUTPUT ON
SET VERIFY OFF

SPOOL 'C:\DBA\Travel_Experts\scripts\Reports\Output\Add_New_Reward_Card.sql'

PROMPT
ACCEPT client_id NUMBER FORMAT '999999' PROMPT "Enter the client ID for the owner of the reward card: " 
ACCEPT card_no CHAR PROMPT "Enter the reward card number: "
ACCEPT reward CHAR PROMPT "Enter the reward name (i.e. Aeroplan): "

DECLARE
  v_client VARCHAR2(40);
BEGIN
  
  SELECT firstname || ' ' || lastname
  INTO v_client
  FROM client
  WHERE client_id = &client_id;

  INSERT INTO reward_card
  VALUES (&card_no, UPPER('&reward'), &client_id);

  DBMS_OUTPUT.PUT_LINE ('You''ve entered the following reward card information...' || CHR(10));
  DBMS_OUTPUT.PUT_LINE ('Client: ' || v_client || ' - ' || &client_id);
  DBMS_OUTPUT.PUT_LINE ('Card No: ' || &card_no);
  DBMS_OUTPUT.PUT_LINE ('Reward Name: ' || UPPER('&reward')); 
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

SPOOL OFF