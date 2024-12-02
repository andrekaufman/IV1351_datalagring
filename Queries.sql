--Task 1:

SELECT
    TO_CHAR(time, 'Mon') AS Month,
    COUNT(*) AS Total,
    SUM(lesson_id IN (SELECT lesson_id FROM individuallesson)::INT) AS Individual,
    SUM(lesson_id IN (SELECT lesson_id FROM grouplesson)::INT) AS "Group", 
    SUM(lesson_id IN (SELECT lesson_id FROM ensemblelesson)::INT) AS Ensemble
FROM lesson
WHERE EXTRACT(YEAR FROM time) = 2024
GROUP BY TO_CHAR(time, 'Mon')
ORDER BY TO_DATE(TO_CHAR(time, 'Mon'), 'Mon');




--Task 2:

SELECT no_of_siblings AS "No of Siblings", 
COUNT(*) AS "No of Students"
FROM (SELECT s.student_id, COUNT(ss.sibling_id) AS no_of_siblings
FROM student s
LEFT JOIN student_sibling ss
ON s.student_id = ss.student_id
    GROUP BY s.student_id
) SiblingCounts
GROUP BY no_of_siblings
ORDER BY no_of_siblings;




--Task 3:

SELECT
    i.instructor_id AS "Instructor Id",
    SPLIT_PART(i.name, ' ', 1) AS "First Name",
    SPLIT_PART(i.name, ' ', 2) AS "Last Name",
    COUNT(l.lesson_id) AS "No of Lessons"
FROM instructor i
JOIN lesson l
    ON i.instructor_id = l.instructor_id
WHERE DATE_PART('year', l.time) = DATE_PART('year', CURRENT_DATE)
  AND DATE_PART('month', l.time) = DATE_PART('month', CURRENT_DATE)
GROUP BY i.instructor_id, i.name
HAVING COUNT(l.lesson_id) > 2
ORDER BY "No of Lessons" DESC; 




--Task 4:

1) CREATE VIEW ensemble_seat_availability AS SELECT l.lesson_id, TO_CHAR(l.time, 'Day') AS day_of_week, e.genre, l.time, l.capacity - COALESCE(COUNT(sl.student_id), 0) AS free_seats FROM lesson l JOIN ensemblelesson e ON l.lesson_id = e.lesson_id LEFT JOIN student_lesson sl ON l.lesson_id = sl.lesson_id GROUP BY l.lesson_id, l.time, e.genre, l.capacity;

2) SELECT
    day_of_week AS "Day",
    genre AS "Genre",
    CASE
        WHEN free_seats = 0 THEN 'No Seats'
        WHEN free_seats BETWEEN 1 AND 2 THEN '1 or 2 Seats'
        ELSE 'Many Seats'
    END AS "No of Free Seats"
FROM ensemble_seat_availability
WHERE time >= CURRENT_DATE
  AND time < CURRENT_DATE + INTERVAL '7 days'
ORDER BY genre




-- Solution without a view:

SELECT TO_CHAR(l.time, 'Day') AS "Day", e.genre AS "Genre", CASE WHEN (l.capacity - COALESCE(COUNT(sl.student_id), 0)) = 0 THEN 'No Seats' WHEN (l.capacity - COALESCE(COUNT(sl.student_id), 0)) BETWEEN 1 AND 2 THEN '1 or 2 Seats' ELSE 'Many Seats' END AS "No of Free Seats" FROM lesson l JOIN ensemblelesson e ON l.lesson_id = e.lesson_id LEFT JOIN student_lesson sl ON l.lesson_id = sl.lesson_id WHERE l.time >= CURRENT_DATE AND l.time < CURRENT_DATE + INTERVAL '7 days' GROUP BY l.lesson_id, l.time, l.capacity, e.genre ORDER BY EXTRACT(DOW FROM l.time);


