-- M5- Q1 - Write a SELECT statement that returns the same result set as this SELECT statement, but don’t use a join. Instead, use a subquery in a WHERE clause that uses the IN keyword.

-- SELECT DISTINCT category_name
-- FROM categories c JOIN products p
--  ON c.category_id = p.category_id
--  ORDER BY category_name;
 -- solution:
USE my_guitar_shop;
SELECT DISTINCT category_name
FROM categories
  WHERE category_id IN (SELECT category_id FROM products)
ORDER BY category_name;

-- M5-Q2 
-- Write a SELECT statement that answers this question: 
-- Which products have a list price that’s greater than the average list price for all products?
-- Return the `product_name` and `list_price` columns for each product.
-- Sort the result set by the `list_price` column in descending sequence.
USE my_guitar_shop;
SELECT product_name, list_price
FROM products
  WHERE list_price > (SELECT AVG(list_price) FROM products)
ORDER BY list_price DESC;

-- M5-Q3
-- Write a SELECT statement that returns the `category_name` column from the Categories table.
-- Return one row for each category that has never been assigned to any product in the Products table. 
-- To do that, use a subquery introduced with the NOT EXISTS operator.
USE my_guitar_shop;
SELECT category_name
FROM categories c
  WHERE NOT EXISTS (SELECT * FROM products p
    WHERE p.category_id = c.category_id);

-- M5-Q4
-- Write a SELECT statement that returns three columns: `email_address`, `order_id`, and the `order total` for each customer. 
-- To do this, you can group the result set by the `email_address` and `order_id` columns. 
-- In addition, you must calculate the order total from the columns in the Order_Items table.
-- **Do not submit this query - use it as a subquery**
-- Write a second SELECT statement that uses the first SELECT statement in its FROM clause.
--  The main query should return two columns: the customer’s `email address` and the largest order for that customer. 
--  To do this, you can group the result set by the `email_address`. 
--  Sort the result set by the largest order in descending sequence.  
USE my_guitar_shop;
SELECT email_address, MAX(order_total) AS largest_order
FROM (SELECT c.email_address, oi.order_id, SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS order_total
      FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_items oi ON o.order_id = oi.order_id
      GROUP BY c.email_address, oi.order_id) AS subquery_q4
GROUP BY email_address
ORDER BY largest_order DESC;

-- M5 - Q5
-- Write a SELECT statement that returns the `product_name` and `discount percent` of each product that has a unique `discount percent`. 
-- In other words, don’t include products that have the same `discount percent` as another product.
-- Sort the result set by the `product_name` column.
USE my_guitar_shop;
SELECT product_name, p.discount_percent
FROM (SELECT discount_percent
        FROM products
        GROUP BY discount_percent
          HAVING COUNT(*) = 1) AS ud
JOIN products p ON ud.discount_percent = p.discount_percent
ORDER BY product_name;

-- M5 - Q6
-- Use a correlated subquery to return one row per customer, representing the customer’s oldest order (the one with the earliest date). Each row should include these three columns: email_address, order_id, and order_date.
-- Sort the result set by the order_date and order_id columns.
USE my_guitar_shop;
SELECT email_address, o.order_id, o.order_date
  FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
  WHERE o.order_date = (SELECT MIN(order_date)
      FROM orders
      WHERE customer_id = c.customer_id)
ORDER BY o.order_date, o.order_id;

-- M5 - Q7
-- Write a SELECT statement that returns these columns from the Products table:
-- The `list_price` column
-- A column that uses the FORMAT function to return the `list_price` column with 1 digit to the right of the decimal point
-- A column that uses the CONVERT function to return the `list_price` column as an integer
-- A column that uses the CAST function to return the `list_price` column as an integer
USE my_guitar_shop;
SELECT list_price, FORMAT(list_price, 1) AS formatted_list_price,
       CONVERT(list_price, UNSIGNED) AS converted_list_price,
       CAST(list_price AS UNSIGNED) AS casted_list_price
FROM products;

