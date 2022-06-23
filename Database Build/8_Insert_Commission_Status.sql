UPDATE commission
SET status = 'COLLECTED';

UPDATE commission
SET status = 'OUTSTANDING'
WHERE due_date > CURRENT_DATE;

UPDATE commission
SET status = 'OWING'
WHERE booking_no IN (SELECT DISTINCT(booking_no) 
                    FROM payment 
                    WHERE description IS NULL);
    
UPDATE commission
SET status = 'INVALID'
WHERE booking_no IN (SELECT booking_no
                    FROM payment
                    WHERE description IS NOT NULL 
                    AND amount = 0); 

    