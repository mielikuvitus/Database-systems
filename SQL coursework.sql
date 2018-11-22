/*
Guesthouse coursework (Database systems, SET08120)


40325472 (Suvi Helin)

SECTION 1	 	Answers to questions 6,8,9,10,11
SECTION 2 		An ERD + SQL statements to modify the database


*/
/*----- SECTION 1 -----*/

/* QUESTION 1 */


SELECT booking_date,nights 
FROM booking 
WHERE guest_id = 1183


/* QUESTION 1 - RESULT
+------------------+--------+
| booking_date     | nights |
+------------------+--------+
| 2016-11-27       | 5      |
+------------------+--------+ */

/* QUESTION 2 */

SELECT arrival_time,first_name, last_name
FROM booking JOIN guest
ON guest.id=booking.guest_id
WHERE booking_date = '2016-11-05'
ORDER BY arrival_time

/* QUESTION 2 - RESULT
+--------------+------------+-----------+
| arrival_time | first_name | last_name |
+--------------+------------+-----------+
| 14:00        | Lisa       | Nandy     |
| 15:00        | Jack       | Dromey    |
| 16:00        | Mr Andrew  | Tyrie     |
| 21:00        | James      | Heappey   |
| 22:00        | Justin     | Tomlinson |
+--------------+------------+-----------+ */

/* QUESTION 3 */

SELECT booking_id,room_type_requested,occupants,amount
FROM booking JOIN rate
ON booking_id IN ('5152','5165','5154','5295')
WHERE occupants=rate.occupancy AND room_type_requested = rate.room_type

/* QUESTION 3 - RESULT
+------------+---------------------+-----------+--------+
| booking_id | room_type_requested | occupants | amount |
+------------+---------------------+-----------+--------+
|       5152 | double              |         2 |  72.00 |
|       5154 | double              |         1 |  56.00 |
|       5295 | family              |         3 |  84.00 |
+------------+---------------------+-----------+--------+ */

/* QUESTION 4 */

SELECT first_name, last_name, address
FROM booking JOIN guest
ON guest.id = guest_id
JOIN room ON room.id = room_no
WHERE booking_date = '2016-12-03'
AND room.id = 101

/* QUESTION 4 - RESULT
+------------+-----------+-------------+
| first_name | last_name | address     |
+------------+-----------+-------------+
| Graham     | Evans     | Weaver Vale |
+------------+-----------+-------------+ */

/* QUESTION 5 */

SELECT guest_id, count(booking_id) ,sum(nights) 
FROM booking JOIN guest 
ON guest_id = guest.id
WHERE guest_id in (1185, 1270) 
GROUP BY guest_id

/* QUESTION 5 - RESULT
+----------+-------------------+-------------+
| guest_id | COUNT(booking_id) | SUM(nights) |
+----------+-------------------+-------------+
|     1185 |                 3 |           8 |
|     1270 |                 2 |           3 |
+----------+-------------------+-------------+ */

/* QUESTION 6 */

SELECT SUM(nights * amount) 
FROM rate JOIN booking 
ON (rate.room_type = booking.room_type_requested 
AND rate.occupancy = booking.occupants)
JOIN guest ON guest.id = booking.guest_id
WHERE last_name = 'Cadbury' AND first_name = 'Ruth'

/* QUESTION 6 - RESULT
+--------------------+
| SUM(nights*amount) |
+--------------------+
|             552.00 |
+--------------------+*/

/* QUESTION 7 */

SELECT SUM(ROUND(rate.amount/2,2) + extra.amount) AS 'SUM(amount)'
FROM booking JOIN rate 
ON (rate.room_type = booking.room_type_requested 
AND rate.occupancy = booking.occupants)
JOIN extra ON booking.booking_id = extra.booking_id
WHERE booking.booking_id = 5346

/* QUESTION 7 - RESULT
+-------------+
| SUM(amount) |
+-------------+
|      118.56 |
+-------------+*/

/* QUESTION 8 */

SELECT last_name, first_name, address, nights
FROM guest LEFT JOIN booking ON guest.id = booking.guest_id
WHERE address LIKE ('Edinburgh%')
ORDER BY last_name, first_name

