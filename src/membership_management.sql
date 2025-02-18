-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries

-- 1. List all active memberships
SELECT  
    members.member_id AS member_id,  
    members.first_name AS first_name,  
    members.last_name AS last_name,  
    memberships.type AS membership_type,  
    memberships.start_date AS join_date  
FROM members  
JOIN memberships ON members.member_id = memberships.member_id  
WHERE memberships.status = 'Active'  
ORDER BY memberships.start_date DESC;

-- 2. Calculate the average duration of gym visits for each membership type
SELECT  
    memberships.type AS membership_type,  
    ROUND(AVG((strftime('%s', attendance.check_out_time) - strftime('%s', attendance.check_in_time)) / 60.0), 2) AS avg_visit_duration_minutes  
FROM attendance  
JOIN members ON attendance.member_id = members.member_id  
JOIN memberships ON members.member_id = memberships.member_id  
WHERE attendance.check_out_time IS NOT NULL  
GROUP BY memberships.type  
ORDER BY avg_visit_duration_minutes DESC;

-- 3. Identify members with expiring memberships this year
SELECT  
    members.member_id AS member_id,  
    members.first_name AS first_name,  
    members.last_name AS last_name,  
    members.email AS email,  
    memberships.end_date AS end_date  
FROM members  
JOIN memberships ON members.member_id = memberships.member_id  
WHERE memberships.end_date > CURRENT_DATE  
AND memberships.end_date <= DATE(CURRENT_DATE, '+12 months')  
ORDER BY memberships.end_date ASC;

