
#01.	Find Book Titles-------------------------------------

SELECT `title` FROM `books`
WHERE SUBSTRING(`title`,1,3) = 'The'
ORDER BY `id`;

#02. Replace Titles-----------------------------------------

SELECT REPLACE(`title`, 'The', '***') AS 'Title'
FROM `books`
WHERE SUBSTRING(title, 1, 3) = 'The';

#3.	Sum Cost of All Books----------------------------------

SELECT round(sum(`cost`),2) FROM `books`;

#04.Days Lived---------------------------------------------

SELECT concat_ws(' ', `first_name`, `last_name`) AS `FULL NAME`, timestampdiff(day,`born`, `died`) AS `Days_Lived`
FROM `authors`;

#05.	Harry Potter Books--------------------------------------

SELECT `title` FROM `books`
WHERE `title` LIKE 'Harry%';