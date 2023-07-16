USE sakila;

#Instructions
-- Write the SQL queries to answer the following questions:
-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT(CONCAT(c.first_name, ' ', c.last_name)) AS name, c.email, a.address
FROM address AS a
JOIN customer AS c ON a.address_id = c.address_id
JOIN rental AS r ON r.customer_id = c.customer_id
ORDER BY 1;

-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS name, AVG(p.amount) AS avg_payment
FROM customer AS c 
JOIN payment AS p ON p.customer_id = c.customer_id
GROUP BY 1, 2;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.
SELECT * FROM customer; 
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

# Write the query using multiple join statements
SELECT DISTINCT(CONCAT(c.first_name, ' ', c.last_name)) AS name, c.email
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id
JOIN film_category AS fc ON fc.film_id = f.film_id 
JOIN category AS ca ON ca.category_id = fc.category_id
WHERE ca.name = 'Action'
ORDER BY 1;

# Write the query using sub queries with multiple WHERE clause and IN condition
SELECT DISTINCT(CONCAT(c.first_name, ' ', c.last_name)) AS name, c.email
FROM (
    SELECT customer_id, first_name, last_name, email
    FROM customer
    WHERE customer_id IN (
        SELECT customer_id
        FROM rental
        WHERE inventory_id IN (
            SELECT inventory_id
            FROM inventory
            WHERE film_id IN (
                SELECT film_id
                FROM film
                WHERE film_id IN (
                    SELECT film_id
                    FROM film_category
                    WHERE category_id IN (
                        SELECT category_id
                        FROM category
                        WHERE name = 'Action'
                    )
                )
            )
        )
    )
) AS c
ORDER BY 1;

# Verify if the above two queries produce the same results or not

/* 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, 
then it should be high.*/ 

SELECT *, 
CASE 
	WHEN amount BETWEEN 0 AND 2 THEN 'low' 
	WHEN amount > 2 AND amount <= 4 THEN 'medium'
    WHEN amount > 4 THEN 'high'
	ELSE 'unknown' 
END AS value_transaction
FROM payment
ORDER BY amount;
