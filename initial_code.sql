CREATE DATABASE HMS;
USE HMS;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Table creation : 'BillingAndPayments'
CREATE TABLE BillingAndPayments (
    billing_id INT PRIMARY KEY AUTO_INCREMENT,      									-- Unique identifier for each bill
    patient_id INT,                                 									-- Links to the Patients table
    appointment_id INT,                             									-- Links to the Appointments table
    total_amount DECIMAL(10,2),                     									-- The total bill amount
    paid_amount DECIMAL(10,2),                      									-- The amount already paid
    payment_method ENUM('Cash', 'Card', 'Insurance', 'Online'),  			 -- Payment mode
    payment_status ENUM('Paid', 'Pending', 'Partially Paid'),     		-- Payment status
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  									
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- INSERT statements for table 'BillingAndPayments'
INSERT INTO BillingAndPayments (patient_id, appointment_id,total_amount, paid_amount, payment_method, payment_status)
VALUES 
(101, 201, 1500.00, 1500.00, 'Card', 'Paid'),
(102, 202, 2000.00, 1000.00, 'Cash', 'Partially Paid'),
(103, 203, 1200.00, 0.00, 'Online', 'Pending'),
(104, 204, 3000.00, 2000.00, 'Insurance', 'Partially Paid'),
(105, 205, 500.00, 500.00, 'Cash', 'Paid');

-- QUERIES for table 'BillingAndPayments'
-- Calculate Total Revenue
SELECT SUM(paid_amount) AS total_revenue FROM BillingAndPayments WHERE payment_status = 'Paid';
-- Get Total Outstanding Due
SELECT SUM(total_amount - paid_amount) AS total_due FROM BillingAndPayments WHERE payment_status != 'Paid';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Creates table : 'MedicineInventory'
CREATE TABLE MedicineInventory (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,        -- Unique ID for each medicine
    medicine_name VARCHAR(100) NOT NULL,               -- Name of the medicine
    batch_number VARCHAR(50) NOT NULL,                 -- Unique batch number for tracking
    manufacturer VARCHAR(100),                         -- Manufacturer of the medicine
    category ENUM('Tablet', 'Capsule', 'Syrup', 'Injection', 'Ointment'), -- Type of medicine
    quantity INT NOT NULL DEFAULT 0,                    -- Current stock level
    unit_price DECIMAL(10,2) NOT NULL,                  -- Price per unit
    expiry_date DATE,                                   -- Expiration date
    );

-- INSERT statements for table 'MedicineInventory'
INSERT INTO MedicineInventory (medicine_name, batch_number, manufacturer, category, quantity, unit_price, expiry_date)
VALUES 
('Paracetamol', 'B1', 'Sachin Pharma', 'Tablet', 500, 0.75, '2025-12-31'),
('Benadryl', 'B2', 'Viyank Pharma', 'Syrup', 200, 5.00, '2024-11-30'),
('Amoxicillin', 'B3', 'Chintan Pharma', 'Injection', 150, 15.50, '2025-06-30'),
('Volini', 'B4', 'Khushi Pharma', 'Ointment', 300, 3.25, '2026-08-15'),
('Vitamin D3', 'B5', 'Sachin Pharma', 'Capsule', 400, 1.25, '2027-01-01');

-- QUERIES for table 'MedicineInventory'
-- Retrieve All Medicines
SELECT * FROM MedicineInventory;
-- Retrieve Medicines Expiring in the Next 30 Days
SELECT * FROM MedicineInventory WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

