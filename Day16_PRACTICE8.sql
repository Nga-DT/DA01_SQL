-- Ex 1
  WITH a AS   
    (SELECT *,
    RANK () OVER (PARTITION BY customer_id ORDER BY order_date  ) AS stt
    FROM Delivery)
SELECT 
    ROUND((SELECT COUNT(*) FROM a WHERE stt=1 AND order_date=customer_pref_delivery_date) *100.0/ 
COUNT(*),2) AS immediate_percentage  FROM a WHERE stt=1


-- Ex 2
 WITH a AS   
    (SELECT *,
    LEAD (event_date) OVER(PARTITION BY player_id) AS next_day,
    RANK() OVER(PARTITION BY player_id ORDER BY event_date ) AS stt
    FROM Activity)
SELECT
    ROUND((SELECT 
    COUNT (*) FROM a
    WHERE stt=1
    AND event_date=next_day- INTERVAL '1 day') *1.0 /
COUNT (DISTINCT player_id),2) AS fraction  FROM a

-- Ex 3
SELECT
CASE
    WHEN id=(SELECT MAX(id) FROM Seat) AND id%2=1 THEN id
    WHEN id%2=1 THEN id+1
    ELSE id-1
END AS id,
student
FROM Seat
ORDER BY id

-- Ex 4

 WITH a AS
     (SELECT DISTINCT visited_on,
    SUM (amount) OVER (PARTITION BY visited_on) AS sum,
    RANK () OVER (ORDER BY visited_on) AS stt
    FROM Customer 
    ORDER BY visited_on),
b AS
    (SELECT
    visited_on, stt,
    SUM(sum) OVER (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
    ROUND(AVG(sum) OVER (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount  
    FROM a)
SELECT visited_on, amount, average_amount
FROM b
WHERE stt>=7

-- Ex 5
 WITH a AS
     (SELECT DISTINCT visited_on,
    SUM (amount) OVER (PARTITION BY visited_on) AS sum,
    RANK () OVER (ORDER BY visited_on) AS stt
    FROM Customer 
    ORDER BY visited_on),
b AS
    (SELECT
    visited_on, stt,
    SUM(sum) OVER (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
    ROUND(AVG(sum) OVER (ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount  
    FROM a)
SELECT visited_on, amount, average_amount
FROM b
WHERE stt>=7

-- Ex 6
WITH a AS
    (SELECT b.name AS Department , a.name AS Employee, a.salary AS Salary,
    DENSE_RANK () OVER (PARTITION BY b.name ORDER BY a.salary DESC ) AS stt
    FROM Employee AS a
    JOIN Department AS b ON a.departmentId =b.id)
SELECT Department, Employee, Salary
FROM a 
WHERE stt<=3
    
-- Ex 7
WITH a AS  
    (SELECT *,
    SUM (weight) OVER(ORDER BY turn ) AS sum_weight 
    FROM Queue)
SELECT person_name 
FROM a
WHERE sum_weight<=1000
ORDER BY sum_weight DESC
LIMIT 1

-- Ex 8
 WITH a AS   
    (SELECT *, 
    RANK () OVER(PARTITION BY product_id ORDER BY change_date DESC  ) AS stt
    FROM Products
    WHERE change_date <= '2019-08-16')
SELECT product_id , new_price AS price
FROM a 
WHERE stt=1
UNION
SELECT product_id, 10 AS price 
FROM Products WHERE product_id NOT IN (SELECT product_id FROM a)










