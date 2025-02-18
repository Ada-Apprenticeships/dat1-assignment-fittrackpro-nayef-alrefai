-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Staff Management Queries

-- 1. List all staff members by role
SELECT  
    staff.staff_id AS staff_id,  
    staff.first_name AS first_name,  
    staff.last_name AS last_name,  
    staff.position AS role  
FROM staff  
ORDER BY staff.staff_id DESC;

-- 2. Find trainers with one or more personal training session in the next 30 days
SELECT  
    staff.staff_id AS trainer_id,  
    staff.first_name || ' ' || staff.last_name AS trainer_name,  
    COUNT(personal_training_sessions.session_id) AS session_count  
FROM staff  
JOIN personal_training_sessions ON staff.staff_id = personal_training_sessions.staff_id  
WHERE staff.position = 'Trainer'  
AND personal_training_sessions.session_date BETWEEN CURRENT_DATE AND DATE(CURRENT_DATE, '+1 month')  
GROUP BY staff.staff_id, trainer_name  
HAVING COUNT(personal_training_sessions.session_id) > 0  
ORDER BY session_count DESC;

