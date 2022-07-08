SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGES 100 LINES 130

spool 'C:\DBA\Travel_Experts\scripts\Reports\Output\Commission_Status_Report.out'

PROMPT
ACCEPT status CHAR FORMAT 'A11' PROMPT "Enter a commission status (i.e owing, outstanding, collected, or invalid): " 


TTITLE CENTER 'Travel Experts' skip 1-
       CENTER '1234 5th Ave SW' skip 1-
       CENTER 'Calgary, AB T2P 2A6' skip 1-
       CENTER 'Ph: 403 123 4567 Fax: 403 123 5678' skip 5 -
       CENTER 'Commission Status Report' skip 2 -

COL company HEADING "Company" FORMAT A40 
COL itinerary_no HEADING 'Itinerary|ID'
COL sale_date HEADING 'Sales|Date'
COL booking_no HEADING 'Booking|No'
COL rep HEADING 'Supplier|ID'
COL amount HEADING 'Comm|Due' FORMAT '$999.99'
COL status HEADING 'Comm|Status'

SELECT b.itinerary_no,
       TO_CHAR(b.sale_date, 'MM-MON-YY') AS sale_date,
       booking_no,
       ps.rep,
       ps.company,
       c.amount,
       c.status
FROM booking b
JOIN commission c
USING (booking_no)
JOIN product_supplier ps
USING (prod_supplier_id)
WHERE status = UPPER('&status')
ORDER BY 2,1;

SPOOL OFF
