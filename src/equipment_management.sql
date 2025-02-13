-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Equipment Management Queries

-- 1. Find equipment due for maintenance
SELECT  
    equipment_id AS equipment_id,  
    name AS name,  
    next_maintenance_date AS next_maintenance_date  
FROM equipment  
WHERE next_maintenance_date BETWEEN CURRENT_DATE AND DATE(CURRENT_DATE, '+30 days')  
ORDER BY next_maintenance_date ASC;

-- 2. Count equipment types in stock
SELECT  
    type AS equipment_type,  
    COUNT(*) AS count  
FROM equipment  
GROUP BY type  
ORDER BY count DESC;

-- 3. Calculate average age of equipment by type (in days)
SELECT  
    type AS equipment_type,  
    ROUND(AVG(JULIANDAY(CURRENT_DATE) - JULIANDAY(purchase_date)), 2) AS avg_age_days  
FROM equipment  
GROUP BY type  
ORDER BY avg_age_days DESC;