/* 1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER)  */
SELECT * FROM sales_dataset_rfm_prj;
ALTER TABLE sales_dataset_rfm_prj 
	ALTER COLUMN ordernumber TYPE integer;
ALTER TABLE sales_dataset_rfm_prj 
	ALTER COLUMN quantityordered TYPE integer;
ALTER TABLE sales_dataset_rfm_prj 
	ALTER COLUMN priceeach TYPE numeric;
ALTER TABLE sales_dataset_rfm_prj
	ALTER COLUMN orderdate TYPE timestamp;
ALTER TABLE sales_dataset_rfm_prj
	ALTER COLUMN orderlinenumber TYPE integer;
ALTER TABLE sales_dataset_rfm_prj
	ALTER COLUMN sales TYPE numeric;
ALTER TABLE sales_dataset_rfm_prj
	ALTER COLUMN msrp TYPE integer

/* Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE. */
SELECT * FROM sales_dataset_rfm_prj 
WHERE ordernumber IS NULL
OR quantityordered IS NULL
OR priceeach IS NULL 
OR orderlinenumber IS NULL
OR sales IS NULL
OR orderdate IS NULL

/* Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
Gợi ý: ( ADD column sau đó UPDATE) */
SELECT * FROM sales_dataset_rfm_prj
ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN CONTACT_FIRSTNAME VARCHAR;
ALTER TABLE sales_dataset_rfm_prj
	ADD COLUMN CONTACT_LASTNAME VARCHAR

	
UPDATE sales_dataset_rfm_prj 
SET contact_firstname = UPPER(LEFT(contactfullname,1)) || 
RIGHT(LEFT(contactfullname,POSITION ('-' IN contactfullname)-1),
	  LENGTH (LEFT(contactfullname,POSITION ('-' IN contactfullname)-1))-1);
	  
UPDATE sales_dataset_rfm_prj 
SET contact_lastname= 
UPPER(LEFT(RIGHT(contactfullname,LENGTH(contactfullname)
				 -POSITION ('-' IN contactfullname)),1)) ||
RIGHT(RIGHT(contactfullname,LENGTH(contactfullname)
				 -POSITION ('-' IN contactfullname)),
	  LENGTH (RIGHT(contactfullname,LENGTH(contactfullname)
				 -POSITION ('-' IN contactfullname))) -1)


/* Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE */
SELECT * FROM sales_dataset_rfm_prj
ALTER TABLE sales_dataset_rfm_prj
	ADD column QTR_ID NUMERIC;
ALTER TABLE sales_dataset_rfm_prj
	ADD column MONTH_ID NUMERIC;
ALTER TABLE sales_dataset_rfm_prj
	ADD column YEAR_ID NUMERIC;

UPDATE sales_dataset_rfm_prj
SET qtr_id=EXTRACT(QUARTER FROM orderdate);
UPDATE sales_dataset_rfm_prj
SET month_id=EXTRACT(MONTH FROM orderdate);
UPDATE sales_dataset_rfm_prj
SET year_id=EXTRACT(YEAR FROM orderdate)

/* Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review) */
-- C1
WITH min_max AS
(SELECT Q1-1.5*IQR AS min_value, Q3+1.5*IQR AS max_value FROM
	(SELECT
	PERCENTILE_CONT (0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
	PERCENTILE_CONT (0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3,
	PERCENTILE_CONT (0.75) WITHIN GROUP (ORDER BY quantityordered) -
	PERCENTILE_CONT (0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
 	FROM sales_dataset_rfm_prj) AS a)

SELECT quantityordered FROM sales_dataset_rfm_prj
WHERE quantityordered < (SELECT min_value FROM min_max)
OR quantityordered>(SELECT max_value FROM min_max)

-- C2
WITH a AS
	(SELECT quantityordered,
	(SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj) AS average,
	(SELECT STDDEV(quantityordered) FROM sales_dataset_rfm_prj) AS stddev
	FROM sales_dataset_rfm_prj)
SELECT quantityordered, (quantityordered-average)	/ stddev AS z_score
FROM a 
WHERE ABS((quantityordered-average)	/ stddev) >3

/* Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN */
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT * FROM sales_dataset_rfm_prj

















 
