use bank_crm;

-- Question- 01 Subjective--

with category as(
	SELECT
        Balance,
        NumOfProducts,
        Exited,
        CASE
            WHEN Tenure <= 3 THEN 'New Customers'
            WHEN Tenure > 5 THEN 'Long-Term Customers'
			else "Mid-Term Customers"
        END AS Customer_Type
	FROM Bank_Churn
)
SELECT
    Customer_Type,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Balance), 2) AS Avg_Balance,
    ROUND(AVG(NumOfProducts), 2) AS Avg_Products,
    SUM(CASE WHEN Exited = 0 THEN 1 ELSE 0 END) AS Active_Customers
FROM category
WHERE Customer_Type IN ('New Customers', 'Long-Term Customers')
GROUP BY Customer_Type;

-- Question- 02 Subjective--

SELECT
    C.Category,
    COUNT(b.CustomerID) AS Total_Customers,
    ROUND(AVG(b.NumOfProducts), 4) AS Avg_Num_Of_Products
FROM Bank_Churn b 
join CreditCard c
on b.HasCrCard=c.CreditID
GROUP BY C.Category;

SELECT
    a.ActiveCategory,
    COUNT(b.CustomerID) AS Total_Customers,
    ROUND(AVG(b.NumOfProducts), 2) AS Avg_Num_Of_Products
FROM Bank_Churn b 
join ActiveCUstomer a
on a.ActiveID=b.IsActiveMember
GROUP BY a.ActiveCategory;

SELECT
    NumOfProducts,
    COUNT(*) AS Customers
FROM Bank_Churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- Question- 03 Subjective--

SELECT
    G.GeographyLocation,
    COUNT(b.CustomerId) AS Total_Customers,
    SUM(CASE WHEN b.IsActiveMember = 1 THEN 1 ELSE 0 END) AS Active_Customers,
    SUM(CASE WHEN b.Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        (SUM(CASE WHEN b.Exited = 1 THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(b.CustomerId),
        2
    ) AS Churn_Rate_Percentage
FROM CustomerInfo c
JOIN Bank_Churn b
    ON c.CustomerId = b.CustomerId
JOIN Geography G 
	on g.GeographyID=c.GeographyID
GROUP BY G.GeographyLocation
ORDER BY Churn_Rate_Percentage DESC;

-- Question- 04 Subjective--
with Credit_Category as(
    SELECT
        CreditScore,
        Exited,
        CASE
            WHEN CreditScore < 580 THEN 'Poor'
            WHEN CreditScore BETWEEN 580 AND 669 THEN 'Fair'
            WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good'
            WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good'
            ELSE 'Excellent'
        END AS Credit_Score_Segment
    FROM Bank_Churn
)
SELECT
    Credit_Score_Segment,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        (SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(*),
        2
    ) AS Churn_Rate_Percentage
FROM Credit_Category
GROUP BY Credit_Score_Segment
ORDER BY Churn_Rate_Percentage DESC;

with helper as(
    SELECT
        c.Age,
        b.Exited,
        CASE
            WHEN c.Age BETWEEN 18 AND 30 THEN '18–30'
            WHEN c.Age BETWEEN 31 AND 50 THEN '31–50'
            ELSE '50+'
        END AS Age_Group
    FROM CustomerInfo c
    JOIN Bank_Churn b
        ON c.CustomerId = b.CustomerId
)
SELECT
    Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers
FROM helper
GROUP BY Age_Group
ORDER BY Churned_Customers DESC;

SELECT
    NumOfProducts,
    COUNT(*) AS Exited_Customers
FROM Bank_Churn
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

SELECT
    CASE
        WHEN Exited = 1 THEN 'Exited Customers'
        ELSE 'Retained Customers'
    END AS Customer_Status,
    ROUND(AVG(Balance), 2) AS Avg_Balance
FROM Bank_Churn
GROUP BY Customer_Status;

-- Question- 05 Subjective--

SELECT
    CASE
        WHEN Tenure <= 3 THEN 'Short Tenure'
        WHEN Tenure BETWEEN 4 AND 5 THEN 'Medium Tenure'
        ELSE 'Long Tenure'
    END AS Tenure_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Balance), 2) AS Avg_Balance,
    ROUND(AVG(NumOfProducts), 2) AS Avg_Products,
    SUM(CASE WHEN IsActiveMember = 1 THEN 1 ELSE 0 END) 
    AS Active_Customers
FROM Bank_Churn
GROUP BY Tenure_Segment
ORDER BY Avg_Balance DESC;

SELECT
    CASE
        WHEN Exited = 1 THEN 'Exited Customers'
        ELSE 'Retained Customers'
    END AS Customer_Status,
    ROUND(AVG(Tenure), 2) AS Avg_Tenure,
    ROUND(AVG(Balance), 2) AS Avg_Balance,
    ROUND(AVG(NumOfProducts), 2) AS Avg_Products
