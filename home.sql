
-- HOMEWORK

DROP DATABASE IF EXISTS "university";

CREATE DATABASE "university";

\c university;

DROP TABLE IF EXISTS teachers;

CREATE TABLE teachers (
    "id" SERIAL PRIMARY KEY,
    "full_name" VARCHAR(100) NOT NULL,
    "birth_date" DATE NOT NULL,
    "city" VARCHAR(100) NOT NULL
);

INSERT INTO teachers ("full_name", "birth_date", "city") 
VALUES ('Ilham Davlatov', '1980-01-01', 'Tashkent'),
       ('Polat Kamolov', '1975-02-02', 'Bukhara'),
       ('Marjona Sidorova', '1985-03-03', 'Samarkand'),
       ('Shahzod Shermatov', '1980-01-01', 'Bukhara'),
       ('Ahmed Saidov', '1980-01-01', 'Tashkent'),
       ('Oqgul Bekova', '1979-01-09', 'Samarkand');

SELECT * FROM teachers;

DROP TABLE IF EXISTS lessons;

CREATE TABLE lessons (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    "teacher_id" INT REFERENCES teachers("id") ON DELETE SET NULL
);

INSERT INTO lessons ("name", "teacher_id") 
VALUES ('Math', 1),
       ('English', 2),
       ('Chemistry', 3),
       ('Literature', 4),
       ('History', 5),
       ('Physics', 6);

SELECT * FROM lessons;


DROP TABLE IF EXISTS "student";

CREATE TABLE students (
    "id" SERIAL PRIMARY KEY,
    "full_name" VARCHAR(100) NOT NULL,
    "birth_date" DATE NOT NULL,
    "city" VARCHAR(100) NOT NULL
);

INSERT INTO students ("full_name", "birth_date", "city") 
VALUES
('Azizbek Karimov', '1998-04-12', 'Tashkent'),
('Dilshod Akramov', '1997-09-21', 'Andijon'),
('Shahnoza Ismoilova', '2000-01-30', 'Fargona'),
('Jasur Tursunov', '1996-06-18', 'Samarkand'),
('Madina Qodirova', '1999-11-05', 'Bukhara'),
('Bekzod Rasulov', '1995-03-14', 'Tashkent'),
('Nilufar Sobirova', '2001-08-27', 'Nukus'),
('Sardor Alimuhamedov', '1997-12-09', 'Bukhara'),
('Umida Ergasheva', '1998-02-22', 'Fargona'),
('Oybek Shukurov', '1996-07-01', 'Andijon'),
('Gulnoza Xolmatova', '2000-05-16', 'Samarkand'),
('Rustam Yuldashev', '1995-10-10', 'Nukus'),
('Ziyoda Mamatkulova', '1999-09-03', 'Tashkent'),
('Anvar Bekmuradov', '1997-01-19', 'Bukhara'),
('Feruza Abdullaeva', '2001-06-25', 'Nukus');
('Joshqin Muhamedov', '2001-12-22', 'Fargona'),
('Jumagul Shuxratova', '1996-07-01', 'Bukhara'),
('Hilola Mirzoyoyeva', '2000-05-26', 'Samarkand'),
('Ismoil Komiljanov', '2003-06-02', 'Khorezm'),
('Diyorbek Ismoilov', '2003-09-05', 'Khorezm'),
('Ganisher Aliyev', '2003-09-25', 'Khorezm'),
('Dilmurod Ogabekov', '2001-06-25', 'Samarkand');

SELECT * FROM students;
       

DROP TABLE IF EXISTS grades;

CREATE TABLE grades (
    "id" SERIAL PRIMARY KEY,
    "student_id" INT REFERENCES students(id) ON DELETE CASCADE,
    "lesson_id" INT REFERENCES lessons(id) ON DELETE CASCADE,
    "grade" INT CHECK ("grade" BETWEEN 0 AND 100)
);

-- INSERT INTO grades ("student_id", "lesson_id", "grade")
-- VALUES (1, 1, 90),
--        (1, 2, 80),
--        (1, 3, 70),
--        (1, 4, 90),
--        (1, 5, 80),   
--        (1, 6, 70),
--        (2, 1, 80),
--        (2, 2, 90),
--        (2, 3, 80),
--        (2, 4, 90),   
--        (2, 5, 80),
--        (2, 6, 70),
--        (3, 1, 90),
--        (3, 2, 80),   
--        (3, 3, 70),
--        (3, 4, 90),   
--        (3, 5, 80),
--        (3, 6, 70),

INSERT INTO grades ("student_id", "lesson_id", "grade")
SELECT
    s.id,
    l.id,
    (random() * 40 + 60)::int
FROM students s
CROSS JOIN lessons l;

SELECT * FROM grades ORDER BY student_id, lesson_id;



SELECT COUNT(*) FROM students WHERE "birth_date" > '2000-01-01';

SELECT id, full_name, city FROM students WHERE "birth_date" > '2000-01-01';

SELECT * FROM lessons ORDER BY "name" ASC;

SELECT * FROM students LIMIT 5;

SELECT * FROM students OFFSET 3 LIMIT 4;

\d+ teachers;

