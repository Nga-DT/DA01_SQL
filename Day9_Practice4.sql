-- Ex 1
SELECT 
SUM(CASE
  WHEN device_type = 'laptop' THEN 1 ELSE 0
END) AS laptop_reviews,
SUM(CASE
  WHEN device_type IN ('tablet','phone') THEN 1 ELSE 0
END) AS mobile_views
FROM viewership;

-- Ex 2
SELECT
x,y,z,
CASE
    WHEN x+y>z AND y+z>x AND x+z>Y THEN 'Yes' ELSE 'No'
END AS triangle
FROM Triangle

-- Ex 4
SELECT name FROM Customer 
WHERE referee_id <> 2 
OR referee_id IS null

-- Ex 5
SELECT 
DISTINCT (survived),
SUM(CASE
    WHEN pclass = 1 THEN 1 ELSE 0
END) AS first_class,
SUM(CASE
    WHEN pclass = 2 THEN 1 ELSE 0
END) AS second_class,
SUM(CASE
    WHEN pclass = 3 THEN 1 ELSE 0
END) AS third_class
from titanic
GROUP BY DISTINCT (survived)