FROM Bank_Churn
GROUP BY Customer_Status;

SELECT
    a.ActiveCategory,
    COUNT(*) AS Customers,
    ROUND(AVG(Tenure), 2) AS Avg_Tenure,
    ROUND(AVG(Balance), 2) AS Avg_Balance,
    ROUND(AVG(NumOfProducts), 2) AS Avg_Products
FROM Bank_Churn b
join activecustomer a
on a.ActiveID=b.IsActiveMember
GROUP BY a.ActiveCategory;

-- Question- 06 Subjective--

SELECT
    YEAR(Bank_DOJ) AS Join_Year,
    MONTH(Bank_DOJ) AS Join_Month,
    COUNT(CustomerId) AS Customers_Joined
FROM CustomerInfo
GROUP BY YEAR(Bank_DOJ), MONTH(Bank_DOJ)
ORDER BY Join_Year, Join_Month;

SELECT
    CASE
        WHEN b.Tenure <= 3 THEN 
        'Early Churn (≤3 Years)'
        ELSE 'Longer Retention'
    END AS Retention_Category,
    COUNT(*) AS Customers
FROM Bank_Churn b
GROUP BY Retention_Category;

SELECT
    ROUND(AVG(NumOfProducts), 2) AS Avg_Products,
    ROUND(AVG(Balance), 2) AS Avg_Balance,
    SUM(CASE WHEN IsActiveMember = 1 THEN 1 ELSE 0 
    END) AS Active_Customers,
    COUNT(*) AS Total_Customers
FROM Bank_Churn
WHERE Tenure <= 3;

-- Question- 07 Subjective--

SELECT
    CASE
        WHEN CreditScore < 580 THEN 'Poor'
        WHEN CreditScore BETWEEN 580 AND 669 THEN 'Fair'
        WHEN CreditScore BETWEEN 670 AND 739 THEN 'Good'
        WHEN CreditScore BETWEEN 740 AND 799 THEN 'Very Good'
        ELSE 'Excellent'
    END AS Credit_Score_Segment,
    COUNT(*) AS Exited_Customers
FROM Bank_Churn
WHERE Exited = 1
GROUP BY Credit_Score_Segment
ORDER BY Exited_Customers DESC;

SELECT
    CASE
        WHEN Tenure <= 3 THEN 'Short Tenure'
        WHEN Tenure BETWEEN 4 AND 5 THEN 'Medium Tenure'
        ELSE 'Long Tenure'
    END AS Tenure_Group,
    COUNT(*) AS Exited_Customers
FROM Bank_Churn
WHERE Exited = 1
GROUP BY Tenure_Group
ORDER BY Exited_Customers DESC;

SELECT
    NumOfProducts,
    COUNT(*) AS Exited_Customers
FROM Bank_Churn
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

SELECT
    CASE
        WHEN Exited = 1 THEN 'Exited Customers'
        ELSE 'Retained Customers'
    END AS Customer_Status,
    ROUND(AVG(Balance), 2) AS Avg_Balance
FROM Bank_Churn
GROUP BY Customer_Status;

SELECT
    IsActiveMember,
    COUNT(*) AS Exited_Customers
FROM Bank_Churn
WHERE Exited = 1
GROUP BY IsActiveMember;

-- Question- 08 Subjective--

with helper as(
    SELECT
        Exited,
        CASE
            WHEN Tenure <= 3 THEN 'Short Tenure'
            WHEN Tenure BETWEEN 4 AND 5 THEN 'Medium Tenure'
            ELSE 'Long Tenure'
        END AS Tenure_Group
    FROM Bank_Churn
)
SELECT
    Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        (SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS Churn_Rate_Percentage
FROM helper
GROUP BY Tenure_Group
ORDER BY Churn_Rate_Percentage DESC;

SELECT
    NumOfProducts,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 
    END) AS Churned_Customers
FROM Bank_Churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;


SELECT
    IsActiveMember,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 
    END) AS Churned_Customers,
    ROUND(
        (SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 
        END) * 100.0) / COUNT(*),
        2
    ) AS Churn_Rate_Percentage
FROM Bank_Churn
GROUP BY IsActiveMember;

with salary_Category as(
    SELECT
        Exited,
        CASE
            WHEN EstimatedSalary < 50000 THEN 'Low Salary'
            WHEN EstimatedSalary BETWEEN 50000 
            AND 100000 THEN 'Medium Salary'
            ELSE 'High Salary'
        END AS Salary_Group
    FROM CustomerInfo c
    JOIN Bank_Churn b
        ON c.CustomerId = b.CustomerId
)
SELECT
    Salary_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers
