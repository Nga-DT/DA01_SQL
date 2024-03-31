-- Q1
SELECT title, 
film_id, 
replacement_cost
FROM film
ORDER BY replacement_cost

-- Q2
SELECT
CASE 
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20 AND 24.99 THEN 'medium'
	WHEN replacement_cost BETWEEN 25 AND 29.99 THEN 'high'
END AS xep_loai,
COUNT (*) as film_count
FROM film
GROUP BY xep_loai

-- Q3
SELECT 
a.title, a.length, c.name
FROM public.film AS a
JOIN public.film_category AS b ON a.film_id=b.film_id
JOIN public.category AS c ON b.category_id=c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY  a.length DESC

-- Q4
SELECT 
c.name, COUNT (a.title)
FROM public.film AS a
JOIN public.film_category AS b ON a.film_id=b.film_id
JOIN public.category AS c ON b.category_id=c.category_id
GROUP BY c.name
ORDER BY COUNT (a.title) DESC

-- Q5
SELECT 
a.first_name || ' ' || a.last_name AS ho_ten,
COUNT (b.film_id) AS film_count
FROM public.actor AS a
JOIN public.film_actor AS b 
ON a.actor_id=b.actor_id
GROUP BY ho_ten
ORDER BY film_count DESC

-- Q6
SELECT COUNT(*) 
FROM public.address AS a
LEFT JOIN public.customer AS b
ON a.address_id= b.address_id
WHERE b.first_name IS NULL

-- Q7
SELECT
a.city, SUM(d.amount)
FROM public.city AS a
INNER JOIN public.address AS b
ON a.city_id=b.city_id
INNER JOIN public.customer AS c
ON b.address_id=c.address_id
INNER JOIN public.payment AS d
ON c.customer_id=d.customer_id
GROUP BY a.city
ORDER BY SUM(d.amount) DESC

-- Q8
SELECT
b.city || ',' || ' ' || a.country AS city_country, SUM(e.amount)
FROM public.country AS a
INNER JOIN public.city AS b
ON a.country_id=b.country_id
INNER JOIN public.address AS c
ON b.city_id=c.city_id
INNER JOIN public.customer AS d
ON c.address_id=d.address_id
INNER JOIN public.payment AS e
ON d.customer_id=e.customer_id
GROUP BY b.city, a.country
ORDER BY SUM(e.amount)



















