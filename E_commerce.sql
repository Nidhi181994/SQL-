CREATE DATABASE E_commerce;

USE E_commerce;

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    OrderStatus VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert Categories
INSERT INTO Categories (CategoryName) VALUES ('Electronics');
INSERT INTO Categories (CategoryName) VALUES ('Books');
INSERT INTO Categories (CategoryName) VALUES ('Clothing');

-- Insert Products
INSERT INTO Products (Name, Description, Price, CategoryID) VALUES ('Laptop', 'High-performance laptop', 1200.00, 1);
INSERT INTO Products (Name, Description, Price, CategoryID) VALUES ('The Great Gatsby', 'Classic novel', 10.99, 2);
INSERT INTO Products (Name, Description, Price, CategoryID) VALUES ('T-Shirt', 'Comfortable cotton t-shirt', 25.00, 3);
INSERT INTO Products (Name, Description, Price, CategoryID) VALUES ('Smartphone', 'Latest generation smartphone', 999.99, 1);
INSERT INTO Products (Name, Description, Price, CategoryID) VALUES ('To Kill a Mockingbird', 'Pulitzer Prize-winning novel', 12.50, 2);

-- Insert Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Main St');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '456 Oak Ave');

-- Insert Orders
INSERT INTO Orders (CustomerID) VALUES (1); -- John Doe's first order
INSERT INTO Orders (CustomerID) VALUES (2); -- Jane Smith's first order
INSERT INTO Orders (CustomerID) VALUES (1); -- John Doe's second order

-- Insert Order Items for the first order
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES (1, 1, 1, 1200.00); -- Laptop
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES (1, 2, 2, 10.99);   -- 2 books

-- Insert Order Items for the second order
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES (2, 3, 1, 25.00);   -- T-Shirt
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES (2, 4, 1, 999.99);  -- Smartphone

-- Insert Order Items for the third order
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES (3, 5, 1, 12.50);   -- Book

SELECT * FROM Products;
SELECT * FROM Orders WHERE CustomerID = 1;
SELECT oi.Quantity, oi.UnitPrice, p.Name AS ProductName
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
WHERE oi.OrderID = 1;
SELECT SUM(Quantity * UnitPrice) AS TotalCost
FROM OrderItems
WHERE OrderID = 1;

-- Shipping_Address
ALTER TABLE Customers
ADD COLUMN ShippingAddress TEXT,
ADD COLUMN ShippingCity VARCHAR(100),
ADD COLUMN ShippingState VARCHAR(100),
ADD COLUMN ShippingZipCode VARCHAR(20),
ADD COLUMN ShippingCountry VARCHAR(100);


-- Payment
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50) NOT NULL,
    TransactionID VARCHAR(100) UNIQUE, -- Unique identifier from the payment gateway
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentStatus VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- User 
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL, -- In a real app, HASH this!
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Customers
ADD COLUMN UserID INT UNIQUE,
ADD FOREIGN KEY (UserID) REFERENCES Users(UserID);

-- Insert User
INSERT INTO Users (Email, Password, FirstName, LastName) VALUES ('john.doe@example.com', 'simplepassword', 'John', 'Doe');
INSERT INTO Users (Email, Password, FirstName, LastName) VALUES ('jane.smith@example.com', 'anotherpass', 'Jane', 'Smith');

-- Update Customers to link to Users
UPDATE Customers SET UserID = 1 WHERE FirstName = 'John' AND LastName = 'Doe';
UPDATE Customers SET UserID = 2 WHERE FirstName = 'Jane' AND LastName = 'Smith';

-- Add shipping information for customers
UPDATE Customers SET ShippingAddress = '123 Main St', ShippingCity = 'Delhi', ShippingState = 'DL', ShippingZipCode = '110001', ShippingCountry = 'India' WHERE CustomerID = 1;
UPDATE Customers SET ShippingAddress = '456 Oak Ave', ShippingCity = 'Bangalore', ShippingState = 'KA', ShippingZipCode = '560001', ShippingCountry = 'India' WHERE CustomerID = 2;

-- Insert Payments
INSERT INTO Payments (OrderID, PaymentMethod, TransactionID, Amount, PaymentStatus) VALUES (1, 'Credit Card', 'TRANS12345', 1221.98, 'Completed');
INSERT INTO Payments (OrderID, PaymentMethod, TransactionID, Amount, PaymentStatus) VALUES (2, 'PayPal', 'PAY67890', 1024.99, 'Completed');
INSERT INTO Payments (OrderID, PaymentMethod, TransactionID, Amount, PaymentStatus) VALUES (3, 'Debit Card', 'TRANS98765', 12.50, 'Pending');

SELECT * From Customers;