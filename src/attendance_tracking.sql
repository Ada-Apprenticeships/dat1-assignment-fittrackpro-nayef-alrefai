-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
/* WARNING running this will add a duplicate entry 
INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (7, 1, CURRENT_TIMESTAMP, NULL);
*/

--TESTING QUERY
SELECT * FROM attendance
WHERE member_id = 7
ORDER BY check_in_time DESC
LIMIT 5;

-- 2. Retrieve a member's attendance history
SELECT  
    DATE(check_in_time) AS visit_date,  
    TIME(check_in_time) AS check_in_time,  
    TIME(check_out_time) AS check_out_time  
FROM attendance  
WHERE member_id = 5  
ORDER BY check_in_time DESC;


-- 3. Find the busiest day of the week based on gym visits
SELECT  
    CASE strftime('%w', check_in_time)  
        WHEN '0' THEN 'Sunday'  
        WHEN '1' THEN 'Monday'  
        WHEN '2' THEN 'Tuesday'  
        WHEN '3' THEN 'Wednesday'  
        WHEN '4' THEN 'Thursday'  
        WHEN '5' THEN 'Friday'  
        WHEN '6' THEN 'Saturday'  
    END AS day_of_week,  
    COUNT(*) AS visit_count  
FROM attendance  
GROUP BY day_of_week  
ORDER BY visit_count DESC;


-- 4. Calculate the average daily attendance for each location
SELECT  
    locations.name AS location_name,  
    AVG(daily_visits.visit_count) AS avg_daily_attendance  
FROM 
    (SELECT  
        location_id,  
        DATE(check_in_time) AS visit_date,  
        COUNT(*) AS visit_count  
    FROM attendance  
    GROUP BY location_id, visit_date) 

AS daily_visits  
JOIN locations ON daily_visits.location_id = locations.location_id  
GROUP BY locations.name  
ORDER BY avg_daily_attendance DESC;