\d+ lessons;

\d+ students;

\d+ grades;

SELECT AVG(grade) FROM grades;

SELECT avg(grade) FROM grades WHERE "student_id" = 1;

SELECT AVG(EXTRACT(YEAR FROM birth_date)) AS avg_birth_year
FROM students;

SELECT AVG(EXTRACT(YEAR FROM AGE(birth_date))) AS avg_age
FROM students;

SELECT MAX("birth_date") FROM students;

SELECT MIN("birth_date") FROM students;

SELECT MAX(EXTRACT(YEAR FROM AGE(birth_date))) AS max_age
FROM students;

SELECT MIN(EXTRACT(YEAR FROM AGE(birth_date))) AS min_age
FROM students;

SELECT EXTRACT(YEAR FROM AGE(birth_date)) AS all_age
FROM students;


-- 1 INDEX indexlash 

-- student 

CREATE INDEX index_students_full_name ON students("full_name");

CREATE INDEX index_students_city ON students("city");

CREATE INDEX index_students_id ON students("id");

-- teacher 

CREATE INDEX index_teachers_full_name ON teachers("full_name");

CREATE INDEX index_teachers_id ON teachers("id");

CREATE INDEX index_teachers_city ON teachers("city");

-- lesson

CREATE INDEX index_lessons_name ON lessons("name");


-- 2  ORDER BY AND GROUP BY

-- DESC

SELECT student.full_name, AVG(grade.grade) AS avg_grade
FROM students student
JOIN grades grade ON student.id = grade.student_id
GROUP BY student.id, student.full_name
ORDER BY avg_grade DESC;

-- ASC

SELECT student.full_name, AVG(grade.grade) AS avg_grade
FROM students student
JOIN grades grade ON student.id = grade.student_id
GROUP BY student.id, student.full_name
ORDER BY avg_grade ASC;

-- 3  OFFSET LIMIT

SELECT student.full_name, AVG(grade.grade) AS avg_grade
FROM students student
JOIN grades grade ON student.id = grade.student_id
GROUP BY student.id, student.full_name
ORDER BY avg_grade DESC OFFSET 5 LIMIT 10;

-- 4 GROUP BY

SELECT
    "city",
    COUNT(*) AS people_count
FROM (
    SELECT "city" FROM students
    UNION ALL
    SELECT "city" FROM teachers 
) cities
GROUP BY "city" ORDER BY people_count DESC;

-- 5 AS 

SELECT
"full_name",
"birth_date" AS "tug'ilgan_sana"
FROM students
ORDER BY "full_name" DESC;

SELECT
"full_name",
    EXTRACT(YEAR FROM AGE(birth_date)) AS "tug'ilgan_yil"
FROM teachers;



-- 6 UNIUON

-- xar bir studentda 6 ta fan bor edi endi 3 tadan fan bor: 


DROP TABLE IF EXISTS grades;

CREATE TABLE grades (
    "id" SERIAL PRIMARY KEY,
    "student_id" INT REFERENCES students(id) ON DELETE CASCADE,
    "lesson_id" INT REFERENCES lessons(id) ON DELETE CASCADE,
    "grade" INT CHECK ("grade" BETWEEN 0 AND 100)
);


INSERT INTO grades ("student_id", "lesson_id", "grade")
SELECT
    student_id,
    lesson_id,
    (random() * 40 + 60)::int AS grade
FROM (
    SELECT
        s.id AS student_id,
        l.id AS lesson_id,
        ROW_NUMBER() OVER (
            PARTITION BY s.id
            ORDER BY random()
        ) AS rn
    FROM students s
    CROSS JOIN lessons l
) t
WHERE rn <= 3;


-- UNION 

SELECT DISTINCT s.id, s.full_name, l.name AS lesson_name
FROM students s
JOIN grades g ON g.student_id = s.id
JOIN lessons l ON l.id = g.lesson_id
WHERE l.name = 'Math'

UNION

SELECT DISTINCT s.id, s.full_name, l.name AS lesson_name
FROM students s
JOIN grades g ON g.student_id = s.id
JOIN lessons l ON l.id = g.lesson_id
WHERE l.name = 'Physics'
ORDER BY full_name, lesson_name;


-- 7 HAVING 

SELECT s.id, s.full_name,
AVG(g.grade) AS avg_grade
FROM students s
JOIN grades g ON g.student_id = s.id
GROUP BY s.id, s.full_name
HAVING AVG(g.grade) > 80
ORDER BY avg_grade DESC;

-------------------------------------------------------------------------------------------->>>>>>>>>>
-- 8 - yo'q akan ustoz -----------------------------------------------------<<<<<<<<<<<<<<<<<<<<<<<<<<
-------------------------------------------------------------------------------------------->>>>>>>>>>

-- 9 BEETWEN OR AND


SELECT s.id, s.full_name, s.city,
AVG(g.grade) AS avg_grade
FROM students s
JOIN grades g ON g.student_id = s.id
GROUP BY s.id, s.full_name, s.city
HAVING AVG(g.grade) BETWEEN 70 AND 90 or s.city = 'Tashkent'
ORDER BY s.city DESC;

