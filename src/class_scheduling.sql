-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
SELECT  
    c.class_id AS class_id,  
    c.name AS class_name,  
    s.first_name || ' ' || s.last_name AS instructor_name  
FROM class_schedule AS cs  
JOIN classes AS c ON cs.class_id = c.class_id  
JOIN staff AS s ON cs.staff_id = s.staff_id  
ORDER BY c.class_id ASC;

-- 2. Find available classes for a specific date
SELECT  
    c.class_id AS class_id,  
    c.name AS class_name,  
    cs.start_time AS start_time,  
    cs.end_time AS end_time,  
    (c.capacity - COUNT(ca.member_id)) AS available_spots  
FROM class_schedule AS cs  
JOIN classes AS c ON cs.class_id = c.class_id  
JOIN class_attendance AS ca ON cs.schedule_id = ca.schedule_id  
WHERE DATE(cs.start_time) = '2025-02-01'  
GROUP BY c.class_id, c.name, cs.start_time, cs.end_time, c.capacity  
ORDER BY cs.start_time ASC;

-- 3. Register a member for a class
--WARNING running this will register the member again

/*INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES (7, 11, 'Registered');*/

SELECT * FROM class_attendance 
WHERE member_id = 11
ORDER BY schedule_id DESC;

-- 4. Cancel a class registration
--TESTING QUERY check registration for member 11
SELECT *  
FROM class_attendance  
WHERE member_id = 11  
ORDER BY schedule_id DESC;

 
DELETE FROM class_attendance  
WHERE class_attendance_id = 15;  


-- 5. List top 5 most popular classes
WITH class_registrations AS (
    SELECT  
        cs.class_id AS class_id,  
        COUNT(ca.attendance_status) AS registration_count  
    FROM class_schedule AS cs  
    LEFT JOIN class_attendance AS ca ON cs.schedule_id = ca.schedule_id  
    GROUP BY cs.class_id  
)  
SELECT  
    c.class_id AS class_id,  
    c.name AS class_name,  
    COALESCE(cr.registration_count, 0) AS registration_count  
FROM classes AS c  
LEFT JOIN class_registrations AS cr ON c.class_id = cr.class_id  
ORDER BY cr.registration_count DESC  
LIMIT 5;


-- 6. Calculate average number of classes per member
SELECT 
    ROUND((COUNT(CASE WHEN ca.attendance_status = 'Attended' THEN 1 END) * 1.0) / 
    (SELECT COUNT(*) FROM members), 2) AS avg_classes_per_member
FROM class_attendance AS ca;