/* QUESTION 8 - RESULT
+-----------+------------+---------------------------+--------+
| last_name | first_name | address                   | nights |
+-----------+------------+---------------------------+--------+
| Brock     | Deidre     | Edinburgh North and Leith |      0 |
| Cherry    | Joanna     | Edinburgh South West      |      0 |
| Murray    | Ian        | Edinburgh South           |     	7 |
| Murray    | Ian        | Edinburgh South           |      6 | HOW DO I GROUP THIS GUY??
| Sheppard  | Tommy      | Edinburgh East            |      0 |
| Thomson   | Michelle   | Edinburgh West            |      3 |
+-----------+------------+---------------------------+--------+*/

/* QUESTION 9 */

SELECT booking_date, COUNT(booking_id) AS arrivals
  FROM booking 
  WHERE booking_date BETWEEN '2016-11-25' AND '2016-12-01' 
  GROUP BY booking_date

  /* QUESTION 9 - RESULT
+---------------+----------+
| booking_date  | arrivals |
+---------------+----------+
| 2016-11-25    |        7 |
| 2016-11-26    |        8 |
| 2016-11-27    |       12 |
| 2016-11-28    |        7 |
| 2016-11-29    |       13 |
| 2016-11-30    |        6 |
| 2016-12-01    |        7 |
+---------------+----------+*/

/* QUESTION 10 */

SELECT SUM(occupants)
FROM booking JOIN guest
ON guest.id=booking.guest_id 
WHERE booking_date = '2016.11.16' AND nights >6
OR booking_date ='2016.11.17' AND nights >=5
OR booking_date ='2016.11.18' AND nights >=4
OR booking_date ='2016.11.19' AND nights >=3
OR booking_date ='2016.11.20' AND nights >=2
OR booking_date ='2016.11.21' AND nights >=1

  /* QUESTION 10 - RESULT
+----------------+
| SUM(occupants) |
+----------------+
|             39 |
+----------------+*/

/* QUESTION 11 */

SELECT last_name,max(first_name) as 'first_name'
     , min(first_name) as 'first_name'
FROM guest JOIN booking ON booking.guest_id=guest.id 
WHERE arrival_time BETWEEN '12:00' AND '18:00' AND nights > 1
GROUP BY last_name
HAVING COUNT(last_name) > 1 AND max(first_name) <> min(first_name)

  /* QUESTION 11 - RESULT
+------------+------------+-------------+
| last_name  | first_name | first_name  |
+------------+------------+-------------+
| Carmichael | Neil		  | Mr Alistar  |
| Davies     | Philip     | David T. C. |
| Evans      | Graham     | Mr Nigel    |
| Howarth    | Mr George  | Sir Gerald  |
| Jones      | Susan Elan | Mr Marcus   |
| Lewis      | Clive      | Dr Julian   |
| McDonnell  | John       | Dr Alasdair |
+------------+------------+-------------+*/

/*----- SECTION 2 -----*/

DROP TABLE payment;
DROP TABLE payment_type;

  /* Creating table for payments and inserting values */
CREATE table payment(
  booking_id int NOT NULL,
  payment_id int NOT NULL,
  amount decimal(10,2) NOT NULL,
  payment_type int(1) NOT NULL DEFAULT '3', 
  payment_date date DEFAULT NULL,
  PRIMARY KEY (payment_id),
  INDEX booking_id_IDX (booking_id),
  INDEX payment_type_IDX (payment_type),
  CONSTRAINT payment_fk_1 FOREIGN KEY (booking_id) REFERENCES booking_id(booking),
  CONSTRAINT payment_fk_2 FOREIGN KEY (payment_type) REFERENCES id(payment_type)
);
INSERT INTO payment VALUES (5360, 0001, 216.00, 2, '2016-12-11');
INSERT INTO payment VALUES (5359, 0002, 288.00, 4, '2016-11-20');
INSERT INTO payment VALUES (5359, 0003, 49.06, 3, '2016-11-28');
INSERT INTO payment VALUES (5012, 0004, 283.93, 4, '2016-11-30');

 
/* Creating table for payment types and inserting values */
CREATE table payment_type(
  id int NOT NULL,
  creditcard int(1) NULL,
  debitcard int(1) NULL,
  cash int(1) NULL,
  bank_transfer int(1) NULL,  
  PRIMARY KEY (id)
);
INSERT INTO payment_type VALUES (0000, 1, 2, 3, 4);