-- 10 ILIKE 

SELECT "full_name"
FROM (
    SELECT "full_name" FROM students
    UNION ALL
    SELECT "full_name" FROM teachers 
) full_names
WHERE "full_name" ilike 'sh%' or "full_name" ilike '%sh';





-- 1 INDEX 

-- index lab qo'yibman tepada


-- 2 ORDER BY va LIMIT

SELECT student.full_name, AVG(grade.grade) AS avg_grade
FROM students student
JOIN grades grade ON student.id = grade.student_id
GROUP BY student.id, student.full_name
ORDER BY avg_grade DESC LIMIT 10;


-- 3 GROUB BY va HAVING
-- o'rta baxosi 85 dan katta yo'q ekan lekin 80 dan katta bor ekan bitta


SELECT lesson.id AS lesson_id,
       lesson.name As lesson_name,
       AVG(grade.grade) AS avg_grade
FROM lessons lesson
JOIN grades grade ON grade.lesson_id = lesson.id
GROUP BY lesson.id, lesson.name
HAVING AVG(grade.grade) > 80
ORDER BY avg_grade DESC;




-- 4 UNION va AS


SELECT
    c.city AS "shahar_turi",
    COUNT(DISTINCT s.id) AS studentlar_soni,
    COUNT(DISTINCT t.id) AS ustozlar_soni
FROM (
    SELECT city FROM students
    UNION
    SELECT city FROM teachers
) c
LEFT JOIN students s ON s.city = c.city
LEFT JOIN teachers t ON t.city = c.city
GROUP BY "shahar_turi"
ORDER BY c.city;


-- 5 BEETWEN OR AND


SELECT s.id, s.full_name, s.city, 
EXTRACT(YEAR FROM AGE(s.birth_date)) AS age
FROM students s
GROUP BY s.id, s.full_name, s.city
HAVING EXTRACT(YEAR FROM AGE(s.birth_date)) BETWEEN 18 AND 25
OR (s.city = 'Khorezm' OR s.city = 'Samarkand')
ORDER BY age ASC;



-- 6  LIKE ILKKE

 ------------------

SELECT "full_name" FROM students
WHERE "full_name" LIKE '%a'
UNION
SELECT "full_name" FROM teachers
WHERE "full_name" ILIKE 'i%'
GROUP BY "students", "teachers"
ORDER BY "full_name";

--------------------------

SELECT "full_name"
FROM students
WHERE "full_name" LIKE '%a'

UNION

SELECT "full_name"
FROM teachers
WHERE "full_name" ILIKE 'i%'

ORDER BY "full_name";


----------------------------


SELECT "full_name",
        'student' AS type
        FROM students
        WHERE "full_name" LIKE '%a'

UNION ALL

SELECT "full_name",
        'teacher' AS type
        FROM teachers
        WHERE "full_name" ILIKE 'i%'

ORDER BY type DESC, "full_name";


-- 7 LIMIT OFFSET


SELECT "id", "full_name" FROM teachers
WHERE "id" > 3 lIMIT 2; 

---------- 
SELECT id, full_name, city
FROM students
ORDER BY id
OFFSET 5 LIMIT 7;




-- DARS


-- CREATE INDEX simple_indexing on students("full_name");

-- composite 
-- CREATE INDEX comp_indexing on students("full_name", "city");

-- unique 
-- CREATE UNIQUE INDEX unique_indexing on students("full_name");

-- functionoal
-- CREATE INDEX functionoal_indexing on students(lower("full_name"));

-- partial
-- CREATE INDEX partial_indexing on students("full_name") WHERE "city" = 'Tashkent';


SELECT "full_name" FROM students WHERE "city" = 'Tashkent'
UNION
SELECT "full_name" FROM teachers WHERE "city" = 'Tashkent';

SELECT "full_name" FROM students WHERE "city" = 'Tashkent'
UNION
SELECT "full_name" FROM teachers WHERE "full_name" ilike '%ov';

SELECT "full_name" FROM students WHERE "city" = 'Tashkent'
UNION
SELECT "full_name" FROM teachers WHERE "full_name" ilike 'A%';



SELECT
    student_id,
    AVG(grade) AS avg_grade
FROM grades
GROUP BY student_id
HAVING AVG(grade) > 80;


SELECT
    city,
    COUNT(*) AS students_count
FROM students
GROUP BY city
HAVING COUNT(*) >= 2;


SELECT
    teacher_id,
    COUNT(*) AS lessons_count
FROM lessons
GROUP BY teacher_id
HAVING COUNT(*) > 0;


SELECT
    city,
    AVG(EXTRACT(YEAR FROM AGE(birth_date))) AS avg_age
FROM students
GROUP BY city
HAVING AVG(EXTRACT(YEAR FROM AGE(birth_date))) > 24;


SELECT full_name, birth_date
FROM students
WHERE EXTRACT(YEAR FROM birth_date) BETWEEN 1997 AND 1999;


SELECT full_name, city
FROM students
WHERE city = 'Tashkent' OR city = 'Samarkand';


SELECT full_name, city
FROM teachers
WHERE full_name ILIKE 'A%' OR city = 'Bukhara';





























































