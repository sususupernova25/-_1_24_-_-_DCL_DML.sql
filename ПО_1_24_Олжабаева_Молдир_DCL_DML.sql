-- TASK 1

GRANT USAGE ON SCHEMA hotel_schema TO student_role;

GRANT SELECT ON hotel_schema.booking TO student_role;

GRANT student_role TO student1;

-- TASK 2

SELECT *
FROM hotel_schema.room
WHERE room_type_id = 1;

UPDATE hotel_schema.room
SET status = 'Occupied'
WHERE room_type_id = 1;

-- TASK 3

INSERT INTO hotel_schema.customer
(first_name, last_name, phone, email)

VALUES
('Moldir', 'Olzhabaeva', '+77053436309', 'moldirolzhabaeva')

RETURNING *;


-- TASK 4

SELECT *
FROM hotel_schema.payment
WHERE amount = 0.00;

DELETE FROM hotel_schema.payment
WHERE amount = 0.00;