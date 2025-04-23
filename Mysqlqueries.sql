SELECT * FROM walmart;

DROP TABLE walmart;
-- 
SELECT COUNT(*) FROM walmart;

SELECT 
	payment_method ,
    COUNT(*)
FROM walmart
GROUP BY payment_method

USE walmart_db;
SELECT COUNT(DISTINCT Branch) FROM walmart;

USE walmart_db;
SELECT COUNT(DISTINCT Branch) FROM walmart;

SELECT MAX(quantity) FROM walmart;
SELECT MIN(quantity) FROM walmart;

DESCRIBE walmart;

-- Business Problems -- 


-- Q1. Find Different payment method and no of transacations , total quantity sold

SELECT 
	payment_method,
    COUNT(*) as no_payments,
    SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;


-- Q2.Identify the highest-rated category in each branch , displaying the branch, category 
-- AVG Rating 


SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rank = 1;

-- Q3. IDENTIFY THE BUSIEST DAY FOR EACH BRANCH BASED ON THE NUMBER OF TRANSACTIONS

SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rank = 1;

-- Q4. Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

SELECT
    payment_method,
    -- COUNT(*) AS no_payments,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method
ORDER BY no_qty_sold DESC;

-- Q5. Determine the average rating, minimum rating and maximum rating of products for each city.
-- List the city,average_rating, min_rating and max_rating.

SELECT 
	city,
    category,
    MIN(rating) as min_rating,
    MAX(rating) as max_rating,
    AVG(rating) as avg_rating
FROM walmart
GROUP BY city,category;

-- Q6.Calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin) 
-- List category and total_profit, ordered from highest to lowest profit.

SELECT 
	category,
    SUM(total) as revenue,
    SUM(total * profit_margin) as profit
FROM walmart 
GROUP BY category
ORDER BY total_profit DESC;

-- Q7.Determine the most common payment method for each branch. Display Branch and the preferred_payment_method.

SELECT branch, payment_method AS preferred_payment_method
FROM (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        ROW_NUMBER() OVER (
            PARTITION BY branch 
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM walmart
    GROUP BY branch, payment_method
) AS ranked
WHERE rn = 1;

-- Q8. Categorize sales into 3 groups MORNING,AFTERNOON,EVENING
-- FIND OUT each of the shift of invoices 

SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

-- Q9. Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)

WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;


