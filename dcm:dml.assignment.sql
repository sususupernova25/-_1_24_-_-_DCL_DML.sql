-- ==========================================
-- PART A — DCL
-- ==========================================

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles
        WHERE rolname = 'hotel_db_admin'
    ) THEN
        CREATE ROLE hotel_db_admin;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_roles
        WHERE rolname = 'hotel_db_readonly'
    ) THEN
        CREATE ROLE hotel_db_readonly;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles
        WHERE rolname = 'db_admin_user'
    ) THEN
        CREATE USER db_admin_user
        WITH PASSWORD 'adminpass123';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_roles
        WHERE rolname = 'db_reader_user'
    ) THEN
        CREATE USER db_reader_user
        WITH PASSWORD 'readpass123';
    END IF;
END $$;

GRANT USAGE
ON SCHEMA hotel_schema
TO hotel_db_admin;

GRANT USAGE
ON SCHEMA hotel_schema
TO hotel_db_readonly;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA hotel_schema
TO hotel_db_admin;

GRANT SELECT
ON ALL TABLES IN SCHEMA hotel_schema
TO hotel_db_readonly;

-- FIX ДЛЯ sequence permission denied
GRANT USAGE, SELECT, UPDATE
ON ALL SEQUENCES IN SCHEMA hotel_schema
TO hotel_db_admin;

GRANT SELECT
ON ALL SEQUENCES IN SCHEMA hotel_schema
TO hotel_db_readonly;

GRANT hotel_db_admin TO db_admin_user;
GRANT hotel_db_readonly TO db_reader_user;

-- ==========================================
-- PART B — TRUNCATE
-- ==========================================

TRUNCATE TABLE hotel_schema.guest
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.payment
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.booking_service
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.booking
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.room
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.staff
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.customer
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.service
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.room_type
RESTART IDENTITY CASCADE;

TRUNCATE TABLE hotel_schema.hotel
RESTART IDENTITY CASCADE;

-- ==========================================
-- INSERT DATA
-- ==========================================

INSERT INTO hotel_schema.hotel
(name, address, city, country, phone, email)
VALUES
('Rixos Almaty', 'Kabanbay Batyr 85', 'Almaty', 'Kazakhstan', '+77271112233', 'almaty@rixos.com'),
('Hilton Astana', 'Sauran Street 46', 'Astana', 'Kazakhstan', '+77172223344', 'astana@hilton.com'),
('Sheraton Atyrau', 'Satpayev Street 2', 'Atyrau', 'Kazakhstan', '+77122334455', 'atyrau@sheraton.com'),
('Kazakhstan Hotel', 'Dostyk Ave 52', 'Almaty', 'Kazakhstan', '+77274445566', 'info@khotel.kz'),
('Marriott Aktau', 'District 4', 'Aktau', 'Kazakhstan', '+77292556677', 'aktau@marriott.com');

INSERT INTO hotel_schema.room_type
(type_name, price_per_night, max_capacity)
VALUES
('Standard', 25000.00, 2),
('Suite', 45000.00, 3),
('Deluxe', 35000.00, 2),
('Family', 50000.00, 4),
('Presidential', 120000.00, 5);

INSERT INTO hotel_schema.customer
(first_name, last_name, phone, email)
VALUES
('Moldir', 'Olzhabaeva', '+77053436309', 'moldir.olzh@google.kz'),
('Askar', 'Amanov', '+77015552233', 'askar.a@mail.kz'),
('Aruzhan', 'Sainova', '+77074441122', 'aru.sain@gmail.com'),
('Dmitry', 'Kim', '+77478889900', 'dima.kim@yandex.kz'),
('Elena', 'Petrova', '+77021113355', 'elena.p@ict.com');

INSERT INTO hotel_schema.service
(service_name, price, description)
VALUES
('Breakfast Buffet', 5000.00, 'Morning buffet'),
('Spa & Massage', 15000.00, 'Relax massage'),
('Laundry Service', 3000.00, 'Laundry and ironing'),
('Airport Transfer', 8000.00, 'Taxi transfer'),
('Late Check-out', 6000.00, 'Stay until evening');

