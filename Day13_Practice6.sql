-- Ex 1
WITH count_job AS 
  (SELECT company_id, title, description, 
  COUNT (job_id) AS job_count
  FROM job_listings 
  GROUP BY company_id, title, description)
  
SELECT 
 COUNT(DISTINCT company_id) AS duplicate_companies
FROM count_job
 WHERE job_count >=2

 
-- Ex 2
WITH appliance_total AS
 (SELECT category, product,
SUM(spend) AS total_spend
FROM product_spend
WHERE category='appliance'
AND EXTRACT(YEAR FROM transaction_date ) = '2022'
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2),

electronics_total AS
 (SELECT category, product,
SUM(spend) AS total_spend
FROM product_spend
WHERE category='electronics'
AND EXTRACT(YEAR FROM transaction_date ) = '2022'
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2)

SELECT category, product, total_spend 
FROM appliance_total
UNION ALL
SELECT category, product, total_spend 
FROM electronics_total

-- Ex 3
WITH call_count AS
  (SELECT policy_holder_id,
  COUNT (case_id) AS count_call
  FROM callers
  GROUP BY policy_holder_id)

SELECT COUNT(DISTINCT policy_holder_id) AS member_count
FROM call_count
WHERE  count_call>3

-- Ex 4
SELECT page_id
FROM pages
WHERE page_id NOT IN 
  (SELECT page_id
  FROM page_likes
  WHERE page_id IS NOT NULL)

-- Ex 5
SELECT 
  EXTRACT(MONTH FROM curr_month.event_date) AS month, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date)

-- Ex 6
SELECT LEFT (CAST (trans_date AS varchar) ,7)
    AS month,
       country,
       COUNT(id) AS trans_count,
       SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
       SUM(amount) AS trans_total_amount,
       SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country

-- Ex 7
WITH b AS
    (SELECT product_id,
    MIN(year) AS first_year 
    FROM Sales
    GROUP BY product_id )  
SELECT a.product_id, b.first_year, 
a.quantity,
a.price 
FROM 
Sales AS a
JOIN b ON a.product_id=b.product_id AND a.year=b.first_year

-- Ex 8
SELECT customer_id
FROM Customer 
GROUP BY customer_id
HAVING COUNT (DISTINCT product_key) =
(SELECT
    COUNT (product_key) 
    FROM Product )

-- Ex 9
SELECT a.employee_id 
FROM Employees AS a
LEFT JOIN Employees AS b ON a.manager_id = b.employee_id
WHERE a.salary < 30000 AND b.employee_id IS NULL
ORDER BY a.employee_id

-- Ex 10
WITH count_job AS 
  (SELECT company_id, title, description, 
  COUNT (job_id) AS job_count
  FROM job_listings 
  GROUP BY company_id, title, description)
  
SELECT 
 COUNT(DISTINCT company_id) AS duplicate_companies
FROM count_job
 WHERE job_count >=2


-- Ex 11
WITH a AS
(SELECT user_id,
    COUNT (rating)
    FROM MovieRating
    GROUP BY user_id
    ORDER BY COUNT (rating) DESC, user_id
    LIMIT 1),
b AS
    (SELECT movie_id,
    AVG (rating)
    FROM MovieRating 
    WHERE EXTRACT (MONTH FROM created_at)= 02
    AND EXTRACT (YEAR FROM created_at)=2020
    GROUP BY movie_id
    ORDER BY AVG (rating) DESC, movie_id
    LIMIT 1)
SELECT  c.name AS results
FROM a
JOIN Users AS c ON a.user_id=c.user_id
UNION
SELECT d.title AS results
FROM b
JOIN Movies AS d ON b.movie_id=d.movie_id

-- Ex 12
WITH a AS
    (SELECT requester_id as id
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id as id
    FROM RequestAccepted)
SELECT id, COUNT (*) AS NUM
FROM a
GROUP BY id
ORDER BY num DESC
LIMIT 1








































































