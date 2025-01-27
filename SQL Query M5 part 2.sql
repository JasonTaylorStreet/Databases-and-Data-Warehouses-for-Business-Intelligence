-- Challenge 1 - subqueries- use zagi
-- Find all the transaction totals smaller than the larger transaction totals for vendor Mountain king
-- Return vendorname, transaction id and the transaction total
-- Hint: the transaction total = quantity*productprice for each transaction. Use ANY function.
USE zagi;
SELECT vendorname, tid, quantity * productprice AS transaction_total
  FROM vendor v
    JOIN product p ON v.vendorid = p.vendorid
    JOIN includes i ON p.productid = i.productid
  WHERE i.quantity * p.productprice < ANY
    (SELECT MAX(i2.quantity * p2.productprice)
        FROM includes i2
          JOIN product p2 ON i2.productid = p2.productid
          JOIN vendor v2 ON p2.vendorid = v2.vendorid
        WHERE v2.vendorname = 'Mountain King');

-- Challenge 2 - funcions- use my_guitar_shop
-- Write a SELECT statement that uses regular expression functions to get the 
-- username and domain name parts of the email addresses in the Administrators table. 
-- Return these columns:
-- The email_address column
-- A column named user_name that contains the username part of the 
-- email_address column (the part before the @ symbol)
-- A column named domain_name that contains the domain name part
-- of the email_address column (the part after the @ symbol)
-- Note: The username part of the email addresses contains only letters, and the 
-- domain name part contains only letters and a period.
USE my_guitar_shop;
SELECT email_address,
  REGEXP_SUBSTR(email_address, '([^@]+)') AS user_name,
  REGEXP_SUBSTR(email_address, '([^@]+)$') AS domain_name
FROM administrators;

-- Challenge 3 - functions- use my_guitar_shop
-- Write a SELECT statement that uses the ranking functions to rank products by the 
-- total quantity sold. Return these columns:
-- The product_name column from the Products table
-- A column named total_quantity that shows the sum of the quantity for 
-- each product in the Order_Items table
-- A column named rank that uses the RANK function to rank the total 
-- quantity in descending sequence
-- A column named dense_rank that uses the DENSE_RANK function to 
-- rank the total quantity in descending sequence
USE my_guitar_shop;
SELECT product_name,
  SUM(oi.quantity) AS total_quantity,
  RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS `rank`,
  DENSE_RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS `dense_rank`
FROM products p
  JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY product_name
ORDER BY total_quantity DESC;

-- Challenge 4 - functions- use my_guitar_shop
-- Write a SELECT statement that uses the analytic functions to get the highest and 
-- lowest sales by product within each category. Return these columns:
-- The category_name column from the Categories table
-- The product_name column from the Products table
-- A column named total_sales that shows the sum of the sales for each 
-- product with sales in the Order_Items table
-- A column named highest_sales that uses the FIRST_VALUE function to 
-- show the name of the product with the highest sales within each category 
-- A column named lowest_sales that uses the LAST_VALUE function to 
-- show the name of the product with the lowest sales within each category
USE my_guitar_shop;
SELECT category_name, product_name,
  SUM((list_price - discount_amount) * quantity) AS total_sales,
  FIRST_VALUE(product_name) OVER (PARTITION BY c.category_id ORDER BY SUM((list_price - discount_amount) * quantity) DESC) AS highest_sales,
  LAST_VALUE(product_name) OVER (PARTITION BY c.category_id ORDER BY SUM((list_price - discount_amount) * quantity) ASC) AS lowest_sales
FROM categories c
  JOIN products p ON c.category_id = p.category_id
  JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY category_name, product_name; 