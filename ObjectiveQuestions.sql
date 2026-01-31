
use bank_crm;
-- Question-1 Objective-- 
SELECT
    g.GeographyLocation,
    COUNT(b.CustomerId) AS Total_Customers,
    ROUND(SUM(b.Balance), 2) AS Total_Balance,
    ROUND(AVG(b.Balance), 2) AS Avg_Balance
FROM Bank_Churn b
JOIN CustomerInfo c
    ON b.CustomerId = c.CustomerId
Join Geography g 
on g.GeographyID=c.GeographyID
GROUP BY g.GeographyLocation
ORDER BY Total_Balance DESC;

-- Question-2 Objective-- 

SELECT
    CustomerId,
    Surname,
    EstimatedSalary,
    Bank_DOJ
FROM CustomerInfo
WHERE MONTH(Bank_DOJ) IN (10, 11, 12)
ORDER BY EstimatedSalary DESC
LIMIT 5;

-- Question-3 Objective-- 

Select 
	round(avg(NumofProducts),2) as Average_products
from Bank_churn 
where HasCrCard=1;

-- Question-4 Objective-- 

with ExitedCust as (
	Select 
		g.GenderCategory,
		Count(distinct c.CustomerID) as TotalCustomers,
		Sum(b.Exited) as ExitedCustomers
	from Gender g 
	join customerinfo c
	on c.GenderID=g.genderId
	join bank_churn b
	on c.CustomerId=b.customerID
	where Year(c.bank_DOj)=(Select max(Year(Bank_DOJ)) from Customerinfo)
	group by g.GenderCategory
)
Select 
	GenderCategory,
    round(ExitedCustomers*100/TotalCustomers,2) as ChurnRate
from ExitedCust
order by ChurnRate;

-- Question-5 Objective-- 
Select 
	e.ExitCategory,
    Round(avg(b.CreditScore),2) as Avg_CreditScore
from exitcustomer e
join bank_churn b
on b.Exited=e.ExitID
group by e.ExitCategory;

-- Question-6 Objective-- 

Select 
	g.GenderCategory as Gender,
    round(avg(c.EstimatedSalary),2) as Avg_EstimatedSalary,
    Sum(b.IsActiveMember) as ActiveCustomers,
    count(distinct c.customerID) as TotalCustomers
from Gender g
join customerinfo c
on c.GenderID=g.GenderID
join bank_churn b
on c.CustomerId=b.CustomerId
group by GenderCategory;

-- Question-7 Objective-- 

with new_help as(
	SELECT
		CustomerID,
		CreditScore,
		Exited,
		CASE
			WHEN CreditScore < 580 THEN 'Poor'
			WHEN CreditScore BETWEEN 580 AND 669 THEN 'Fair'
			WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good'
			WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good'
			ELSE 'Excellent'
		END AS CreditScore_Segment
	FROM Bank_Churn
)
select 
	CreditScore_Segment,
    Count(distinct CustomerID) as TotalCustomers,
    Sum(Exited) as Exit_Customers,
    round(sum(Exited)*100/count(distinct customerID),2) as ChurnRate
from new_help
group by CreditScore_Segment
order by ChurnRate desc;

-- Question-8 Objective-- 

Select 
	g.GeographyLocation,
    sum(b.IsActiveMember) as ActiveMembers
from geography g
join customerinfo c
on c.GeographyID=g.GeographyID
join bank_churn b
on b.CustomerId=c.CustomerId
group by GeographyLocation
order by Activemembers Desc;

-- Question-9 Objective-- 

SELECT
    HasCrCard,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Exited_Customers,
    ROUND(
        (SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(*),
        2
    ) AS Churn_Rate_Percentage
FROM Bank_Churn
GROUP BY HasCrCard;

-- Question-10 Objective-- 

SELECT
    NumOfProducts,
    COUNT(*) AS Exited_Customers_Count
FROM Bank_Churn
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY Exited_Customers_Count DESC;

-- Question-11 Objective-- 

Select 
	month(Bank_DOJ) as MonthOFJoin,
    count(distinct CustomerID) as Total_Customers
from customerinfo
group by month(Bank_DOJ);

Select 
	Year(Bank_DOJ) as MonthOFJoin,
    count(distinct CustomerID) as Total_Customers
from customerinfo
group by Year(Bank_DOJ);

-- Question-12 Objective-- 

SELECT
    NumOfProducts,
    COUNT(*) AS Exited_Customers,
    ROUND(AVG(Balance), 2) AS Avg_Balance,
    ROUND(SUM(Balance), 2) AS Total_Balance
FROM Bank_Churn
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- Question-13 Objective-- 

WITH retained AS (
    SELECT Balance
    FROM Bank_Churn
    WHERE Exited = 0
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN Balance END) AS Q1,
        MAX(CASE WHEN quartile = 3 THEN Balance END) AS Q3
    FROM (
        SELECT
            Balance,
            NTILE(4) OVER (ORDER BY Balance) AS quartile
        FROM retained
    ) t
)
SELECT
    r.Balance,
    q.Q1,
    q.Q3,
    (q.Q3 - q.Q1) AS IQR,
    (q.Q1 - 1.5 * (q.Q3 - q.Q1)) AS Lower_Bound,
    (q.Q3 + 1.5 * (q.Q3 - q.Q1)) AS Upper_Bound
