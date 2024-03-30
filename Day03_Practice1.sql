-- Ex1
select NAME from CITY
where CountryCode='USA'
and POPULATION > 120000

-- Ex2
select * from CITY
where COUNTRYCODE = 'JPN'

-- Ex3
select CITY,STATE from STATION

-- Ex4
select distinct CITY from STATION
where CITY like 'a%' or CITY like 'e%' or CITY like 'o%' or CITY like 'i%' or CITY like 'u%'

-- Ex5
select distinct CITY from STATION
where CITY like '%a' or CITY like '%e' or CITY like '%i' or CITY like '%o' or CITY like '%u'

-- Ex6
select distinct CITY from STATION
where CITY not like 'u%' and CITY not like 'e%' and CITY not like 'o%' and CITY not like 'a%' and CITY not like 'i%'

-- Ex7
SELECT name from Employee
ORDER BY name 

-- Ex8
SELECT name FROM Employee
WHERE salary > 2000
AND months < 10
ORDER BY employee_id

--Ex9
SELECT product_id FROM Products
WHERE low_fats='Y'
AND recyclable='Y'

-- Ex10
SELECT name FROM Customer 
WHERE referee_id <> 2 
OR referee_id IS null

-- Ex11
SELECT name, population, area FROM World
Where area >= 3000000
OR population >= 25000000

-- Ex12
SELECT name, population, area FROM World
Where area >= 3000000
OR population >= 25000000

-- Ex13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL

-- Ex 14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000

-- Ex 15
select advertising_channel from uber_advertising
where money_spent > 100000
and year = 2019 











