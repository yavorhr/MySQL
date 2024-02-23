CREATE SCHEMA universities_db;
USE universities_db;

-- Create countries table
CREATE TABLE countries (
                           id INT AUTO_INCREMENT,
                           name VARCHAR(40) NOT NULL UNIQUE,
                           PRIMARY KEY (id)
);
-- Create cities table
CREATE TABLE cities (
                        id INT AUTO_INCREMENT,
                        name VARCHAR(40) NOT NULL UNIQUE,
                        population INT,
                        country_id INT NOT NULL,
                        PRIMARY KEY (id),
                        FOREIGN KEY (country_id) REFERENCES countries(id)
);
-- Create universities table
CREATE TABLE universities (
                         id INT AUTO_INCREMENT,
                         name VARCHAR(60) NOT NULL UNIQUE,
                         address VARCHAR(80) NOT NULL UNIQUE,
                         tuition_fee DECIMAL(19,2) NOT NULL,
                         number_of_staff INT,
                         city_id INT,
                         PRIMARY KEY (id),
                         FOREIGN KEY (city_id) REFERENCES cities(id)
);
-- Create students table
CREATE TABLE students (
                          id INT AUTO_INCREMENT,
                          first_name VARCHAR(40) NOT NULL ,
                          last_name VARCHAR(40) NOT NULL ,
                          age INT,
                          phone VARCHAR(20) NOT NULL UNIQUE,
                          email VARCHAR(255) NOT NULL UNIQUE,
                          is_graduated BOOLEAN NOT NULL,
                          city_id INT,
                          PRIMARY KEY (id),
                          FOREIGN KEY (city_id) REFERENCES cities(id)
);
-- Create courses table
CREATE TABLE courses (
                         id INT AUTO_INCREMENT,
                         name VARCHAR(40) NOT NULL UNIQUE,
                         duration_hours DECIMAL(19,2),
                         start_date DATE,
                         teacher_name VARCHAR(60) NOT NULL UNIQUE,
                         description TEXT,
                         university_id INT,
                         PRIMARY KEY (id),
                         FOREIGN KEY (university_id) REFERENCES universities(id)
);
-- Create student_courses table
CREATE TABLE students_courses (
                                 grade DECIMAL(19,2) NOT NULL,
                                 student_id INT NOT NULL,
                                 course_id INT NOT NULL,
                                 KEY `pk_students_courses`(`student_id`,`course_id`),
                                 CONSTRAINT `fk_students_courses_students` FOREIGN KEY (`student_id`) REFERENCES students(`id`),
                                 CONSTRAINT `fk_students_courses_courses` FOREIGN KEY (`course_id`) REFERENCES courses(`id`)
);

# # 2 Insert
# INSERT INTO courses(name, duration_hours, start_date, teacher_name, description, university_id)
# SELECT (CONCAT(c.teacher_name, ' course')) cn,CHAR_LENGTH(name)/10, DATE(c.start_date+5), REVERSE(c.teacher_name), CONCAT('Course ', c.teacher_name, REVERSE(c.description)), DAY(start_date)  FROM courses c
# WHERE c.id <= 5;

# # 3 Update
# UPDATE universities u
# SET u.tuition_fee = u.tuition_fee + 300
# WHERE u.id BETWEEN 5 AND 12;

# # 4 Delete
# DELETE u FROM universities u
# WHERE u.number_of_staff IS NULL;

# --- Section 3 ---
# # 5
# SELECT * FROM cities c
# ORDER BY c.population desc;

# # 6
# SELECT first_name, last_name, age, phone, email, is_graduated  FROM students s
# WHERE s.age >= 21
# ORDER BY first_name desc, email asc, id asc
# LIMIT 10;

# # 7
# SELECT CONCAT(first_name,' ',last_name) full_name, SUBSTRING(email,2,10) username, REVERSE(s.phone) password   FROM students s
#                                                                                                                         LEFT JOIN students_courses sc on s.id = sc.student_id
#                                                                                                                         LEFT JOIN courses c on c.id = sc.course_id
# WHERE sc.student_id IS NULL
# ORDER BY password desc;

# # 8
# SELECT COUNT(c.id) students_count, u.name university_name
# FROM universities u
#          join courses c on u.id = c.university_id
#          join students_courses sc on c.id = sc.course_id
# GROUP BY u.name
# HAVING students_count >= 8
# ORDER BY students_count desc, u.name desc;

# # 9
# SELECT  u.name, c.name, address,
#         (CASE
#              WHEN u.tuition_fee < 800 THEN 'cheap'
#              WHEN u.tuition_fee >= 800 AND u.tuition_fee < 1200 THEN 'normal'
#              WHEN u.tuition_fee >= 1200 AND u.tuition_fee < 2500 THEN 'high'
#              else 'expensive'
#             END) as price,
#         u.tuition_fee
# FROM  universities u
#           JOIN cities c on c.id = u.city_id
# ORDER BY tuition_fee asc;


# # 10 udf
# DELIMITER $$
# CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name VARCHAR(60))
#     RETURNS DECIMAL(19, 2)
#     DETERMINISTIC
# BEGIN
#     DECLARE average_grade DECIMAL(19, 2);
#     SET average_grade := (
#         SELECT AVG(sc.grade)
#         FROM students s
#                  JOIN students_courses sc on s.id = sc.student_id
#                  JOIN courses c on c.id = sc.course_id
#         WHERE s.is_graduated = 1
#           AND c.name = course_name);
#     RETURN average_grade;
# end $$
# DELIMITER ;
#
# SELECT c.name, udf_average_alumni_grade_by_course_name('Quantum Physics') as average_alumni_grade FROM courses c
# WHERE c.name = 'Quantum Physics';
#
# SELECT c.name, udf_average_alumni_grade_by_course_name('Statistics') as average_alumni_grade FROM courses c
# WHERE c.name = 'Statistics';
#
# SELECT c.name, udf_average_alumni_grade_by_course_name('Web Development Advanced') as average_alumni_grade FROM courses c
# WHERE c.name = 'Web Development Advanced';

# # 11 udp
# CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
# BEGIN
#     UPDATE students s
#         JOIN students_courses sc on s.id = sc.student_id
#         JOIN courses c on c.id = sc.course_id
#     SET s.is_graduated=1
#     WHERE YEAR(c.start_date) = year_started;
# END;
#
#
# SELECT s.first_name, s.last_name, c.name course_name, s.is_graduated
# FROM students s
#          JOIN students_courses sc on s.id = sc.student_id
#          JOIN courses c on c.id = sc.course_id
# WHERE YEAR(c.start_date) = 2017;
#
# CALL udp_graduate_all_students_by_year(2017);
#
# SELECT s.first_name, s.last_name, c.name course_name, s.is_graduated
# FROM students s
#          JOIN students_courses sc on s.id = sc.student_id
#          JOIN courses c on c.id = sc.course_id
# WHERE YEAR(c.start_date) = 2018;
# CALL udp_graduate_all_students_by_year(2018);
#
# SELECT s.first_name, s.last_name, c.name course_name, s.is_graduated
# FROM students s
#          JOIN students_courses sc on s.id = sc.student_id
#          JOIN courses c on c.id = sc.course_id
# WHERE YEAR(c.start_date) = 2019;
# CALL udp_graduate_all_students_by_year(2019);

