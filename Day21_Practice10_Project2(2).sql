-- Dataset 1
 WITH d AS 
  (SELECT 
  FORMAT_DATE('%Y-%m-01', a.created_at) AS month,
  FORMAT_DATE('%Y', a.created_at) AS year,
  c.category AS product_category,
  SUM (b.sale_price)   AS TPV,
  COUNT (b.order_id)  AS TPO,
  SUM (c.cost) AS total_cost,
  SUM (b.sale_price)- SUM (c.cost) AS total_profit,
  ROUND((SUM (b.sale_price)- SUM (c.cost))/SUM (c.cost),3) AS profit_to_cost_ratio
  FROM bigquery-public-data.thelook_ecommerce.orders AS a 
  JOIN bigquery-public-data.thelook_ecommerce.order_items AS b ON a.order_id=b.order_id
  JOIN bigquery-public-data.thelook_ecommerce.products AS c ON b.id=c.id
  GROUP BY c.category, month, year
  ORDER BY c.category, month)

SELECT month, year, product_category, TPV, TPO,
ROUND((d.TPV- LAG (d.TPV) OVER (PARTITION BY product_category ORDER BY d.month)) / 
LAG (d.TPV) OVER (PARTITION BY product_category ORDER BY d.month) * 100.0,2) || '%' AS revenue_growth,
ROUND((d.TPO - LAG (d.TPO) OVER (PARTITION BY product_category ORDER BY d.month)) /
LAG (d.TPO) OVER (PARTITION BY product_category ORDER BY d.month)*100.0,2) || '%' AS order_growth,
total_cost, total_profit, profit_to_cost_ratio
FROM d
ORDER BY product_category, month

-- Tạo retention cohort analysis
 WITH x AS 
  (SELECT user_id, 
  sale_price AS amount,
  FORMAT_DATE('%Y-%m-01', created_at) AS month,
  MIN (FORMAT_DATE('%Y-%m-01', created_at)) OVER (PARTITION BY user_id) AS cohort_date,
  FROM bigquery-public-data.thelook_ecommerce.order_items),
y AS 
  (SELECT *,
  (CAST(FORMAT_DATE('%Y',CAST(month AS DATETIME)) AS INT) - CAST(FORMAT_DATE('%Y',CAST(cohort_date AS DATETIME)) AS INT)) *12 + 
  CAST(FORMAT_DATE('%m',CAST(month AS DATETIME)) AS INT) - CAST(FORMAT_DATE('%m',CAST(cohort_date AS DATETIME)) AS INT) +1 AS index
  FROM x)
SELECT cohort_date,
index,
COUNT (DISTINCT user_id) AS user_count,
SUM(amount) AS revenue
FROM y 
GROUP BY cohort_date, index
ORDER BY cohort_date, index
--- save view as vw_ecommerce_analyst

  WITH user_cohort AS 
  (SELECT 
  cohort_date,
  SUM(CASE WHEN index=1 THEN user_count ELSE 0 END) AS m1,
  SUM(CASE WHEN index=2 THEN user_count ELSE 0 END) AS m2,
  SUM(CASE WHEN index=3 THEN user_count ELSE 0 END) AS m3,
  SUM(CASE WHEN index=4 THEN user_count ELSE 0 END) AS m4,
  FROM single-kingdom-419712.project.vw_ecommerce_analyst
  GROUP BY cohort_date
  ORDER BY cohort_date),
retention_cohort AS
  (SELECT 
  cohort_date,
  ROUND(m1/m1*100.0,2) || '%' AS m1,
  ROUND(m2/m1*100.0,2) || '%' AS m2,
  ROUND(m3/m1*100.0,2) || '%' AS m3,
  ROUND(m4/m1*100.0,2) || '%' AS m4
  FROM user_cohort)

SELECT
  cohort_date,
  (100-ROUND(m1/m1*100.0,2)) || '%' AS m1,
  (100-ROUND(m2/m1*100.0,2)) || '%' AS m2,
  (100-ROUND(m3/m1*100.0,2)) || '%' AS m3,
  (100-ROUND(m4/m1*100.0,2)) || '%' AS m4
from user_cohort 




