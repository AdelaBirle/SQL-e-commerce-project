CREATE DATABASE sport;
USE sport;


CREATE TABLE Product (
Product_ID INT NOT NULL AUTO_INCREMENT,
Product_Name Varchar(100) NOT NULL,
Category_ID INT NOT NULL,
Inventory_ID INT NOT NULL,
Price DECIMAL(6,3) NOT NULL,
PRIMARY KEY (Product_ID),
FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID),
FOREIGN KEY (Inventory_ID) REFERENCES Inventory(Inventory_ID)
);

CREATE TABLE Category (
Category_ID INT NOT NULL AUTO_INCREMENT,
Category_Name Varchar(100) NOT NULL,
Created DATE,
PRIMARY KEY(Category_ID)
);

CREATE TABLE Inventory (
Inventory_ID INT NOT NULL AUTO_INCREMENT,
Quantity INT NOT NULL,
Product_ID INT NOT NULL,
Created DATE,
PRIMARY KEY(Inventory_ID),
FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

CREATE TABLE Orders (
Order_ID INT NOT NULL AUTO_INCREMENT,
User_ID INT NOT NULL, 
Order_date DATE NOT NULL,
PRIMARY KEY(Order_ID),
FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE order_items (
Item_ID INT NOT NULL AUTO_INCREMENT,
Order_ID INT NOT NULL,
Product_ID INT NOT NULL,
Quantity INT NOT NULL,
Price DECIMAL(6,3) NOT NULL,
Created DATE,
PRIMARY KEY(Item_ID),
FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

CREATE TABLE User (
User_ID INT NOT NULL AUTO_INCREMENT,
First_Name Varchar(100) NOT NULL,
Last_Name Varchar(100) NOT NULL,
Mobile INT NOT NULL,
Amount DECIMAL(10,3) NOT NULL,
User_Status Varchar(50),
Created DATE  NOT NULL,
PRIMARY KEY(USER_ID)
);

CREATE TABLE user_address (
Address_ID INT NOT NULL AUTO_INCREMENT,
User_ID INT NOT NULL,
Adress Varchar(255) NOT NULL,
City Varchar(100) NOT NULL,
Postal_Cod INT,
Created DATE,
PRIMARY KEY(Adress_ID),
FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE Account (
Account_ID INT NOT NULL AUTO_INCREMENT,
Userame Varchar(100),
Password Varchar(15),
Active BOOLEAN,
User_ID INT NOT NULL,
Created DATE NOT NULL,
Subscription INT,
PRIMARY KEY(Account_ID),
FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

-- Add values
-- Values imported from CSV File

INSERT INTO Product (Product_ID, Product_Name, Category_ID, Inventory_ID, Price) 
VALUES 
('ON Shoes', 1, 1, 250),
('Adidas Shose', 1, 2, 180),
('Nike Shose', 1, 3, 220),
('Hoodie', 2, 4, 70),
('T-shirt', 2, 5, 25.5),
('Joggers', 2, 6, 30),
('Leggings', 2, 7, 28),
('Gloves', 3, 8, 25),
('Hat', 3, 9, 18.5),
('Bagpack', 3, 10, 92)
;

INSERT INTO Category
VALUES 
('Footwear', '2020-01-02'),
('Clothing', '2020-01-02'),
('Accessories', '2020-01-02')
;

 INSERT INTO Inventory
VALUES 
(1, 80, '2020-01-02'),
(2, 160, '2020-01-02'),
(3, 220, '2020-01-02'),
(4, 50, '2020-01-02'),
(5, 200, '2020-01-02'),
(6, 50, '2020-01-02'),
(7, 40, '2020-01-02'),
(8, 20, '2020-03-10'),
(9, 15, '2020-03-10'),
(10, 15, '2020-03-10')
;

 INSERT INTO Orders (User_ID, Date)
VALUES 
(1, '01.03.2020'),
(2, '2020-05-15'),
(3,'2021-01-07'),
(4, '2021-08-25'),
(5, '2021-12-06'),
(5, '2021-12-14'),
(1,'2021-11-10')
;

INSERT INTO order_items (Order_ID, Product_ID, Quantity, Price)
VALUES 
(1, 1, 2, 250),
(1, 3, 1, 220),
(2, 4, 1, 70),
(2, 8, 1, 25),
(3, 5, 4, 25.5),
(4, 10, 2, 92),
(5, 3, 1, 220),
(6, 1, 2, 250),
(7, 5, 1, 25.5)
;

 INSERT INTO User
VALUES 
('Adam','Fox', 480, '555-300', '2020-05-15', 'Platinum'),
('Maria','Lopez', 2875, '555-400', '2021-01-07','Gold'),
('Sara','Gray', 8750, '555-500', '2021-08-25', 'Gold'),
('Michel','Duglas',1200, '555-600', '2021-12-06','Silver'),
('Emma','Stone', 20, '555-700', '2021-12-14','Platinum')
;

 INSERT INTO user_address
VALUES 
(1, '1411 Lillydale Drive', 'Zurich', 35200, '2020-01-03'),
(2, '1913 Hanoi Way', 'Zurich', 17886, '2020-05-15'),
(3, '1121 Loja Avenue', 'Bern', 83579, '2021-01-07'),
(4, '692 Joliet Street', 'Zug', 53561, '2021-08-25'),
(5, '1566 Inegl Manor', 'Lucern', 42399, '2021-12-06')
;

INSERT INTO Account
VALUES
(1, 'AdamF','vwvwi5', 1, '2020-03-01', 1),
(2, 'MariaL','veiurvnrnn', 1, '2020-05-15',1),
(4,'SaraG','vevjrbv9', 1, '2020-08-25',1)
;

-- View using Joins 
-- Show users addresses and active accounts.

CREATE VIEW users_addresses_accounts
AS
SELECT u.first_name, 
u.last_name, 
ad.address, 
ad.city, 
a.active
FROM USER u 
INNER JOIN user_address ad  ON u.user_id = ad.ADDRESS_ID
LEFT JOIN account a ON a.user_id = u.user_id;

-- QUERY USING VIEW 
SELECT * FROM users_addresses_accounts;

SELECT * FROM users_addresses_accounts
WHERE active = 1 AND city = 'Zurich';

-- Stored Function
-- Sets users status by their amount

DELIMITER //
CREATE FUNCTION get_user_status(Amount int)
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
DECLARE user_status VARCHAR(25);
    IF Amount < 500 THEN
        SET user_status = 'Platinum';
    ELSEIF (Amount >= 500 AND Amount < 1500) THEN  
        SET user_status = 'Silver';
    ELSEIF Amount >= 1500 THEN  
        SET user_status = 'Gold';  
    END IF;  
    RETURN (user_status);  
END// 
DELIMITER ;

-- Show our users status - QUERY

SELECT u.user_id, 
u.first_name,
u.last_name, 
get_user_status(amount)
FROM user u
ORDER BY u.user_id;


-- SELECT in SELECT - nested select
-- Find all my clients from Zurich

select u.first_name, 
u.last_name, 
u.mobile 
from user u
Where u.user_id in 
(select a.user_id from user_address a where a.city = 'Zurich');

-- ADVANCED OPTIONS
-- TRIGGER
-- When a new user will be created, the trigger will set his status based on his amount. 
-- Inside the trigger I implemented the get_user_status function. 

DELIMITER //
CREATE TRIGGER set_user_status
BEFORE INSERT on user
FOR EACH ROW
BEGIN
SET NEW.user_status = get_user_status(NEW.amount);
END//

DELIMITER ;

-- new user
INSERT INTO user (first_name, last_name, mobile, amount, created)
VALUES ('Max', 'Smith', '600-300', 2500.00, '2020-01-07');

SELECT * FROM user;

-- EVENT created to update the user subscription days

DELIMITER //
--
-- DROP EVENT subscription_days;

CREATE EVENT subscription_days
ON SCHEDULE EVERY 1 SECOND
STARTS NOW()
DO BEGIN
	
UPDATE account
SET Subscription = Subscription + 1;

END//
DELIMITER ;

SELECT * FROM ACCOUNT;