FROM retained r
CROSS JOIN quartiles q
WHERE r.Balance < (q.Q1 - 1.5 * (q.Q3 - q.Q1))
   OR r.Balance > (q.Q3 + 1.5 * (q.Q3 - q.Q1));

-- Question-14 Objective-- 

-- Question-15 Objective-- 
Select 
	G.genderCategory as Gender,
    ge.GeographyLocation as Georgraphy,
    avg(c.estimatedSalary) as AvgEst_Salary,
    rank() over(partition by GeographyLocation 
    order by avg(EstimatedSalary) desc) as rnk 
from customerinfo c
join gender g
on g.GenderID=c.GenderID
join geography ge
on ge.GeographyID=c.GeographyID
group by g.GenderCategory,ge.GeographyLocation;

-- Question-16 Objective-- 
Select
	case 
		when age>=18 and age<=30 then '18-30'
        when age>=31 and age<=50 then '30-50'
        when age>50 then '50+'
	end as age_bracket,
    round(avg(b.tenure),2) as AvgTenure
from customerInfo c
join bank_churn b
on c.customerID=b.CustomerId
where b.exited=1
group by case 
		when age>=18 and age<=30 then '18-30'
        when age>=31 and age<=50 then '30-50'
        when age>50 then '50+'
        end 
order by AvgTenure;


-- Question-19 Objective-- 
with new_help as(
	SELECT
		CustomerID,
		CreditScore,
		Exited,
		CASE
			WHEN CreditScore < 580 THEN 'Poor'
			WHEN CreditScore BETWEEN 580 AND 669 THEN 'Fair'
			WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good'
			WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good'
			ELSE 'Excellent'
		END AS CreditScore_Segment
	FROM Bank_Churn
)
select 
	CreditScore_Segment,
    Sum(Exited) as Exit_Customers,
    rank() over(order by Sum(exited) desc) as rnk
from new_help
group by CreditScore_Segment
order by rnk asc;


-- Question- 20 Objective-- 
Select
		case 
			when age>=18 and age<=30 then '18-30'
			when age>=31 and age<=50 then '30-50'
			when age>50 then '50+'
		end as age_bracket,
	   sum(b.HasCrCard) as TotalCreditCardHolder
	from customerInfo c
	join bank_churn b
	on c.customerID=b.CustomerId
	where b.exited=1
	group by case 
			when age>=18 and age<=30 then '18-30'
			when age>=31 and age<=50 then '30-50'
			when age>50 then '50+'
			end ;
-- ---------------Part 2------------------
with helper19 as(
	Select
		case 
			when age>=18 and age<=30 then '18-30'
			when age>=31 and age<=50 then '30-50'
			when age>50 then '50+'
		end as age_bracket,
	   sum(b.HasCrCard) as TotalCreditCardHolder
	from customerInfo c
	join bank_churn b
	on c.customerID=b.CustomerId
	where b.exited=1
	group by case 
			when age>=18 and age<=30 then '18-30'
			when age>=31 and age<=50 then '30-50'
			when age>50 then '50+'
			end 
	order by TotalCreditCardHolder
)
Select 
	age_bracket,
    TotalCreditCardHolder
from helper19
where TotalCreditCardHolder < 
	(Select avg(TotalCreditCardHolder) from helper19);

-- Question-21 Objective-- 
with helper21 as(
   SELECT
        g.GeographyLocation,
        SUM(CASE WHEN b.Exited = 1 THEN 1 ELSE 0 END) 
        AS Churned_Customers,
        ROUND(AVG(b.Balance), 2) AS Avg_Balance
    FROM CustomerInfo c
    JOIN Bank_Churn b
	ON c.CustomerId = b.CustomerId
    join geography g 
    on g.GeographyID=c.GeographyID
    GROUP BY g.GeographyLocation
)
SELECT
    GeographyLocation,
    Churned_Customers,
    Avg_Balance,
    RANK() OVER (
        ORDER BY Churned_Customers DESC, Avg_Balance DESC
    ) AS Location_Rank
FROM helper21
ORDER BY Location_Rank;

-- Question-22 Objective-- 
Select
	CustomerID,
    Surname,
    concat(CustomerID,'_',Surname) as CustomerID_Surname
from customerinfo;

-- Question-23 Objective--
Select 
	CustomerID,
    (	
		select	
			ExitCategory
		from exitcustomer 
        where ExitID=b.Exited
    ) as ExitCategory
from bank_Churn b;

-- Question-24 Objective--
Select * from bank_churn where customerid is null;
Select * from customerinfo where customerid is null;
Select * from customerinfo where surname is null;
-- Question-25 Objective--
Select 
	c.CustomerID,
    c.Surname,
    a.ActiveCategory
from customerinfo c
join bank_churn b
on c.CustomerId=b.CustomerId
join activecustomer a
on b.isActiveMember=a.ActiveID
where c.Surname like "%on";

-- Question-26 Objective-- 


--
--
  
  
	