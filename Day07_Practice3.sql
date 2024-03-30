-- Ex 1
select 
Name
from STUDENTS
where Marks > 75
order by right(Name,3), ID

-- Ex 2
SELECT user_id, 
CONCAT(UPPER(LEFT(name,1)), LOWER(SUBSTRING(name,2))) AS name
FROM Users
ORDER BY user_id

-- Ex 3
SELECT 
manufacturer,
'$' || ROUND(SUM(total_sales)/1000000,0) || ' ' || 'million' AS total_sales
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer

-- Ex 4
SELECT 
EXTRACT(month FROM submit_date) as month,
product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product_id
ORDER BY EXTRACT(month FROM submit_date), product_id

-- Ex 5
SELECT 
sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(month FROM sent_date) = '8' 
AND EXTRACT(year FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

-- Ex 6
select 
tweet_id
from Tweets
where length(content)>15

-- Ex 7
select
activity_date as day,
count(distinct user_id) as active_users
from Activity
where (activity_date > "2019-06-27" AND activity_date <= "2019-07-27")
group by activity_date

-- Ex 8
select 
count (id) as employee_count
from employees;
where extract (month from joining_date) between 1 and 7
and extract (year from joining_date)='2022'

-- Ex 9
select 
position('a'in first_name ) as position
from worker
where first_name='Amitah'

-- Ex 10
select 
substring(title, length(winery)+2,4) 
from winemag_p2
where country='Macedonia'








































