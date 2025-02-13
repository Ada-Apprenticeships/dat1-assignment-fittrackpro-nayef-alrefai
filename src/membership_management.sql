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
-- TODO: Write a query to calculate the average duration of gym visits for each membership type

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year