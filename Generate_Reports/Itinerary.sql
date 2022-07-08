SET VERIFY OFF
SET SERVEROUTPUT ON
SET PAGES 999 LINES 500

SPOOL C:\DBA\Travel_Experts\scripts\Reports\Output\Itinerary_Report.out

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

-- Display Trip Details

  DBMS_OUTPUT.PUT_LINE (CHR(10) || 'Trip Details ' || CHR(10) ||
                         LPAD(' ', 8) || 'Start Date: ' || TO_CHAR(trip_record.start_date, 'DD Month YYYY') ||
                         CHR(10) ||
                         LPAD(' ', 8) || 'End Date: ' || TO_CHAR(trip_record.end_date, 'DD Month YYYY') ||
                         CHR(10) ||
                         LPAD(' ', 8) || 'Destination: ' || trip_record.dest || CHR(10)
                        );

-- Display Heading for items in the itinerary

  DBMS_OUTPUT.PUT_LINE (CHR(10) || RPAD('Supplier', 30) || RPAD('Description', 35) || 
                        RPAD('Booking No.', 15) || RPAD('Start Date', 12) || RPAD('End Date', 13) ||
                        'Price' || CHR(10)
                       ); 

-- Loop to print out each item (booked product) on the itinerary 

  FOR trip_r IN trip_cursor LOOP
      
      v_str_length := LENGTH(trip_r.company);

      IF (v_str_length > 22 ) THEN
        trip_r.company := SUBSTR(trip_r.company, 0, 25);
      END IF;

      DBMS_OUTPUT.PUT_LINE (RPAD(trip_r.company, 30) || RPAD(NVL(trip_r.description, ' '), 35) ||
                            RPAD(trip_r.booking_no, 15) || RPAD(TO_CHAR(trip_r.prod_start, 'DD/MM/YY'), 12) || 
                            RPAD(TO_CHAR(trip_r.prod_end, 'DD/MM/YY'), 12) || TO_CHAR(trip_r.base_price, '9999D00') 
                           );
  END LOOP;  

END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF
SET LINES 100

spool off