FROM salary_category
GROUP BY Salary_Group;

-- Question- 09 Subjective--

SELECT
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN 'Young'
        WHEN Age BETWEEN 31 AND 50 THEN 'Middle-Aged'
        ELSE 'Senior'
    END AS Age_Group,
    g.GenderCategory,
    ge.GeographyLocation,
    COUNT(*) AS Customers
FROM CustomerInfo c
join gender g 
on g.GenderID=c.GenderID
join Geography ge
on ge.GeographyID=c.GeographyID
GROUP BY Age_Group, g.GenderCategory,ge.GeographyLocation
ORDER BY Customers DESC;

SELECT
    CASE
        WHEN Balance < 50000 THEN 'Low Value'
        WHEN Balance BETWEEN 50000 
        AND 150000 THEN 'Medium Value'
        ELSE 'High Value'
    END AS Value_Segment,
    ROUND(AVG(NumOfProducts), 2) AS Avg_Products,
    COUNT(*) AS Customers
FROM Bank_Churn
GROUP BY Value_Segment
ORDER BY Customers DESC;

SELECT
    CASE
        WHEN IsActiveMember = 1 AND NumOfProducts > 1 THEN 'Highly Engaged'
        WHEN IsActiveMember = 1 AND NumOfProducts = 1 THEN 'Moderately Engaged'
        ELSE 'Low Engagement'
    END AS Engagement_Segment,
    COUNT(*) AS Customers
FROM Bank_Churn
GROUP BY Engagement_Segment;

SELECT
    CASE
        WHEN c.Age BETWEEN 18 AND 30 
        THEN 'Young'
        WHEN c.Age BETWEEN 31 AND 50
        THEN 'Middle-Aged'
        ELSE 'Senior'
    END AS Age_Group,
    CASE
        WHEN b.Balance < 50000 THEN 'Low Value'
        WHEN b.Balance BETWEEN 50000 AND 150000
        THEN 'Medium Value'
        ELSE 'High Value'
    END AS Value_Segment,
    CASE
        WHEN b.IsActiveMember = 1 AND 
        b.NumOfProducts > 1 THEN 'Highly Engaged'
        WHEN b.IsActiveMember = 1 AND
        b.NumOfProducts = 1 THEN 'Moderately Engaged'
        ELSE 'Low Engagement'
    END AS Engagement_Segment,
    COUNT(*) AS Customers
FROM CustomerInfo c
JOIN Bank_Churn b
    ON c.CustomerId = b.CustomerId
GROUP BY Age_Group, Value_Segment, Engagement_Segment
ORDER BY Customers DESC;

-- Question- 10 Subjective--

SELECT
    CustomerId,
    Tenure,
    NumOfProducts,
    Balance,
    IsActiveMember,
    HasCrCard,
    Exited,
    CASE
        WHEN Exited = 1 THEN 'Already Churned'
        WHEN IsActiveMember = 0 AND Tenure <= 2 AND NumOfProducts = 1 THEN 'High Risk'
        WHEN IsActiveMember = 0 AND NumOfProducts <= 2 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Churn_Risk_Level
FROM Bank_Churn;

SELECT
    HasCrCard,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        (SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS Churn_Rate_Percentage
FROM Bank_Churn
GROUP BY HasCrCard;


-- Subjective 11 --

SELECT
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        (SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS Overall_Churn_Rate_Percentage
FROM Bank_Churn;

SELECT
    YEAR(c.Bank_DOJ) AS Join_Year,
    COUNT(b.CustomerId) AS Total_Customers,
    SUM(CASE WHEN b.Exited = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        (SUM(CASE WHEN b.Exited = 1 THEN 1 ELSE 0 END) * 100.0) 
        / COUNT(b.CustomerId),
        2
    ) AS Yearly_Churn_Rate_Percentage
FROM CustomerInfo c
JOIN Bank_Churn b
    ON c.CustomerId = b.CustomerId
GROUP BY YEAR(c.Bank_DOJ)
ORDER BY Join_Year;

SELECT
    CASE
        WHEN Tenure <= 3 THEN 'Short Tenure'
        WHEN Tenure BETWEEN 4 AND 5
        THEN 'Medium Tenure'
        ELSE 'Long Tenure'
    END AS Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) 
    AS Churned_Customers
FROM Bank_Churn
GROUP BY Tenure_Group
ORDER BY Churned_Customers DESC;

SELECT
    NumOfProducts,
    COUNT(*) AS Churned_Customers
FROM Bank_Churn
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

SELECT
    IsActiveMember,
    COUNT(*) AS Churned_Customers
FROM Bank_Churn
WHERE Exited = 1
GROUP BY IsActiveMember;


-- Question 14

ALTER TABLE Bank_Churn
RENAME COLUMN HasCrCard TO Has_creditcard;







