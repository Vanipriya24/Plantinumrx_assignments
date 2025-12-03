CREATE DATABASE CLINIC;
USE CLINIC;
CREATE TABLE clinics(
  cid VARCHAR(20),
  clinic_name VARCHAR(50),
  city VARCHAR(30),
  state VARCHAR(30),
  country VARCHAR(30)
);

INSERT INTO clinics VALUES
('C001','Sunrise Clinic','Mumbai','Maharashtra','India'),
('C002','Apollo Clinic','Chennai','Tamil Nadu','India'),
('C003','City Health Care','Delhi','Delhi','India'),
('C004','Green Valley Clinic','Pune','Maharashtra','India'),
('C005','Wellness Center','Hyderabad','Telangana','India'),
('C006','CarePlus Clinic','Bengaluru','Karnataka','India'),
('C007','Lifeline Clinic','Kolkata','West Bengal','India'),
('C008','HealthTree Clinic','Ahmedabad','Gujarat','India'),
('C009','Family Health Clinic','Jaipur','Rajasthan','India'),
('C010','PureCare Clinic','Lucknow','Uttar Pradesh','India'),
('C011','BetterLife Clinic','Surat','Gujarat','India'),
('C012','Urban Clinic','Nagpur','Maharashtra','India'),
('C013','GoodHealth Clinic','Coimbatore','Tamil Nadu','India'),
('C014','Healing Hands Clinic','Indore','Madhya Pradesh','India'),
('C015','PrimeCare Clinic','Visakhapatnam','Andhra Pradesh','India');

CREATE TABLE customer(
  uid VARCHAR(20),
  name VARCHAR(50),
  mobile VARCHAR(15)
);

INSERT INTO customer VALUES
('U001','John Doe','9876543210'),
('U002','Priya Sharma','9123456780'),
('U003','Amit Verma','9988776655'),
('U004','Sneha Kapoor','9090909090'),
('U005','Rahul Reddy','9812345678'),
('U006','Vikas Rao','9700012345'),
('U007','Meera Iyer','8877665544'),
('U008','Karan Patel','7894561230'),
('U009','Divya Singh','9898989898'),
('U010','Arjun Nair','9900112233'),
('U011','Lavanya S','9944221100'),
('U012','Rithik Jain','7766554433'),
('U013','Aarav Gupta','8123456789'),
('U014','Madhu Priya','9234567890'),
('U015','Varun Mehta','7012345678');

CREATE TABLE clinic_sales(
  oid VARCHAR(20),
  uid VARCHAR(20),
  cid VARCHAR(20),
  amount DECIMAL(10,2),
  datetime DATETIME,
  sales_channel VARCHAR(30)
);

INSERT INTO clinic_sales VALUES
('O001','U001','C001',20000,'2021-01-10 10:00:00','online'),
('O002','U002','C002',15000,'2021-02-14 12:00:00','offline'),
('O003','U003','C003',30000,'2021-03-05 15:45:00','online'),
('O004','U004','C004',18000,'2021-04-21 09:30:00','insurance'),
('O005','U005','C005',25000,'2021-05-18 11:40:00','online'),
('O006','U006','C006',22000,'2021-06-25 13:10:00','offline'),
('O007','U007','C007',17000,'2021-07-14 16:20:00','online'),
('O008','U008','C008',31000,'2021-08-30 14:50:00','insurance'),
('O009','U009','C009',26000,'2021-09-19 10:20:00','online'),
('O010','U010','C010',19500,'2021-10-11 08:45:00','offline'),
('O011','U011','C011',28500,'2021-11-23 17:00:00','online'),
('O012','U012','C012',24000,'2021-12-02 12:30:00','online'),
('O013','U013','C013',26500,'2021-06-05 11:10:00','insurance'),
('O014','U014','C014',17500,'2021-09-07 14:00:00','offline'),
('O015','U015','C015',35000,'2021-03-22 09:50:00','online');

CREATE TABLE expenses(
  eid VARCHAR(20),
  cid VARCHAR(20),
  description VARCHAR(50),
  amount DECIMAL(10,2),
  datetime DATETIME
);

INSERT INTO expenses VALUES
('E001','C001','Medicines',5000,'2021-01-12 09:00:00'),
('E002','C002','Maintenance',3000,'2021-02-18 10:30:00'),
('E003','C003','Staff Salary',8000,'2021-03-07 08:45:00'),
('E004','C004','Equipment Repair',4500,'2021-04-25 11:15:00'),
('E005','C005','Cleaning',2500,'2021-05-20 09:50:00'),
('E006','C006','Electricity',3200,'2021-06-28 14:00:00'),
('E007','C007','Water Supply',1500,'2021-07-16 15:10:00'),
('E008','C008','Admin Costs',4200,'2021-08-05 16:30:00'),
('E009','C009','Medical Waste',3700,'2021-09-25 13:20:00'),
('E010','C010','First Aid Supplies',2800,'2021-10-12 09:00:00'),
('E011','C011','Sanitization',3900,'2021-11-27 11:00:00'),
('E012','C012','Furniture Repair',5300,'2021-12-03 12:10:00'),
('E013','C013','Internet Charges',1800,'2021-06-01 10:00:00'),
('E014','C014','Stationery',1600,'2021-09-10 14:20:00'),
('E015','C015','Security',6000,'2021-03-24 17:45:00');

#QUERY1
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

#QUERY2
SELECT 
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

#QUERY3
WITH rev AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
exp AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT 
    r.month,
    r.revenue,
    e.expense,
    (r.revenue - e.expense) AS profit,
    CASE 
        WHEN (r.revenue - e.expense) >= 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM rev r
LEFT JOIN exp e ON r.month = e.month
ORDER BY r.month;

#QUERY4
WITH revenue AS (
    SELECT 
        c.cid,
        cl.city,
        SUM(c.amount) AS revenue
    FROM clinic_sales c
    JOIN clinics cl ON c.cid = cl.cid
    WHERE YEAR(c.datetime) = 2021
      AND MONTH(c.datetime) = 9  -- Example: September
    GROUP BY c.cid, cl.city
),
expense AS (
    SELECT 
        e.cid,
        SUM(e.amount) AS expense
    FROM expenses e
    WHERE YEAR(e.datetime) = 2021
      AND MONTH(e.datetime) = 9
    GROUP BY e.cid
),
profit_table AS (
    SELECT 
        r.cid,
        r.city,
        r.revenue,
        COALESCE(e.expense, 0) AS expense,
        (r.revenue - COALESCE(e.expense, 0)) AS profit
    FROM revenue r
    LEFT JOIN expense e ON r.cid = e.cid
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM profit_table
)
SELECT cid, city, revenue, expense, profit
FROM ranked
WHERE rnk = 1;

DROP DATABASE CLINIC;