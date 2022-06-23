TRUNCATE TABLE client;
TRUNCATE TABLE product_supplier;
TRUNCATE TABLE booking;
TRUNCATE TABLE travellers_per_booking;
TRUNCATE TABLE travellers_per_trip;
TRUNCATE TABLE trip;
TRUNCATE TABLE commission;
TRUNCATE TABLE payment;
TRUNCATE TABLE trip_type;

-- Load client table

INSERT INTO client
SELECT ca.client_id,
       ca.firstname,
       ca.lastname,
       ca.address,
       ca.city,
       ca.postal_code,
       ca.province,
       ca.country,
       ca.email,
       ca.home_phone,
       ca.business_phone,
       ca.birthdate,
       a.agent_id
FROM client_adhoc ca
LEFT JOIN agent a
ON (ca.pref_agent = a.initials);

-- Load product_supplier table

INSERT INTO product_supplier
SELECT psa.prod_supplier_id,
       psa.office,
       p.category_id,
       psa.supplier_id,
       psa.company,
       psa.affiliation_code
FROM product_supplier_adhoc psa
LEFT JOIN product p
ON (psa.prod_desc = p.description);

-- Load booking table

INSERT INTO booking
SELECT ba.booking_no,
       ta.itinerary_no,
       ba.client_id,
       psa.prod_supplier_id,
       ps.office,
       ps.prod_category,
       ba.sale_date,
       ba.fee_code,
       ba.base_price,
       (ba.total_price - ba.base_price) AS tax,
       ba.prod_start,
       ba.prod_end,
       ba.class_code,
       a.agent_id,
       ba.description
FROM booking_adhoc ba
LEFT JOIN product_supplier_adhoc psa
ON (psa.product_id = ba.product_id)
  AND psa.supplier_id = ba.supplier_id
  AND psa.office = ba.office
LEFT JOIN agent a
ON ba.agent = a.initials
LEFT JOIN trip_adhoc ta
ON ba.trip_start = ta.trip_start
  AND ba.trip_end = ta.trip_end
  AND ba.client_id = ta.client_id
LEFT JOIN product_supplier ps
ON psa.prod_supplier_id = ps.prod_supplier_id;

-- Calculate the number of travellers per trip

INSERT INTO travellers_per_booking
SELECT b.itinerary_no, b.prod_category, NVL(ba.num_of_travellers,0) num_of_travellers
FROM booking b
JOIN booking_adhoc ba
USING (booking_no)
ORDER BY itinerary_no;

INSERT INTO travellers_per_trip
SELECT itinerary_no, MAX(num_of_travellers) num_of_travellers
FROM travellers_per_booking
GROUP BY itinerary_no;

-- Load trip table

INSERT INTO trip (itinerary_no, 
                  client_id, 
                  start_date, 
                  end_date, 
                  num_of_travellers,
                  dest_code)
SELECT ta.itinerary_no,
       ta.client_id,
       MIN(ba.prod_start),
       MAX(ba.prod_end),
       nt.num_of_travellers,
       d.code
FROM trip_adhoc ta
LEFT JOIN booking_adhoc ba 
ON (ta.client_id = ba.client_id)
AND (ta.trip_start = ba.trip_start)
AND (ta.trip_end = ba.trip_end)
LEFT JOIN destination d
ON (ta.dest_code = d.code)
LEFT JOIN travellers_per_trip nt
ON nt.itinerary_no = ta.itinerary_no
GROUP BY ta.itinerary_no, 
         ta.client_id, 
         nt.num_of_travellers,
         d.code;

-- Load commission table

INSERT INTO commission (booking_no, amount, due_date)
SELECT ba.booking_no,
       ca.comm_amt,
       (ca.prod_end + 60) 
FROM commission_adhoc ca
LEFT JOIN booking_adhoc ba
ON ca.sale_date = ba.sale_date
  AND ca.client_id = ba.client_id
  AND ca.itinerary_no = ba.itinerary_no;

-- Load payment table

INSERT INTO payment
SELECT pa.payment_no,
       ba.booking_no,
       pa.client_id,
       pa.card_no,
       pa.payment_amt,
       pa.payment_date,
       pa.payment_desc
FROM payment_adhoc pa
LEFT JOIN booking_adhoc ba
ON pa.sale_date = ba.sale_date
  AND pa.client_id = ba.client_id
  AND pa.itinerary_no = ba.itinerary_no;

-- Load trip_type table

INSERT INTO trip_type
VALUES ('B', 'Business');

INSERT INTO trip_type
VALUES ('L', 'Leisure');

INSERT INTO trip_type
VALUES ('G', 'Group');

COMMIT;