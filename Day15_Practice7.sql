-- Ex 1
SELECT 
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG (spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date))
AS prev_year_spend,
ROUND((spend - LAG (spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date)))
/LAG (spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date)) *100.0,2) AS yoy_rate
FROM user_transactions

-- Ex 2
WITH a AS
  (SELECT 
  card_name,
  issued_amount,
  RANK () OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS stt
  FROM monthly_cards_issued)

SELECT card_name, issued_amount
FROM a
WHERE stt=1
ORDER BY issued_amount DESC

-- Ex 3
WITH a AS  
  (SELECT 
  user_id, spend, transaction_date,
  RANK() OVER(PARTITION BY user_id ORDER BY transaction_date ) AS stt 
  FROM transactions)
  
SELECT user_id, spend, transaction_date FROM a  
WHERE stt=3

-- Ex 4
WITH a AS  
  (SELECT 
  transaction_date, user_id, product_id, 
  RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC ) AS stt
  FROM user_transactions)

SELECT transaction_date, user_id,
COUNT (product_id) AS purchase_count
FROM a  
WHERE stt=1
GROUP BY user_id, transaction_date
ORDER BY transaction_date 

-- Ex 5
SELECT 
user_id, tweet_date,
ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets

-- Ex 6
WITH a AS  
  (SELECT 
  merchant_id, credit_card_id, amount, transaction_timestamp,
  LAG (transaction_timestamp) 
  OVER(PARTITION BY merchant_id, credit_card_id, amount
  ORDER BY transaction_timestamp ) AS previous_transaction_timestamp,
  EXTRACT(EPOCH FROM (transaction_timestamp - LAG (transaction_timestamp) 
  OVER(PARTITION BY merchant_id, credit_card_id, amount
  ORDER BY transaction_timestamp )))/60 AS diff
  FROM transactions)
  
SELECT COUNT(a.diff)
FROM a  
WHERE a.diff<=10

-- Ex 7
WITH a AS
  (SELECT
  category, product, 
  SUM(spend) AS total_spend ,
  RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC ) AS stt
  FROM product_spend 
  WHERE EXTRACT(YEAR FROM transaction_date ) =2022
  GROUP BY category, product)
  
SELECT category, product, total_spend
FROM a  
WHERE stt <=2

-- Ex 8
WITH d AS
  (SELECT a.artist_name, COUNT(c.song_id),
  DENSE_RANK () OVER(ORDER BY COUNT(c.song_id) DESC) AS artist_rank
  FROM artists AS a
  INNER JOIN songs AS b ON a.artist_id=b.artist_id
  INNER JOIN global_song_rank AS c ON b.song_id=c.song_id
  WHERE c.rank <=10
  GROUP BY a.artist_name)
  
SELECT d.artist_name, d.artist_rank
FROM d
WHERE d.artist_rank <=5






















