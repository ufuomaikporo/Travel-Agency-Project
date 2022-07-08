SET VERIFY OFF
SET SERVEROUTPUT ON
SET PAGES 999 LINES 500

SPOOL C:\DBA\Travel_Experts\scripts\Reports\Output\Invoice_Report.out

-- Prompt user for an itinerary number as input

PROMPT
ACCEPT trip_num PROMPT 'Please enter an itinerary number (trip identifier): '
PROMPT

DECLARE

-- Define record-type variable to store a client record

  TYPE client_record_type IS RECORD
    (id       client.client_id%TYPE,
     fname    client.firstname%TYPE,
     lname    client.lastname%TYPE,
     address  client.address%TYPE,
     city     client.city%TYPE,
     province client.province%TYPE,
     pcode    client.postal_code%TYPE);
     client_rec client_record_type;

-- Define record-type variable to store some itinerary (agent name, # of passengers)

  TYPE agent_record_type IS RECORD
  (id    agent.agent_id%TYPE,
   fname agent.firstname%TYPE,
   lname agent.lastname%TYPE);
  agent_record agent_record_type;

-- Define record type variable to store trip info

  TYPE trip_record_type IS RECORD
  (start_date  trip.start_date%TYPE,
   end_date    trip.end_date%TYPE,
   passengers trip.travellers%TYPE,
   dest       destination.description%TYPE);
  trip_record trip_record_type;

-- Define record-type variable to store booking info

  TYPE booking_record_type IS RECORD
  (id            booking.booking_no%TYPE,
   supplier_name product_supplier.company%TYPE,
   start_date    booking.prod_start%TYPE,
   end_date      booking.prod_end%TYPE,
   price         booking.base_price%TYPE,
   description   booking.description%TYPE);
  booking_rec booking_record_type;

-- Define record-type variable to store the all price

  TYPE price_record_type IS RECORD
  (base_price booking.base_price%TYPE,
   fees       fee.amount%TYPE,
   tax        booking.tax%TYPE);
  price_rec price_record_type;

-- Define a cursor to hold all products booked for a trip
 
  CURSOR trip_cursor IS
    SELECT DISTINCT(b.booking_no), ps.company, b.description, b.prod_start, b.prod_end, b.base_price
    FROM txp_admin.booking b
    JOIN txp_admin.product_supplier ps
    USING (prod_supplier_id)
    JOIN rep_contact s
    ON (ps.rep = s.rep_id)
    WHERE itinerary_no = &trip_num;

-- Define a cursor to cycle through each client with a reward card

  CURSOR r_client_cursor IS
   SELECT DISTINCT(b.client_id), c.firstname, c.lastname
     FROM applied_reward ap
     JOIN booking b USING (booking_no)
     JOIN client c ON (c.client_id = b.client_id)
     JOIN reward_card rc USING (card_no)
     WHERE itinerary_no = &trip_num;

-- Define local variables

  v_agent_id   agent.agent_id%TYPE;      -- stores agent id
  v_null       NUMBER(3);                -- holds an irrelevant value (filler)
  v_str_length NUMBER(3);                -- holds the length of a string
  v_rcard_no   reward_card.card_no%TYPE; -- holds a reward card number
  v_reward     reward_card.reward%TYPE;  -- holds the reward card name
  v_ccard_no   credit_card.card_no%TYPE; -- holds credit card number
  v_ccard_type credit_card.type%TYPE;    -- holds credit card type (i.e VISA, MASTERCARD)
  
BEGIN

-- Get client info and insert it into client_record

 SELECT client_id, firstname, lastname, address, city, province, postal_code
  INTO client_rec
  FROM client c
  JOIN trip t USING (client_id)
  WHERE itinerary_no = &trip_num;

-- Get the agent id and number of travellers for the trip

SELECT agent_id, travellers, COUNT(agent_id)
INTO agent_record.id, trip_record.passengers, v_null
 FROM booking b
 JOIN trip t USING (itinerary_no)
 WHERE itinerary_no = &trip_num
 GROUP BY agent_id, travellers
 HAVING COUNT(agent_id) = 
 (SELECT MAX(COUNT(agent_id))
  FROM booking  b
  JOIN trip t USING (itinerary_no)
  WHERE itinerary_no = &trip_num
  GROUP BY agent_id);

-- Get agent name and insert name into agent_record

  SELECT firstname, lastname
  INTO agent_record.fname, agent_record.lname
  FROM agent
  WHERE agent_id = agent_record.id;

-- Get trip info and insert into trip_record variable

  SELECT start_date, end_date, description
  INTO trip_record.start_date, trip_record.end_date, trip_record.dest
  FROM trip t
  JOIN destination d 
  ON (dest_code = code)
  WHERE itinerary_no = &trip_num;

-- Display Travel Agency header

  DBMS_OUTPUT.PUT_LINE (CHR(10) || LPAD(' ', 22) || 'TRAVEL EXPERTS' || CHR(10) || 
                        LPAD(' ', 22) || '1155 8th Ave S.W.' || CHR(10) || 
                        LPAD(' ', 22) || 'Calgary, AB. T2P 1N3' || CHR(10) || 
                        LPAD(' ', 22) || 'Ph: 403-271-9873 Fax: 403-271-9872' || CHR(10));
 
  DBMS_OUTPUT.PUT_LINE(CHR(10));

-- Display Customer info and general itinerary info

  DBMS_OUTPUT.PUT_LINE (RPAD('To: ', 50, ' ') || 'Date: ' || TO_CHAR(CURRENT_DATE, 'DD Mon YYYY') ||
                        CHR(10) || 
                        LPAD(' ', 8) || client_rec.fname || ' ' || RPAD(client_rec.lname, 41 - LENGTH(client_rec.fname), ' ') || 
                        'Consultant: ' || agent_record.fname || ' ' || agent_record.lname ||
                        CHR(10) ||
                        LPAD(' ', 8) || RPAD(client_rec.address, 42, ' ') || 
                        'Customer No: ' || client_rec.id ||
                        CHR(10) ||
                        LPAD(' ', 8) || client_rec.city || ', ' || RPAD(client_rec.province, 40 - LENGTH(client_rec.city), ' ') ||
                        'Passengers: ' || trip_record.passengers || 
                        CHR(10) ||
                        LPAD(' ', 8) ||RPAD(client_rec.pcode, 42, ' ') ||
                        'Invoice/Itinerary No. ' || &trip_num ||
                        CHR(10)
                        ); 

-- Display second paragraph of invoice "Prepared for: ..."

  DBMS_OUTPUT.PUT_LINE (CHR(10) || 'Prepared for: ' || CHR(10) || 
                       LPAD(' ', 8) ||  client_rec.fname || ' ' || client_rec.lname
                      );

-- Display "Trip Details"

  DBMS_OUTPUT.PUT_LINE (CHR(10) || 'Trip Details ' || CHR(10) ||
                         LPAD(' ', 8) || 'Start Date: ' || TO_CHAR(trip_record.start_date, 'DD Month YYYY') ||
                         CHR(10) ||
                         LPAD(' ', 8) || 'End Date: ' || TO_CHAR(trip_record.end_date, 'DD Month YYYY') ||
                         CHR(10) ||
                         LPAD(' ', 8) || 'Destination: ' || trip_record.dest || CHR(10)
                        );

-- Nested loop printing out applied rewards. Outer loop prints card holder name

  FOR client_r IN r_client_cursor LOOP
    
    DBMS_OUTPUT.PUT_LINE (CHR(10) || 'For your convenience, the following reward numbers were applied: ' || 
                         CHR(10) || client_r.firstname || ' ' || client_r.lastname);

-- Inner loop prints the reward card info
              
    FOR trip_r IN trip_cursor LOOP
      
      SELECT rc.reward, card_no
      INTO v_reward, v_rcard_no
      FROM applied_reward ap
      JOIN booking b
      USING (booking_no)
      JOIN reward_card rc
      USING (card_no)
      JOIN client c
      ON (b.client_id = c.client_id)
      WHERE booking_no IN 
        (SELECT booking_no
         FROM booking
         WHERE itinerary_no = &trip_num
         ) 
      AND rc.client_id = client_r.client_id;

      DBMS_OUTPUT.PUT_LINE (CHR(10) || LPAD(' ', 3) || RPAD(v_reward, 20) || 
                            RPAD(v_rcard_no, 20)
                           );
    END LOOP;  -- End of inner loop

  END LOOP;   -- End of outer loop

-- Display Price info
  
  SELECT SUM(b.base_price), SUM(f.amount), SUM(tax)
  INTO price_rec.base_price, price_rec.fees, price_rec.tax
  FROM booking b
  JOIN fee f ON (b.fee_code = f.code)
  WHERE itinerary_no = &trip_num;
  
  DBMS_OUTPUT.PUT_LINE (CHR(10) || 'Trip Total ' || CHR(10) ||
                        LPAD(' ', 3) || RPAD('Subtotal: ', 9) || TO_CHAR(price_rec.base_price, '$999G999D00') || CHR(10) ||
                        LPAD(' ', 3) || RPAD('Fees: ', 9) || TO_CHAR(price_rec.fees, '$999G999D00') || CHR(10) ||
                        LPAD(' ', 3) || RPAD('Tax: ', 9) || TO_CHAR(price_rec.tax, '$999G999D00') 
                        );

-- Display credit card info

  SELECT type, card_no
  INTO v_ccard_type, v_ccard_no
  FROM credit_card
  WHERE client_id = client_rec.id
   AND rownum < 2;
 
  DBMS_OUTPUT.PUT_LINE (CHR(10) || RPAD('Bill to: ', 15) || v_ccard_type || ' ' || v_ccard_no);

END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF
SET LINES 100

SPOOL OFF