-- M5-Q8
-- Write a SELECT statement that returns these columns from the Products table:
-- The `date_added` column
-- A column that uses the CAST function to return the date_added column with its date only (year, month, and day)
-- A column that uses the CAST function to return the date_added column with just the year and the month
-- A column that uses the CAST function to return the date_added column with its full time only (hour, minutes, and seconds)
USE my_guitar_shop;
SELECT date_added, CAST(date_added AS DATE) AS date_only,
       CAST(date_added AS CHAR(7)) AS year_and_month,
       CAST(date_added AS TIME) AS time_only
FROM products;

-- M5-Q9
-- Write a SELECT statement that returns these columns from the Products table:
-- The `list_price` column
-- The `discount_percent` column
-- A column named `discount_amount` that uses the previous two columns to calculate the discount amount and uses the ROUND function to round the result so it has 2 decimal digits
USE my_guitar_shop;
SELECT list_price, discount_percent, ROUND((list_price * discount_percent / 100), 2) AS discount_amount
FROM products;

-- M5-Q10
-- Write a SELECT statement that returns these columns from the Orders table:
-- The `order_date` column
-- A column that uses the DATE_FORMAT function to return the four-digit year that’s stored in the `order_date` column
-- A column that uses the DATE_FORMAT function to return the `order_date` column in this format: Mon-DD-YYYY. In other words, use abbreviated months and separate each date component with dashes.
-- A column that uses the DATE_FORMAT function to return the `order_date` column with only the hours and minutes on a 12-hour clock with an am/pm indicator
-- A column that uses the DATE_FORMAT function to return the `order_date` column in this format: MM/DD/YY HH:i. In other words, use two-digit months, days, and years and separate them by slashes. Use 2-digit hours and minutes on a 24-hour clock. And use leading zeros for all date/time components.
USE my_guitar_shop;
SELECT order_date, DATE_FORMAT(order_date, '%Y') AS four_digit_year,
       DATE_FORMAT(order_date, '%b-%d-%Y') AS mon_dd_yyyy_format,
       DATE_FORMAT(order_date, '%h:%i %p') AS hours_minutes_am_pm,
       DATE_FORMAT(order_date, '%m/%d/%y %H:%i') AS mm_dd_yy_hh_mi_format
FROM orders;

-- M5- Q11
-- Write a SELECT statement that returns these columns from the Orders table:
-- The `card_number` column
-- The length of the `card_number` column
-- When you get that working right, add the columns that follow to the result set. This is more difficult because these columns require the use of functions within functions.
-- The last four digits of the `card_number` column
-- A column that displays an X for each digit of the `card_number` column except for the last four digits.
-- If the card number contains 16 digits, it should be displayed in this format: XXXX-XXXX-XXXX-1234, where 1234 are the actual last four digits of the number. 
-- If the card number contains 15 digits, it should be displayed in this format: XXXX-XXXXXX-X1234. 
-- (Hint: Use an IF function to determine which format to use.)
USE my_guitar_shop;
SELECT card_number, LENGTH(card_number) AS card_number_length,
       RIGHT(card_number, 4) AS last_four_digits,
  IF(LENGTH(card_number) = 16, CONCAT('XXXX-XXXX-XXXX-', RIGHT(card_number, 4)), 
     CONCAT('XXXX-XXXXXX-X', RIGHT(card_number, 4))) AS masked_card_number
FROM orders;

-- M5-Q12
-- Write a SELECT statement that returns these columns from the Orders table:
-- The `order_id` column
-- The `order_date` column
-- A column named `approx_ship_date` that’s calculated by adding 2 days to the `order_date` column
-- The `ship_date` column if it doesn’t contain a null value
-- A column named `days_to_ship` that shows the number of days between the order date and the ship date
-- When you have this working, add a WHERE clause that retrieves just the orders for March 2018.
USE my_guitar_shop;
SELECT order_id, order_date, DATE_ADD(order_date, INTERVAL 2 DAY) AS approx_ship_date,
-- assumed I was to not include the row where ship_date is Null (vice not displaying the column altogether since there was a Null value)
       ship_date, DATEDIFF(ship_date, order_date) AS days_to_ship
FROM orders
  WHERE MONTH(order_date) = 3 AND YEAR(order_date) = 2018 AND ship_date IS NOT NULL;