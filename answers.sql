-- Question 1: Transforming to 1NF (First Normal Form)
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert sample data
INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

CREATE TABLE OrderDetails_1NF AS
SELECT 
    OrderID, 
    CustomerName, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product,
    1 AS Quantity
FROM 
    ProductDetail
JOIN 
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) numbers
    ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1;

-- Question 2: Transforming to 2NF (Second Normal Form)
CREATE TABLE Orders AS
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails_1NF;

-- Create OrderProducts table
CREATE TABLE OrderProducts AS
SELECT OrderID, Product, Quantity
FROM OrderDetails_1NF;

ALTER TABLE Orders ADD PRIMARY KEY (OrderID);
ALTER TABLE OrderProducts ADD PRIMARY KEY (OrderID, Product);
ALTER TABLE OrderProducts ADD CONSTRAINT fk_order
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID);

SELECT 'Original ProductDetail table (not 1NF):' AS Description;
SELECT * FROM ProductDetail;

SELECT '1NF-compliant table (OrderDetails_1NF):' AS Description;
SELECT * FROM OrderDetails_1NF;

SELECT '2NF-compliant Orders table:' AS Description;
SELECT * FROM Orders;

SELECT '2NF-compliant OrderProducts table:' AS Description;
SELECT * FROM OrderProducts;
