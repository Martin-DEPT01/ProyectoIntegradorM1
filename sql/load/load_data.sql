LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/categories.csv'
INTO TABLE categories
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';
-- C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\

SHOW VARIABLES LIKE 'local_infile';
-- OFF  --> PARA MODIFICAR ESTO SE AGREGA UNA LINEA EN EL ARCHIVO "my.ini"


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cities.csv'
INTO TABLE cities
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/countries.csv'
INTO TABLE countries
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


ALTER TABLE sales
MODIFY SalesDate DATETIME NULL;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(SalesID, SalesPersonID, CustomerID, ProductID, Quantity, Discount, TotalPrice, @SalesDate, TransactionNumber)
SET SalesDate = NULLIF(@SalesDate, '');


SELECT CONCAT(SUBSTR(SalesDate,1,4),SUBSTR(SalesDate,6,2),SUBSTR(SalesDate,9,2)) FECHA, COUNT(*) FROM sales
GROUP BY CONCAT(SUBSTR(SalesDate,1,4),SUBSTR(SalesDate,6,2),SUBSTR(SalesDate,9,2))
ORDER BY 1;







