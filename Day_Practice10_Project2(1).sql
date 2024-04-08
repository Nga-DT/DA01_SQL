/* Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng (Từ 1/2019-4/2022) */
SELECT
FORMAT_DATE('%Y-%m', created_at) AS month_year,
COUNT (DISTINCT user_id) AS total_user,
COUNT (order_id) AS total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY FORMAT_DATE('%Y-%m', created_at)
ORDER BY month_year
-- Nhận xét: tổng số lượng người mua và đơn hàng tăng dần theo thời gian


  
/* Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng (Từ 1/2019-4/2022) */
SELECT
FORMAT_DATE('%Y-%m', a.created_at) AS month_year,
COUNT (DISTINCT a.user_id) AS distinct_users,
SUM (b.sale_price)/COUNT(a.order_id) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.orders AS a   
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b ON a.order_id=b.order_id 
WHERE FORMAT_DATE('%Y-%m', a.created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY FORMAT_DATE('%Y-%m', a.created_at)
ORDER BY month_year
-- Nhận xét: giá trị đơn hàng biến động từ khoảng 58 đến 62


/* Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính (Từ 1/2019-4/2022) */
WITH a AS
  (SELECT
  first_name, last_name, gender, age, 'youngest' AS tag
  FROM bigquery-public-data.thelook_ecommerce.users 
  WHERE age= (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users)
  AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04'
  UNION ALL 
  SELECT
  first_name, last_name, gender, age, 'oldest' AS tag
  FROM bigquery-public-data.thelook_ecommerce.users
  WHERE age= (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users)
  AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04')

  SELECT 
  age,
  SUM(CASE WHEN tag='youngest' THEN 1 ELSE 0 END) AS youngest_count,
  SUM(CASE WHEN tag='oldest' THEN 1 ELSE 0 END) AS oldest_count 
  FROM a
  GROUP BY age
-- Nhận xét: Trẻ nhất (độ tuổi:12; số lượng: 1055); Già nhất (độ tuổi:70; số lượng: 1002)

/* Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm) */
WITH c AS
  (SELECT 
  FORMAT_DATE('%Y-%m', a.created_at) AS month_year,
  a.product_id,
  b.name,
  SUM (a.sale_price) OVER (PARTITION BY a.product_id, FORMAT_DATE('%Y-%m', a.created_at)) AS sales,
  SUM (b.cost) OVER (PARTITION BY a.product_id, FORMAT_DATE('%Y-%m', a.created_at)) AS cost,
  SUM (a.sale_price) OVER (PARTITION BY a.product_id, FORMAT_DATE('%Y-%m', a.created_at)) - 
  SUM (b.cost) OVER (PARTITION BY a.product_id, FORMAT_DATE('%Y-%m', a.created_at)) AS profit  
  FROM bigquery-public-data.thelook_ecommerce.order_items AS a
  JOIN bigquery-public-data.thelook_ecommerce.products AS b ON a.id=b.id),
d AS
  (SELECT *,
  DENSE_RANK() OVER (PARTITION BY  c.month_year 
    ORDER BY c.profit) AS stt
  FROM c
  ORDER BY c.month_year) 
SELECT month_year, product_id, name, sales, cost, profit FROM d
WHERE stt<=5

/* Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)*/
SELECT 
FORMAT_DATE('%F', created_at) AS dates,
b.category AS product_categories,
SUM (a.sale_price) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b ON a.id=b.id
WHERE FORMAT_DATE('%F', created_at) BETWEEN '2022-01-15' AND '2022-04-15'
GROUP BY dates, product_categories
ORDER BY dates































