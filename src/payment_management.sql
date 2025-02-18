-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Payment Management Queries  

-- 1. Record a payment for a membership
--WARNING RUNNING THIS QUERY WILL ADD A COPY OF THE EXISTING PAYMENT 
 /*  
INSERT INTO payments (member_id, amount, payment_date, payment_method, payment_type)  
VALUES (  
    11,  
    50.00,  
    CURRENT_TIMESTAMP,  
    'Credit Card',  
    'Monthly membership fee'  
);  
*/

--TESTING QUERY FOR RECORD PAYMENT
SELECT * FROM payments 
WHERE member_id = 11 AND payment_type = 'Monthly membership fee'
ORDER BY payment_date DESC
LIMIT 5;

-- 2. Calculate total revenue from membership fees for each month of the last year
SELECT  
    CAST(SUBSTR(payment_date, 1, 4) AS INTEGER) AS year,    
    CAST(SUBSTR(payment_date, 6, 2) AS INTEGER) AS month,   
    SUM(amount) AS total_revenue
FROM payments  
WHERE payment_type = 'Monthly membership fee'  
AND payment_date >= DATE('now', '-12 months') AND payment_date < DATE('now', 'start of month')  
GROUP BY year, month  
ORDER BY year ASC, month ASC;

-- 3. Find all day pass purchases
SELECT  
    payment_id AS payment_id,  
    amount AS amount,  
    payment_date AS payment_date,  
    payment_method AS payment_method  
FROM payments  
WHERE payment_type = 'Day Pass'  
ORDER BY payment_date DESC;