INSERT INTO hotel_schema.staff
(hotel_id, first_name, last_name, position, phone)
VALUES
(1, 'Ali', 'Omarov', 'Manager', '+77001111111'),
(2, 'Dana', 'Asanova', 'Receptionist', '+77002222222'),
(3, 'Serik', 'Bolatov', 'Bellboy', '+77003333333'),
(4, 'Anna', 'Smirnova', 'Housekeeper', '+77004444444'),
(5, 'Arman', 'Isaev', 'Chef', '+77005555555');

INSERT INTO hotel_schema.room
(hotel_id, room_type_id, room_number, status)
VALUES
(1, 1, '101', 'Available'),
(2, 2, '202', 'Available'),
(3, 3, '303', 'Available'),
(4, 4, '404', 'Available'),
(5, 5, '505', 'Available');

INSERT INTO hotel_schema.booking
(customer_id, room_id, check_in_date, check_out_date, booking_status)
VALUES
(1, 1, '2026-06-01', '2026-06-05', 'Confirmed'),
(2, 2, '2026-06-10', '2026-06-12', 'Confirmed'),
(3, 3, '2026-07-01', '2026-07-05', 'Cancelled'),
(4, 4, '2026-08-15', '2026-08-20', 'Confirmed'),
(5, 5, '2026-09-01', '2026-09-03', 'Confirmed');

INSERT INTO hotel_schema.booking_service
(booking_id, service_id, quantity, service_date)
VALUES
(1, 1, 2, '2026-06-02'),
(2, 2, 1, '2026-06-11'),
(4, 3, 3, '2026-08-17'),
(5, 4, 1, '2026-09-01'),
(1, 5, 1, '2026-06-05');

INSERT INTO hotel_schema.payment
(booking_id, amount, payment_date, payment_method)
VALUES
(1, 56000.00, '2026-05-24', 'Card'),
(2, 45000.00, '2026-05-24', 'Online'),
(3, 0.00, '2026-05-24', 'Cash'),
(4, 29000.00, '2026-05-24', 'Card'),
(5, 126000.00, '2026-05-24', 'Online');

INSERT INTO hotel_schema.guest
(booking_id, first_name, last_name, passport_number, date_of_birth)
VALUES
(1, 'Moldir', 'Olzhabaeva', 'N1234567', '2005-11-20'),
(2, 'Askar', 'Amanov', 'N7654321', '1995-03-15'),
(3, 'Aruzhan', 'Sainova', 'N9876543', '2000-07-22'),
(4, 'Dmitry', 'Kim', 'N4567890', '1988-12-05'),
(5, 'Elena', 'Petrova', 'N1122334', '1992-05-10');

-- ==========================================
-- PART C — UPDATE
-- ==========================================

UPDATE hotel_schema.customer
SET phone = '+77779998877'
WHERE email = 'moldir.olzh@google.kz';

UPDATE hotel_schema.booking
SET booking_status = 'Completed'
WHERE booking_status = 'Confirmed';

UPDATE hotel_schema.room_type
SET price_per_night = price_per_night * 1.10
WHERE type_name = 'Presidential';

-- ==========================================
-- PART D — DELETE + ROLLBACK
-- ==========================================

BEGIN;

DELETE FROM hotel_schema.guest
WHERE booking_id IN (
    SELECT booking_id
    FROM hotel_schema.booking
    WHERE booking_status = 'Cancelled'
);

DELETE FROM hotel_schema.booking_service
WHERE booking_id IN (
    SELECT booking_id
    FROM hotel_schema.booking
    WHERE booking_status = 'Cancelled'
);

DELETE FROM hotel_schema.payment
WHERE booking_id IN (
    SELECT booking_id
    FROM hotel_schema.booking
    WHERE booking_status = 'Cancelled'
);

DELETE FROM hotel_schema.booking
WHERE booking_status = 'Cancelled';

ROLLBACK;