-- Ex 1
select 
a.CONTINENT,
floor(avg(b.POPULATION)) as average_city_population
from COUNTRY as a
join CITY  as b
on a.CODE=b.COUNTRYCODE
group by a.CONTINENT

-- Ex 2
SELECT 
ROUND(CAST(COUNT(b.email_id) AS DECIMAL)/COUNT(DISTINCT a.email_id),2) AS activation_rate
FROM emails AS a
LEFT JOIN texts AS b
  ON a.email_id = b.email_id
  AND b.signup_action = 'Confirmed'

-- Ex 3
SELECT 
b.age_bucket,
ROUND(SUM(a.time_spent) FILTER(WHERE a.activity_type='send')/
SUM(a.time_spent) *100.00,2) AS send_perc,
ROUND(SUM(a.time_spent) FILTER(WHERE a.activity_type='open')/
SUM(a.time_spent)*100.00,2) AS open_perc
FROM activities AS a
INNER JOIN age_breakdown AS b 
ON a.user_id=b.user_id
WHERE a.activity_type IN ('open', 'send')
GROUP BY b.age_bucket

-- Ex 4
SELECT 
a.customer_id 
FROM customer_contracts AS a   
LEFT JOIN products AS b   
ON a.product_id=b.product_id
WHERE b.product_name LIKE 'Azure%'
GROUP BY a.customer_id
HAVING COUNT (DISTINCT b.product_category) =3

-- Ex 5
SELECT
mng.employee_id, mng.name, 
COUNT (emp.employee_id) AS reports_count,
ROUND(AVG(emp.age)) AS average_age
FROM Employees AS emp
JOIN Employees AS mng
ON emp.reports_to= mng.employee_id 
GROUP BY mng.employee_id, mng.name
ORDER BY employee_id

-- Ex 6
SELECT
a.product_name,
SUM(b.unit) AS unit
FROM Products AS a
LEFT JOIN Orders AS b
ON a.product_id  = b.product_id
WHERE EXTRACT (MONTH FROM b.order_date) = '02'
AND EXTRACT (YEAR FROM b.order_date) = '2020'
GROUP BY a.product_name
HAVING SUM(b.unit) >=100

-- Ex 7
SELECT 
a.page_id
FROM pages AS a  
LEFT OUTER JOIN page_likes AS b  
ON a.page_id=b.page_id
WHERE b.page_id IS NULL
ORDER BY page_id


















