CREATE DATABASE HOTELS;
USE HOTELS;

CREATE TABLE users(
    user_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50),
    phone_number VARCHAR(15),
    mail_id VARCHAR(50),
    billing_address VARCHAR(100)
);

INSERT INTO users VALUES
('U001','John Doe','9876543210','john.doe@example.com','XX, Street Y, ABC City'),
('U002','Priya Rajan','9123456780','priya.rajan@example.com','Street Z, DEF City'),
('U003','Rahul Verma','9988776655','rahul.verma@example.com','Street A, GHI City'),
('U004','Sneha Kapoor','9090909090','sneha.kapoor@example.com','Street B, JKL City'),
('U005','Vikas Rao','9812345678','vikas.rao@example.com','Street C, MNO City'),
('U006','Meera Iyer','8877665544','meera.iyer@example.com','Street D, PQR City'),
('U007','Karan Patel','7894561230','karan.patel@example.com','Street E, STU City'),
('U008','Divya Singh','9898989898','divya.singh@example.com','Street F, VWX City'),
('U009','Arjun Nair','9900112233','arjun.nair@example.com','Street G, YZA City'),
('U010','Lavanya S','9944221100','lavanya.s@example.com','Street H, BCD City');

CREATE TABLE bookings(
    booking_id VARCHAR(20) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(20),
    user_id VARCHAR(20)
);

INSERT INTO bookings VALUES
('B001','2021-09-23 07:36:48','R101','U001'),
('B002','2021-11-05 10:15:00','R205','U002'),
('B003','2021-10-21 16:30:00','R310','U003'),
('B004','2021-11-10 14:00:00','R118','U004'),
('B005','2021-07-15 12:20:00','R202','U005'),
('B006','2021-08-12 09:45:00','R305','U006'),
('B007','2021-06-18 18:00:00','R110','U007'),
('B008','2021-12-03 15:10:00','R401','U008'),
('B009','2021-09-29 11:30:00','R501','U009'),
('B010','2021-11-22 13:45:00','R602','U010');

CREATE TABLE booking_commercials(
    id VARCHAR(20) PRIMARY KEY,
    booking_id VARCHAR(20),
    bill_id VARCHAR(20),
    bill_date DATETIME,
    item_id VARCHAR(20),
    item_quantity DECIMAL(5,2)
);

INSERT INTO booking_commercials VALUES
('BC001','B001','BL001','2021-09-23 12:03:22','ITM001',5),
('BC002','B001','BL001','2021-09-23 12:03:22','ITM002',10),
('BC003','B002','BL002','2021-11-05 11:00:00','ITM003',6),
('BC004','B003','BL003','2021-10-21 17:00:00','ITM002',15),
('BC005','B004','BL004','2021-11-10 15:00:00','ITM001',8),
('BC006','B005','BL005','2021-07-15 13:00:00','ITM003',5),
('BC007','B006','BL006','2021-08-12 10:00:00','ITM001',10),
('BC008','B007','BL007','2021-06-18 19:00:00','ITM002',13),
('BC009','B008','BL008','2021-12-03 16:00:00','ITM003',9),
('BC010','B009','BL009','2021-09-29 12:00:00','ITM001',9);
drop table booking_commercials;
CREATE TABLE items(
    item_id VARCHAR(20) PRIMARY KEY,
    item_name VARCHAR(50),
    item_rate DECIMAL(10,2)
);

INSERT INTO items VALUES
('ITM001','Tawa Paratha',18),
('ITM002','Mix Veg',89),
('ITM003','Paneer Butter Masala',120),
('ITM004','Dal Makhani',100),
('ITM005','Veg Biryani',150),
('ITM006','Naan',25),
('ITM007','Roti',10),
('ITM008','Samosa',15),
('ITM009','Mango Lassi',50),
('ITM010','Masala Chai',20);

#QUERY1
SELECT b.user_id, b.room_no
FROM bookings b
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = b.user_id
)order by booking_date desc limit 1;

#QUERY2
SELECT 
    bc.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM booking_commercials bc
JOIN bookings b ON bc.booking_id = b.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11 AND YEAR(b.booking_date) = 2021
GROUP BY bc.booking_id;

#QUERY3
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10 AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

#QUERY4
WITH monthly_items AS (
    SELECT 
        MONTH(bc.bill_date) AS month_no,
        bc.item_id,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), bc.item_id
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY month_no ORDER BY total_qty DESC) AS rank_high,
           RANK() OVER (PARTITION BY month_no ORDER BY total_qty ASC) AS rank_low
    FROM monthly_items
)
SELECT 'Most Ordered' AS type, month_no, item_id, total_qty
FROM ranked
WHERE rank_high = 1
UNION ALL
SELECT 'Least Ordered', month_no, item_id, total_qty
FROM ranked
WHERE rank_low = 1;

#QUERY5
WITH bill_values AS (
    SELECT 
        bc.bill_id,
        MONTH(bc.bill_date) AS month_no,
        b.user_id,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY bc.bill_id, MONTH(bc.bill_date), b.user_id
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month_no ORDER BY bill_amount DESC) AS rnk
    FROM bill_values
)
SELECT month_no, user_id, bill_id, bill_amount
FROM ranked
WHERE rnk = 2;





