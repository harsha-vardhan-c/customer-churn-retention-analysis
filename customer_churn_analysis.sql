CREATE DATABASE customer_churn_analysis;
USE customer_churn_analysis;
CREATE DATABASE IF NOT EXISTS customer_churn_analysis;
USE customer_churn_analysis;

DROP TABLE IF EXISTS customer_churn;

CREATE TABLE customer_churn (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10),
    review_score DECIMAL(3,1),
    order_count INT,
    customer_type VARCHAR(30),
    delivery_delay_days DECIMAL(10,2),
    delivery_status VARCHAR(20)
);





USE customer_churn_analysis;



-- Q1. How many total customers are there?
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customer_churn;


-- Q2. How many are one-time customers?
SELECT COUNT(DISTINCT customer_unique_id) AS one_time_customers
FROM customer_churn
WHERE customer_type = 'One-Time Customer';


-- Q3. How many are repeat customers?
SELECT COUNT(DISTINCT customer_unique_id) AS repeat_customers
FROM customer_churn
WHERE customer_type = 'Repeat Customer';


-- Q4. What percentage of customers are repeat customers?
SELECT
    ROUND(
        100 * COUNT(DISTINCT CASE
            WHEN customer_type = 'Repeat Customer'
            THEN customer_unique_id
        END) / COUNT(DISTINCT customer_unique_id),
        2
    ) AS repeat_customer_rate
FROM customer_churn;


-- Q5. What is the distribution of one-time vs repeat customers?
SELECT
    customer_type,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_churn
GROUP BY customer_type;


-- Q6. What is the average review score for each customer type?
SELECT
    customer_type,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM customer_churn
GROUP BY customer_type;


-- Q7. Does delivery performance differ between one-time and repeat customers?
SELECT
    customer_type,
    delivery_status,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_churn
GROUP BY customer_type, delivery_status
ORDER BY customer_type, customers DESC;


-- Q8. What is the average delivery delay for each customer type?
SELECT
    customer_type,
    ROUND(AVG(delivery_delay_days), 2) AS avg_delivery_delay_days
FROM customer_churn
GROUP BY customer_type;


-- Q9. How does review score relate to customer type?
SELECT
    customer_type,
    review_score,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_churn
WHERE review_score IS NOT NULL
GROUP BY customer_type, review_score
ORDER BY customer_type, review_score;


-- Q10. Which states have the most customers?
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_churn
GROUP BY customer_state
ORDER BY customers DESC;


-- Q11. How many customers are acquired each month?
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_churn
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month;


-- Q12. What is the relationship between review score and delivery status?
SELECT
    delivery_status,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(DISTINCT customer_unique_id) AS customers
FROM customer_churn
WHERE review_score IS NOT NULL
GROUP BY delivery_status;


-- Q13. What is the overall customer experience by customer type?
SELECT
    customer_type,
    COUNT(DISTINCT customer_unique_id) AS customers,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(AVG(delivery_delay_days), 2) AS avg_delivery_delay
FROM customer_churn
GROUP BY customer_type;


-- Q14. How many one-time customers experienced late delivery?
SELECT
    COUNT(DISTINCT customer_unique_id) AS one_time_late_customers
FROM customer_churn
WHERE customer_type = 'One-Time Customer'
  AND delivery_status = 'Late';


-- Q15. How many repeat customers experienced late delivery?
SELECT
    COUNT(DISTINCT customer_unique_id) AS repeat_late_customers
FROM customer_churn
WHERE customer_type = 'Repeat Customer'
  AND delivery_status = 'Late';