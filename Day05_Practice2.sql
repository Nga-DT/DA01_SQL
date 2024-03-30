-- Ex 1
select distinct CITY from STATION
where ID % 2 = 0

-- Ex 2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION

-- Ex 4
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS DECIMAL),1) AS mean
FROM items_per_order

-- Ex 5
SELECT 
candidate_id 
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY(candidate_id)
HAVING COUNT(skill)=3

-- Ex 6
SELECT user_id,
DATE(MAX(post_date)) - DATE(MIN(post_date)) AS days_between
FROM posts
WHERE post_date >= '2021-01-01' AND post_date <'2022-01-01'
GROUP BY user_id
HAVING COUNT(post_id) >= 2

-- Ex 7
SELECT 
card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY(card_name)
ORDER BY difference DESC

-- Ex 8
SELECT 
manufacturer,
COUNT(drug) AS drug_count,
ABS(SUM(cogs-total_sales)) AS total_loss
FROM pharmacy_sales
WHERE cogs>total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC

-- Ex 9
SELECT *
FROM Cinema
WHERE id%2=1
AND description <> 'boring'
ORDER BY rating DESC

-- Ex 10
SELECT teacher_id, COUNT(DISTINCT subject_id ) AS cnt
FROM Teacher
GROUP BY teacher_id

-- Ex 11
SELECT
user_id, 
COUNT (follower_id ) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id

-- Ex 12
SELECT 
class
FROM Courses
GROUP BY class
HAVING COUNT(student)>=5
    
