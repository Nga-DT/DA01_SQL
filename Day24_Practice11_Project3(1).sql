-- Doanh thu theo từng ProductLine, Year  và DealSize
SELECT 
productline, year_id, dealsize,
SUM (quantityordered*priceeach) AS revenue
FROM public.sales_dataset_rfm_prj_clean
GROUP BY productline, year_id, dealsize
ORDER BY productline, year_id, dealsize

-- Đâu là tháng có bán tốt nhất mỗi năm?
-- tháng 11 (năm 2003,2004); tháng 5 (năm 2005)
WITH a AS
  (SELECT 
  month_id, year_id,
  SUM (priceeach*quantityordered) AS revenue,
  COUNT(ordernumber) AS order_number
  FROM public.sales_dataset_rfm_prj_clean
  GROUP BY month_id,year_id
  ORDER BY year_id,month_id),
b AS
  (SELECT *,
  RANK () OVER(PARTITION BY year_id ORDER BY revenue DESC  ) AS stt
  FROM a)
SELECT month_id,year_id, revenue, order_number
FROM b 
WHERE stt=1

-- Product line nào được bán nhiều ở tháng 11?
-- Classic Cars (219 sản phẩm)
WITH a AS
  (SELECT month_id, productline,
  SUM (priceeach*quantityordered) AS revenue,
  COUNT(ordernumber) AS order_number
  FROM public.sales_dataset_rfm_prj_clean
  WHERE month_id=11 
  GROUP BY productline, month_id
  ORDER BY COUNT(ordernumber) DESC)
SELECT productline FROM a
LIMIT 1

-- Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm?
-- Năm 2003,2004: Classic Cars; Năm 2005: Motorcycles
WITH a AS
	(SELECT year_id, productline, 
	SUM (quantityordered*priceeach) AS revenue
	FROM public.sales_dataset_rfm_prj_clean
	WHERE country = 'UK' 
	GROUP BY year_id, productline
	ORDER BY year_id),
b AS
	(SELECT *,
	RANK () OVER(PARTITION BY year_id ORDER BY revenue DESC) AS stt
	FROM a)
SELECT year_id, productline, revenue,
RANK () OVER (ORDER BY revenue DESC) AS rank
FROM b
WHERE stt=1

-- Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
/* "Anna's Decorations, Ltd", "Reims Collectables", "Dragon Souveniers, Ltd.", "Corporate Gift Ideas Co.", "Gift Depot Inc.", "La Rochelle Gifts", "Diecast Classics Inc.",
"Handji Gifts& Co", "Tokyo Collectables, Ltd", "Euro Shopping Channel", "Mini Gifts Distributors Ltd.", "Souveniers And Things Co.", "Salzburg Collectables",
"The Sharp Gifts Warehouse", "Danish Wholesale Imports" */
CREATE TABLE segment_score
(segment Varchar,
  scores Varchar);

WITH customer_rfm AS
	(select 
	customername,
	current_date - MAX (orderdate) AS R,
	COUNT (DISTINCT ordernumber) AS F,
	SUM (sales) AS M
	from public.sales_dataset_rfm_prj_clean
	GROUP BY customername),
rfm_score AS
	(SELECT customername,
	ntile(5) OVER (ORDER BY R DESC) AS R_score,
	ntile(5) OVER (ORDER BY F) AS F_score,
	ntile(5) OVER (ORDER BY M DESC) AS M_score
	FROM customer_rfm),
rfm AS
	(SELECT customername,
	CAST(R_score AS varchar)||CAST(F_score AS varchar)||CAST(M_score AS varchar) AS RFM_score
	FROM rfm_score)
SELECT a.customername, b.segment FROM rfm AS a
JOIN public.segment_score AS b ON a.RFM_score=b.scores
WHERE b.segment = 'Champions'
	
	




