-- Drop and create the database
DROP DATABASE IF EXISTS HMS;
CREATE DATABASE IF NOT EXISTS HMS;
USE HMS;

-- CHINTAN' WORK
-- Creating Patient Table
CREATE TABLE Patient(
    email VARCHAR(50) PRIMARY KEY,                     -- Unique identifier for each patient
    password VARCHAR(30) NOT NULL,                     -- Encrypted password for authentication
    name VARCHAR(50) NOT NULL,                         -- Patient's full name
    address VARCHAR(60) NOT NULL,                      -- Residential address
    gender ENUM('Male', 'Female', 'Other') NOT NULL    -- Gender selection
);

-- Creating MedicalHistory Table
CREATE TABLE MedicalHistory(
    id INT PRIMARY KEY AUTO_INCREMENT,                 -- Unique auto-incremented medical history ID
    date DATE NOT NULL,                                -- Date of medical history record
    conditions VARCHAR(255) NOT NULL,                  -- Patient's existing conditions
    surgeries VARCHAR(255) NOT NULL,                   -- Past surgeries
    medication VARCHAR(255) NOT NULL                   -- Ongoing medications
);

-- Creating Doctor Table
CREATE TABLE Doctor(
    email VARCHAR(50) PRIMARY KEY,                     -- Unique identifier for each doctor
    password VARCHAR(30) NOT NULL,                     -- Encrypted password for authentication
    name VARCHAR(50) NOT NULL,                         -- Doctor's full name
    gender ENUM('Male', 'Female', 'Other') NOT NULL    -- Gender selection
);

-- Creating Appointment Table
CREATE TABLE Appointment(
    id INT PRIMARY KEY AUTO_INCREMENT,                 -- Unique auto-incremented appointment ID
    date DATE NOT NULL,                                -- Date of appointment
    starttime TIME NOT NULL,                           -- Start time of appointment
    endtime TIME NOT NULL,                             -- End time of appointment
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled' -- Appointment status
);

-- KHUSHI'S WORK
-- Creating PatientsAttendAppointments Table (Junction Table)
CREATE TABLE PatientsAttendAppointments(
    patient VARCHAR(50) NOT NULL,                      -- Patient's email (foreign key)
    appt INT NOT NULL,                                 -- Appointment ID (foreign key)
    concerns VARCHAR(255) NOT NULL,                    -- Patient concerns
    symptoms VARCHAR(255) NOT NULL,                    -- Symptoms reported by patient
    FOREIGN KEY (patient) REFERENCES Patient (email) ON DELETE CASCADE,
    FOREIGN KEY (appt) REFERENCES Appointment (id) ON DELETE CASCADE,
    PRIMARY KEY (patient, appt)
);

-- Creating RoomsAndWards Table
CREATE TABLE RoomsAndWards (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,            -- Unique room ID
    RoomType ENUM('General', 'ICU', 'Private') NOT NULL,  -- Room classification
    AvailabilityStatus ENUM('Available', 'Occupied') DEFAULT 'Available',  -- Availability status
    AssignedPatientID VARCHAR(50),                    -- Assigned patient (foreign key)
    FOREIGN KEY (AssignedPatientID) REFERENCES Patient(email) ON DELETE SET NULL
);

-- Creating Diagnose Table
CREATE TABLE Diagnose(
    appt INT NOT NULL,                                 -- Appointment ID (foreign key)
    doctor VARCHAR(50) NOT NULL,                       -- Doctor's email (foreign key)
    diagnosis VARCHAR(255) NOT NULL,                   -- Diagnosis description
    prescription VARCHAR(255) NOT NULL,                -- Prescribed medication or treatment
    FOREIGN KEY (appt) REFERENCES Appointment (id) ON DELETE CASCADE,
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    PRIMARY KEY (appt, doctor)
);

-- Creating SupportStaff Table
CREATE TABLE SupportStaff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,          -- Unique staff ID
    Name VARCHAR(255) NOT NULL,                       -- Staff name
    Role ENUM('Nurse', 'Technician', 'Admin', 'Janitor') NOT NULL,   -- Staff role
    Department VARCHAR(100),                          -- Department assigned
    Shift ENUM('Morning', 'Evening', 'Night')        -- Work shift
);

-- SACHIN'S WORK
-- Creating Emergency Table
CREATE TABLE Emergency (
    EmergencyID INT PRIMARY KEY AUTO_INCREMENT,        -- Unique emergency case ID
    PatientID VARCHAR(50) NOT NULL,                    -- Patient ID (foreign key)
    PatientCondition TEXT NOT NULL,                    -- Emergency condition details
    DoctorID VARCHAR(50) NOT NULL,                     -- Attending doctor ID (foreign key)
    ArrivalTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Arrival timestamp
    FOREIGN KEY (PatientID) REFERENCES Patient(email) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(email) ON DELETE CASCADE
);

-- Creating Insurance Table
CREATE TABLE Insurance (
    InsuranceID INT PRIMARY KEY AUTO_INCREMENT,        -- Unique identifier for each insurance record
    PatientID VARCHAR(50) NOT NULL,                    -- Patient ID linked to the insurance
    ProviderName VARCHAR(255) NOT NULL,                -- Insurance provider name
    PolicyNumber VARCHAR(50) UNIQUE NOT NULL,          -- Unique policy number
    FOREIGN KEY (PatientID) REFERENCES Patient(email)
);

-- Creating Schedule Table
CREATE TABLE Schedule(
    id INT PRIMARY KEY AUTO_INCREMENT,                 -- Unique schedule ID
    starttime TIME NOT NULL,                           -- Shift start time
    endtime TIME NOT NULL,                             -- Shift end time
    breaktime TIME NOT NULL,                           -- Break period
    day ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL -- Workday
);

-- Creating DoctorViewsHistory Table (Junction Table)
CREATE TABLE DoctorViewsHistory(
    history INT NOT NULL,                              -- Medical history ID (foreign key)
    doctor VARCHAR(50) NOT NULL,                       -- Doctor's email (foreign key)
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    FOREIGN KEY (history) REFERENCES MedicalHistory (id) ON DELETE CASCADE,
    PRIMARY KEY (history, doctor)
);

-- VIYANK'S WORK
-- Creating BillingAndPayments Table
CREATE TABLE BillingAndPayments (
    billing_id INT PRIMARY KEY AUTO_INCREMENT,      -- Unique billing ID
    patient_id VARCHAR(50) NOT NULL,                -- Patient ID (foreign key)
    appointment_id INT NOT NULL,                    -- Appointment ID (foreign key)
    total_amount DECIMAL(10,2) NOT NULL,            -- Total bill amount
    paid_amount DECIMAL(10,2) DEFAULT 0.00,         -- Amount paid
    payment_method ENUM('Cash', 'Card', 'Insurance', 'Online') NOT NULL,  -- Payment method
    payment_status ENUM('Paid', 'Pending', 'Partially Paid') DEFAULT 'Pending',  -- Payment status
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Payment date and time
    FOREIGN KEY (patient_id) REFERENCES Patient(email) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(id) ON DELETE CASCADE
);

-- Creating DocsHaveSchedules Table (Junction Table)
CREATE TABLE DocsHaveSchedules(
    sched INT NOT NULL,                                -- Schedule ID (foreign key)
    doctor VARCHAR(50) NOT NULL,                       -- Doctor's email (foreign key)
    FOREIGN KEY (sched) REFERENCES Schedule (id) ON DELETE CASCADE,
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    PRIMARY KEY (sched, doctor)
);

-- Creating MedicineInventory Table
CREATE TABLE MedicineInventory (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,        -- Unique medicine ID
    medicine_name VARCHAR(100) NOT NULL,               -- Medicine name
    batch_number VARCHAR(50) UNIQUE NOT NULL,          -- Unique batch number
    manufacturer VARCHAR(100),                         -- Manufacturer name
    category ENUM('Tablet', 'Capsule', 'Syrup', 'Injection', 'Ointment') NOT NULL,  -- Medicine type
    quantity INT NOT NULL DEFAULT 0,                   -- Available quantity
    unit_price DECIMAL(10,2) NOT NULL,                 -- Price per unit
    expiry_date DATE                                   -- Expiry date
);

-- Creating PatientsFillHistory Table (Junction Table)
CREATE TABLE PatientsFillHistory(
    patient VARCHAR(50) NOT NULL,                      -- Patient's email (foreign key)
    history INT NOT NULL,                              -- Medical history ID (foreign key)
    FOREIGN KEY (patient) REFERENCES Patient (email) ON DELETE CASCADE,
    FOREIGN KEY (history) REFERENCES MedicalHistory (id) ON DELETE CASCADE,
    PRIMARY KEY (patient, history)                     -- Composite primary key
);

-- STORED PROCEDURES -----------------------------------------

-- CHINTAN' WORK
-- PROCEDURE 1: Schedule an Appointment
-- USE CASE: Book an appointment for a patient with a doctor.
-- Example: CALL ScheduleAppointment('john.doe@example.com', 'doc@example.com', '2025-04-01', '10:00:00', '10:30:00', 'Scheduled');
DELIMITER //
CREATE PROCEDURE ScheduleAppointment(
    IN p_patient VARCHAR(50),
    IN p_doctor VARCHAR(50),
    IN p_date DATE,
    IN p_starttime TIME,
    IN p_endtime TIME,
    IN p_status VARCHAR(15)
)
BEGIN
    DECLARE appt_id INT;
    
    INSERT INTO Appointment (date, starttime, endtime, status)
    VALUES (p_date, p_starttime, p_endtime, p_status);
    
    SET appt_id = LAST_INSERT_ID();
    
    INSERT INTO PatientsAttendAppointments (patient, appt, concerns, symptoms)
    VALUES (p_patient, appt_id, '', '');
END //
DELIMITER ;

-- PROCEDURE 2: Process Payment
-- USE CASE: Update a patient's billing record after a payment.
-- Example: CALL ProcessPayment('john.doe@example.com', 101, 50.00, 'Card');
DELIMITER //

CREATE PROCEDURE ProcessPayment(
    IN p_patient_id VARCHAR(50),
    IN p_appointment_id INT,
    IN p_paid_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(20)  -- <<< Fixed: VARCHAR instead of ENUM
)
BEGIN
    UPDATE BillingAndPayments
    SET paid_amount = paid_amount + p_paid_amount,
        payment_status = CASE
            WHEN paid_amount + p_paid_amount >= total_amount THEN 'Paid'
            WHEN paid_amount + p_paid_amount > 0 THEN 'Partially Paid'
            ELSE 'Pending'
        END,
        payment_date = NOW()
    WHERE patient_id = p_patient_id AND appointment_id = p_appointment_id;
END //

DELIMITER ;

-- KHUSHI'S WORK
-- PROCEDURE 3: Generate a billing statement for a given appointment, including patient details, appointment information, diagnosis, prescription, and a placeholder for billing details.
DELIMITER //

CREATE PROCEDURE GenerateBillingStatement(
    IN p_appointment_id INT
)
BEGIN
    -- Check if the appointment exists
    IF NOT EXISTS (SELECT 1 FROM Appointment WHERE id = p_appointment_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Appointment not found.';
    END IF;

    -- Retrieve patient information, appointment details, diagnosis, and prescribed medicines
    SELECT
        p.name AS PatientName,
        p.email AS PatientEmail,
        a.date AS AppointmentDate,
        a.starttime AS AppointmentStartTime,
        d.diagnosis AS Diagnosis,
        d.prescription AS Prescription
    FROM Patient p
    JOIN PatientsAttendAppointments paa ON p.email = paa.patient
    JOIN Appointment a ON paa.appt = a.id
    LEFT JOIN Diagnose d ON a.id = d.appt
    WHERE a.id = p_appointment_id;

    -- Display billing details
    SELECT 
        'Consultation Fee' AS Item, 50.00 AS Amount
    UNION ALL
    SELECT 
        'Medication Cost (if applicable)', 0.00
    UNION ALL
    SELECT 
        '--- END OF STATEMENT ---', NULL;

END //

DELIMITER ;

-- PROCEDURE 4: Transfers a patient from their current room to a new room, updating the RoomsAndWards table accordingly

DELIMITER //
CREATE PROCEDURE TransferPatientRoom(
    IN p_patient_email VARCHAR(50),
    IN p_new_room_id INT
)
BEGIN
    DECLARE current_room_id INT;

    -- Start a transaction
    START TRANSACTION;

    -- Check if the patient exists
    IF NOT EXISTS (SELECT 1 FROM Patient WHERE email = p_patient_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient not found.';
    END IF;

    -- Check if the new room exists and is available
    IF NOT EXISTS (SELECT 1 FROM RoomsAndWards WHERE RoomID = p_new_room_id AND AvailabilityStatus = 'Available') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'New room not found or is occupied.';
    END IF;

    -- Get the patient's current room
    SELECT RoomID INTO current_room_id
    FROM RoomsAndWards
    WHERE AssignedPatientID = p_patient_email;

    -- Update the new room to be occupied by the patient
    UPDATE RoomsAndWards
    SET AvailabilityStatus = 'Occupied', AssignedPatientID = p_patient_email
    WHERE RoomID = p_new_room_id;

    -- If the patient was in a room before, mark that room as available
    IF current_room_id IS NOT NULL THEN
        UPDATE RoomsAndWards
        SET AvailabilityStatus = 'Available', AssignedPatientID = NULL
        WHERE RoomID = current_room_id;
    END IF;

    -- Commit the transaction
    COMMIT;

    SELECT 'Patient transferred successfully to Room ID: ' AS Message, p_new_room_id AS NewRoom;

END //
DELIMITER ;

-- SACHIN'S WORK
-- Procedure 5: AdmitEmergencyPatient
-- Purpose: Handles the admission workflow of an emergency patient, assigning a doctor, logging the emergency, and allocating an available ICU room.
-- Use Case: Used by the emergency intake system to manage urgent admissions efficiently in one transaction.

DELIMITER //

CREATE PROCEDURE AdmitEmergencyPatient(
    IN patient_email VARCHAR(50),
    IN condition_text TEXT,
    IN doctor_email VARCHAR(50)
)
BEGIN
    DECLARE room_id INT;

    -- Step 1: Log Emergency
    INSERT INTO Emergency (PatientID, PatientCondition, DoctorID)
    VALUES (patient_email, condition_text, doctor_email);

    -- Step 2: Find Available ICU Room
    SELECT RoomID INTO room_id
    FROM RoomsAndWards
    WHERE RoomType = 'ICU' AND AvailabilityStatus = 'Available'
    LIMIT 1;

    -- Step 3: Assign Room (if available)
    IF room_id IS NOT NULL THEN
        UPDATE RoomsAndWards
        SET AvailabilityStatus = 'Occupied',
            AssignedPatientID = patient_email
        WHERE RoomID = room_id;
    END IF;
END //

DELIMITER ;


-- Procedure 6: UpdateOrCreateInsuranceRecord
-- Purpose: Validates if the insurance record exists for a patient. If yes → update, if not → create.
-- Use Case: Robust insurance record management across billing, registration, or policy update systems.

DELIMITER //

CREATE PROCEDURE UpdateOrCreateInsuranceRecord(
    IN patient_email VARCHAR(50),
    IN provider_name VARCHAR(255),
    IN policy_no VARCHAR(50)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Insurance WHERE PatientID = patient_email
    ) THEN
        UPDATE Insurance
        SET ProviderName = provider_name,
            PolicyNumber = policy_no
        WHERE PatientID = patient_email;
    ELSE
        INSERT INTO Insurance (PatientID, ProviderName, PolicyNumber)
        VALUES (patient_email, provider_name, policy_no);
    END IF;
END //

DELIMITER ;

-- VIYANK'S WORK
-- PROCEDURE 7: GenerateFinalBill
-- Purpose: Calculates final bill for a given patient by summing up unpaid charges and applying insurance if applicable.
-- Input:  patient_email VARCHAR(50): Email ID of the patient whose final bill is to be generated.
-- Output: Prints total outstanding payment by the patient after considering insurance coverage.

DELIMITER //

CREATE PROCEDURE GenerateFinalBill(IN patient_email VARCHAR(50))
BEGIN
    DECLARE unpaid_total DECIMAL(10,2) DEFAULT 0;
    DECLARE has_insurance INT DEFAULT 0;

    -- Step 1: Calculate total unpaid amount for the patient
    SELECT IFNULL(SUM(total_amount - paid_amount), 0)
    INTO unpaid_total
    FROM BillingAndPayments
    WHERE patient_id = patient_email AND payment_status != 'Paid';

    -- Step 2: Check if the patient has an insurance record
    SELECT COUNT(*)
    INTO has_insurance
    FROM Insurance
    WHERE PatientID = patient_email;

    -- Step 3: Apply a 20% discount if insurance exists
    IF has_insurance > 0 THEN
        SET unpaid_total = unpaid_total * 0.8; -- Apply 20% discount
    END IF;

    -- Step 4: Return the final amount
    SELECT unpaid_total AS Final_Amount_To_Pay;
END //

DELIMITER ;

-- PROCEDURE 8: DischargePatient
-- Purpose: Handles full discharge of a patient, finalizes billing, frees assigned room.
-- Input: patient_email VARCHAR(50): Email ID of the patient to be discharged.
-- Output: Updates payment status and room assignment.

DELIMITER //

CREATE PROCEDURE DischargePatient(IN patient_email VARCHAR(50))
BEGIN
    -- Start a transaction (optional but professional)
    START TRANSACTION;
    
    -- Step 1: Mark all unpaid bills as Paid
    UPDATE BillingAndPayments
    SET payment_status = 'Paid',
        paid_amount = total_amount
    WHERE patient_id = patient_email AND payment_status != 'Paid';
    
    -- Step 2: Set patient's assigned room as available
    UPDATE RoomsAndWards
    SET AvailabilityStatus = 'Available',
        AssignedPatientID = NULL
    WHERE AssignedPatientID = patient_email;
    
    -- Commit the transaction
    COMMIT;
    
    -- Step 3: Display a message (optional but great for feedback)
    SELECT CONCAT('Patient with email ', patient_email, ' has been successfully discharged.') AS Message;
END //

DELIMITER ;


-- FUNCTIONS:- ---------------------------------------------

-- CHINTAN' WORK
-- FUNCTION 1: Get Available Doctor Schedule
-- USE CASE: Fetch a doctor's availability on a given day.
-- Example: SELECT GetDoctorAvailability('doctor@example.com', 'Monday');
DELIMITER //
CREATE FUNCTION GetDoctorAvailability(doc_email VARCHAR(50), day_name ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE schedule_info VARCHAR(100);
    
    SELECT CONCAT(starttime, ' - ', endtime) INTO schedule_info
    FROM Schedule
    INNER JOIN DocsHaveSchedules ON Schedule.id = DocsHaveSchedules.sched
    WHERE DocsHaveSchedules.doctor = doc_email AND Schedule.day = day_name;
    
    RETURN IFNULL(schedule_info, 'No schedule available');
END //
DELIMITER ;

-- FUNCTION 2: Get Medicine Stock Level
-- USE CASE: Fetch the current available quantity of a specific medicine from the inventory.
-- Example: SELECT GetMedicineStockLevel('Paracetamol');
DELIMITER //

CREATE FUNCTION GetMedicineStockLevel(p_medicine_name VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock_level INT;
    
    SELECT quantity INTO stock_level
    FROM MedicineInventory
    WHERE medicine_name = p_medicine_name
    LIMIT 1; -- Ensures only one record is fetched
    
    RETURN IFNULL(stock_level, 0); -- If not found, return 0
END //

DELIMITER ;

-- KHUSHI'S WORK
-- FUNCTION 3: Function to calculate Outstanding Balance
DELIMITER //
CREATE FUNCTION CalculateBalance(p_patient_email VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_due DECIMAL(10,2);
    DECLARE total_paid DECIMAL(10,2);

    SELECT COALESCE(SUM(total_amount), 0), COALESCE(SUM(paid_amount), 0)
    INTO total_due, total_paid
    FROM BillingAndPayments
    WHERE patient_id = p_patient_email;

    RETURN total_due - total_paid;
END //
DELIMITER ;

-- FUNCTION 4: Function to calculate the total cost of medicines prescribed to a patient during a specific appointment 

DELIMITER //
CREATE FUNCTION CalculatePrescribedMedicineCost(
    p_patient_email VARCHAR(50),
    p_appointment_id INT
) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_medicine_cost DECIMAL(10, 2);

    -- Initialize the total cost
    SET total_medicine_cost = 0.00;

    -- Select the patient's prescription from the Diagnose table for the given appointment
    SELECT
        GROUP_CONCAT(prescription) INTO @prescriptions
    FROM
        Diagnose
    WHERE
        appt = p_appointment_id;

    -- Check if there are any prescriptions
    IF @prescriptions IS NOT NULL THEN
        -- Split the prescription string into individual medicines (assuming they are comma-separated)
        SET @prescription_count = LENGTH(@prescriptions) - LENGTH(REPLACE(@prescriptions, ',', '')) + 1;
        SET @i = 1;

        WHILE @i <= @prescription_count DO
            -- Extract each medicine name
            SET @medicine_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(@prescriptions, ',', @i), ',', -1));

            -- Get the unit price of the medicine from the MedicineInventory table
            SELECT
                unit_price INTO @medicine_price
            FROM
                MedicineInventory
            WHERE
                medicine_name = @medicine_name;

            -- If the medicine is found in the inventory, add its price to the total cost
            IF @medicine_price IS NOT NULL THEN
                SET total_medicine_cost = total_medicine_cost + @medicine_price;
            END IF;

            SET @i = @i + 1;
        END WHILE;
    END IF;

    -- Return the total cost of the prescribed medicines
    RETURN total_medicine_cost;
END //
DELIMITER ;

-- SACHIN'S WORK

-- Function 5: GetPatientEmergencyVisitCount
-- Purpose: Returns how many times a patient has been to the Emergency Room.
-- Use Case: Helps flag frequent visitors, potentially for case management or alerts.

DELIMITER //

CREATE FUNCTION GetPatientEmergencyVisitCount(p_email VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE visit_count INT;

    SELECT COUNT(*) INTO visit_count
    FROM Emergency
    WHERE PatientID = p_email;

    RETURN visit_count;
END //

DELIMITER ;

-- Function 6: IsInsuranceValid
-- Purpose: Returns 'Yes' if a patient has valid insurance; 'No' otherwise.
-- Use Case: Useful inside conditions for billing workflows or eligibility checks.

DELIMITER //

CREATE FUNCTION IsInsuranceValid(p_email VARCHAR(50))
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    DECLARE has_insurance INT;

    SELECT COUNT(*) INTO has_insurance
    FROM Insurance
    WHERE PatientID = p_email;

    RETURN IF(has_insurance > 0, 'Yes', 'No');
END //

DELIMITER ;

-- VIYANK'S WORK

-- Function 7: Calculate percentage of scheduled time used in appointments.
-- It calculates the percentage of a doctor’s scheduled time that is actually used for patient appointments. By comparing total scheduled time and actual appointment time, this function can help in optimizing schedules.
-- Input: doctor_email (VARCHAR)
-- Output: DECIMAL(5,2) - Utilization percentage

CREATE FUNCTION GetDoctorUtilization(doctor_email VARCHAR(50))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    -- Declare variables to store total scheduled and appointment minutes
    DECLARE total_schedule_minutes INT;
    DECLARE total_appointment_minutes INT;

    -- Sum total minutes from schedule shifts assigned to the doctor
    SELECT SUM(TIMESTAMPDIFF(MINUTE, starttime, endtime))
    INTO total_schedule_minutes
    FROM Schedule
    JOIN DocsHaveSchedules ON Schedule.id = DocsHaveSchedules.sched
    WHERE DocsHaveSchedules.doctor = doctor_email;

    -- Sum total minutes from appointments where doctor was involved
    SELECT SUM(TIMESTAMPDIFF(MINUTE, starttime, endtime))
    INTO total_appointment_minutes
    FROM Appointment
    JOIN Diagnose ON Appointment.id = Diagnose.appt
    WHERE Diagnose.doctor = doctor_email;

    -- Calculate and return utilization percentage
    RETURN IFNULL((total_appointment_minutes / total_schedule_minutes) * 100, 0);
END;

-- Function 8: Calculate total unpaid amount for a patient.
-- Input: patient_email (VARCHAR)
-- Output: DECIMAL(10,2) - Total outstanding balance

CREATE FUNCTION CalculateOutstandingBalance(patient_email VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    -- Declare a variable to store the total unpaid amount
    DECLARE total_unpaid DECIMAL(10,2);

    -- Calculate the sum of (total_amount - paid_amount) for all unpaid or partially paid bills of the patient
    SELECT SUM(total_amount - paid_amount)
    INTO total_unpaid
    FROM BillingAndPayments
    WHERE patient_id = patient_email AND payment_status != 'Paid';

    -- Return the unpaid amount, or 0 if null
    RETURN IFNULL(total_unpaid, 0);
END;

-- TRIGGERS:- ----------------------------------

-- CHINTAN' WORK

-- Trigger 1:
/*
RoomsAndWards table with:
	•	RoomID
	•	AvailabilityStatus
	•	AssignedPatientID

Trigger to:
	•	Set AvailabilityStatus to ‘Occupied’ when AssignedPatientID is updated (i.e., a patient is assigned).
	•	Set AvailabilityStatus to ‘Available’ when AssignedPatientID is set to NULL (i.e., patient discharged).
*/

DELIMITER //

CREATE TRIGGER trg_UpdateRoomAvailability
BEFORE UPDATE ON RoomsAndWards
FOR EACH ROW
BEGIN
    -- When a patient is assigned to a room
    IF NEW.AssignedPatientID IS NOT NULL AND OLD.AssignedPatientID IS NULL THEN
        SET NEW.AvailabilityStatus = 'Occupied';
    
    -- When a patient is discharged from a room
    ELSEIF NEW.AssignedPatientID IS NULL AND OLD.AssignedPatientID IS NOT NULL THEN
        SET NEW.AvailabilityStatus = 'Available';
    END IF;
END;
//

DELIMITER ;

-- Trigger 2:
/*
Appointment table with:
    • id
    • date
    • status

Trigger to:
    • Set status to 'Completed' when the appointment date is in the past
    • Only if the current status is 'Scheduled' to avoid overwriting manually updated statuses
*/

DELIMITER //

CREATE TRIGGER trg_AutoCompleteAppointments
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
    -- Check if the appointment is in the past and still scheduled
    IF NEW.date < CURDATE() AND NEW.status = 'Scheduled' THEN
        SET NEW.status = 'Completed';
    END IF;
END;
//

DELIMITER ;

-- KHUSHI'S WORK

-- Trigger 3: Trigger to prevent the quantity of a medicine from being reduced if it has expired.
   
   DELIMITER //
   CREATE TRIGGER PreventExpiredMedicineDispensing
   BEFORE UPDATE ON MedicineInventory
   FOR EACH ROW
   BEGIN
       IF NEW.quantity < OLD.quantity AND NEW.expiry_date < CURDATE() THEN
           SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Cannot dispense expired medicine.';
       END IF;
   END //
   DELIMITER ;
       
-- Trigger 4: Trigger to automatically update the payment_status in the BillingAndPayments table.

DELIMITER //
   CREATE TRIGGER UpdatePaymentStatus
   AFTER UPDATE ON BillingAndPayments
   FOR EACH ROW
   BEGIN
       IF NEW.paid_amount >= NEW.total_amount THEN
           UPDATE BillingAndPayments
           SET
               payment_status = 'Paid'
           WHERE
               billing_id = NEW.billing_id;
       ELSEIF NEW.paid_amount > 0 AND NEW.paid_amount < NEW.total_amount THEN
           UPDATE BillingAndPayments
           SET
               payment_status = 'Partially Paid'
           WHERE
               billing_id = NEW.billing_id;
       ELSE
           UPDATE BillingAndPayments
           SET
               payment_status = 'Pending'
           WHERE
               billing_id = NEW.billing_id;
       END IF;
   END //
   DELIMITER ;

-- SACHIN'S WORK

-- Trigger 5: after_emergency_insert_log_returning_patient
-- Purpose: Automatically logs a note in a new table called EmergencyVisitLog when a patient visits the emergency room more than once.
-- Why it matters: Hospitals often track repeat ER visitors for follow-up care or case management.

-- First create the log table
CREATE TABLE IF NOT EXISTS EmergencyVisitLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID VARCHAR(50),
    VisitCount INT,
    Note TEXT,
    LoggedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Now the trigger
DELIMITER //

CREATE TRIGGER after_emergency_insert_log_returning_patient
AFTER INSERT ON Emergency
FOR EACH ROW
BEGIN
    DECLARE count_visits INT;

    SELECT COUNT(*) INTO count_visits
    FROM Emergency
    WHERE PatientID = NEW.PatientID;

    IF count_visits > 1 THEN
        INSERT INTO EmergencyVisitLog (PatientID, VisitCount, Note)
        VALUES (
            NEW.PatientID,
            count_visits,
            CONCAT('Patient has visited emergency room ', count_visits, ' times.')
        );
    END IF;
END //

DELIMITER ;

-- Trigger 6: after_schedule_delete_cleanup_access
-- Purpose: When a doctor’s schedule is removed, this trigger revokes their access to patient histories.
-- Why it matters: Ensures access control and maintains patient confidentiality.

DELIMITER //

CREATE TRIGGER after_schedule_delete_cleanup_access
AFTER DELETE ON DocsHaveSchedules
FOR EACH ROW
BEGIN
    DELETE FROM DoctorViewsHistory
    WHERE doctor = OLD.doctor;
END //

DELIMITER ;

-- VIYANK'S WORK

-- Trigger 7:
-- 1 BeforeInsert_BillingValidation
-- Purpose: Prevent inserting billing records where paid_amount exceeds total_amount.
-- Timing: BEFORE INSERT
-- Table: BillingAndPayments

-- Trigger to ensure no overpayment occurs in BillingAndPayments
DELIMITER $$

CREATE TRIGGER BeforeInsert_BillingValidation
BEFORE INSERT ON BillingAndPayments
FOR EACH ROW
BEGIN
  -- Check if paid amount is more than total amount
  IF NEW.paid_amount > NEW.total_amount THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Paid amount cannot exceed total amount.';
  END IF;
END$$

DELIMITER ;

--  Trigger 8: AfterUpdate_PaymentCompletedLog
-- Purpose: Log when a payment status changes to 'Paid'.
-- Timing: AFTER UPDATE
-- Table: BillingAndPayments


-- Trigger to log status changes to Paid
DELIMITER $$

CREATE TRIGGER AfterUpdate_PaymentCompletedLog
AFTER UPDATE ON BillingAndPayments
FOR EACH ROW
BEGIN
  -- Check if the status changed to Paid from something else
  IF NEW.payment_status = 'Paid' AND OLD.payment_status <> 'Paid' THEN
    INSERT INTO PaymentLogs (billing_id, change_time, note)
    VALUES (NEW.billing_id, NOW(), 'Payment marked as Paid.');
  END IF;
END$$

DELIMITER ;


-- DATA INSERTION: ---------------------
-- Inserting Data into Patient Table
INSERT INTO Patient (email, password, name, address, gender)
VALUES
('john.doe@example.com', 'password123', 'John Doe', '123 Main St, Cityville', 'Male'),
('jane.smith@example.com', 'securepass', 'Jane Smith', '456 Elm St, Townsville', 'Female'),
('alice.jones@example.com', 'alice123', 'Alice Jones', '789 Oak St, Villageville', 'Female'),
('michael.brown@example.com', 'mikepass', 'Michael Brown', '101 Pine St, Hamlet', 'Male'),
('emily.davis@example.com', 'emilypass', 'Emily Davis', '202 Birch St, Metropolis', 'Female'),
('david.wilson@example.com', 'davidpass', 'David Wilson', '303 Cedar St, Smalltown', 'Male'),
('sarah.miller@example.com', 'sarahpass', 'Sarah Miller', '404 Maple St, Bigcity', 'Female'),
('chris.moore@example.com', 'chrispass', 'Chris Moore', '505 Walnut St, Suburbia', 'Male'),
('laura.taylor@example.com', 'laurapass', 'Laura Taylor', '606 Chestnut St, Countryside', 'Female'),
('james.anderson@example.com', 'jamespass', 'James Anderson', '707 Spruce St, Uptown', 'Male'),
('linda.thomas@example.com', 'lindapass', 'Linda Thomas', '808 Fir St, Downtown', 'Female'),
('robert.jackson@example.com', 'robertpass', 'Robert Jackson', '909 Redwood St, Seaside', 'Male'),
('barbara.white@example.com', 'barbarapass', 'Barbara White', '1010 Cypress St, Riverside', 'Female'),
('charles.harris@example.com', 'charlespass', 'Charles Harris', '1111 Willow St, Lakeside', 'Male'),
('patricia.martin@example.com', 'patriciapass', 'Patricia Martin', '1212 Poplar St, Hillside', 'Female'),
('daniel.thompson@example.com', 'danielpass', 'Daniel Thompson', '1313 Alder St, Valleyview', 'Male'),
('jennifer.garcia@example.com', 'jenniferpass', 'Jennifer Garcia', '1414 Ash St, Mountainview', 'Female'),
('matthew.martinez@example.com', 'matthewpass', 'Matthew Martinez', '1515 Beech St, Forestville', 'Male'),
('elizabeth.robinson@example.com', 'elizabethpass', 'Elizabeth Robinson', '1616 Elm St, Meadowbrook', 'Female'),
('anthony.clark@example.com', 'anthonypass', 'Anthony Clark', '1717 Pine St, Brookside', 'Male'),
('susan.rodriguez@example.com', 'susanpass', 'Susan Rodriguez', '1818 Birch St, Parkview', 'Female'),
('mark.lewis@example.com', 'markpass', 'Mark Lewis', '1919 Cedar St, Woodside', 'Male'),
('mary.lee@example.com', 'marypass', 'Mary Lee', '2020 Maple St, Cliffside', 'Female'),
('paul.walker@example.com', 'paulpass', 'Paul Walker', '2121 Walnut St, Bayside', 'Male'),
('nancy.hall@example.com', 'nancypass', 'Nancy Hall', '2222 Chestnut St, Creekside', 'Female'),
('steven.allen@example.com', 'stevenpass', 'Steven Allen', '2323 Spruce St, Riverside', 'Male'),
('karen.young@example.com', 'karenpass', 'Karen Young', '2424 Fir St, Lakeside', 'Female'),
('joshua.king@example.com', 'joshuapass', 'Joshua King', '2525 Redwood St, Hillside', 'Male'),
('betty.wright@example.com', 'bettypass', 'Betty Wright', '2626 Cypress St, Valleyview', 'Female'),
('kevin.lopez@example.com', 'kevinpass', 'Kevin Lopez', '2727 Willow St, Mountainview', 'Male'),
('helen.hill@example.com', 'helenpass', 'Helen Hill', '2828 Poplar St, Forestville', 'Female'),
('brian.scott@example.com', 'brianpass', 'Brian Scott', '2929 Alder St, Meadowbrook', 'Male'),
('sandra.green@example.com', 'sandrapass', 'Sandra Green', '3030 Ash St, Brookside', 'Female'),
('edward.adams@example.com', 'edwardpass', 'Edward Adams', '3131 Beech St, Parkview', 'Male'),
('donna.baker@example.com', 'donnapass', 'Donna Baker', '3232 Elm St, Woodside', 'Female'),
('ronald.nelson@example.com', 'ronaldpass', 'Ronald Nelson', '3333 Pine St, Cliffside', 'Male'),
('carol.carter@example.com', 'carolpass', 'Carol Carter', '3434 Birch St, Bayside', 'Female'),
('kenneth.mitchell@example.com', 'kennethpass', 'Kenneth Mitchell', '3535 Cedar St, Creekside', 'Male'),
('ruth.perez@example.com', 'ruthpass', 'Ruth Perez', '3636 Maple St, Riverside', 'Female');

-- Inserting Data into MedicalHistory Table
INSERT INTO MedicalHistory (id, date, conditions, surgeries, medication)
VALUES
(1, '2024-01-15', 'Asthma', 'Appendectomy', 'Inhaler'),
(2, '2024-03-22', 'Diabetes', 'None', 'Insulin'),
(3, '2024-05-10', 'Hypertension', 'Gallbladder Removal', 'Beta Blockers'),
(4, '2024-07-18', 'Allergies', 'None', 'Antihistamines'),
(5, '2024-09-25', 'Arthritis', 'Knee Replacement', 'Painkillers'),
(6, '2024-11-30', 'Migraine', 'None', 'Triptans'),
(7, '2025-02-14', 'Depression', 'None', 'SSRIs'),
(8, '2025-04-20', 'Anxiety', 'None', 'Benzodiazepines'),
(9, '2025-06-28', 'Thyroid Disorder', 'None', 'Levothyroxine'),
(10, '2025-08-05', 'Cholesterol', 'None', 'Statins'),
(11, '2025-10-12', 'Heart Disease', 'Bypass Surgery', 'Aspirin'),
(12, '2025-12-19', 'Kidney Stones', 'None', 'Painkillers'),
(13, '2026-02-25', 'Liver Disease', 'None', 'Ursodiol'),
(14, '2026-05-03', 'Pneumonia', 'None', 'Antibiotics'),
(15, '2026-07-10', 'Tuberculosis', 'None', 'Isoniazid'),
(16, '2026-09-17', 'Hepatitis', 'None', 'Interferon'),
(17, '2026-11-24', 'HIV/AIDS', 'None', 'Antiretrovirals'),
(18, '2027-02-01', 'Cancer', 'Chemotherapy', 'Tamoxifen'),
(19, '2027-04-10', 'Stroke', 'None', 'Warfarin'),
(20, '2027-06-17', 'Epilepsy', 'None', 'Carbamazepine'),
(21, '2027-08-24', 'Parkinson\'s Disease', 'None', 'Levodopa'),
(22, '2027-11-01', 'Multiple Sclerosis', 'None', 'Interferon beta'),
(23, '2028-01-08', 'Alzheimer\'s Disease', 'None', 'Donepezil'),
(24, '2028-03-15', 'Osteoporosis', 'None', 'Bisphosphonates'),
(25, '2028-05-22', 'Gout', 'None', 'Allopurinol'),
(26, '2028-07-29', 'Psoriasis', 'None', 'Topical Steroids'),
(27, '2028-10-05', 'Lupus', 'None', 'Hydroxychloroquine'),
(28, '2029-01-12', 'Crohn\'s Disease', 'None', 'Infliximab'),
(29, '2029-03-19', 'Ulcerative Colitis', 'None', 'Mesalamine'),
(30, '2029-05-26', 'Celiac Disease', 'None', 'Gluten-free Diet'),
(31, '2029-08-02', 'Irritable Bowel Syndrome', 'None', 'Antispasmodics'),
(32, '2029-10-09', 'Diverticulitis', 'None', 'Antibiotics'),
(33, '2030-01-16', 'Hemorrhoids', 'None', 'Topical Creams'),
(34, '2030-05-09', 'Diverticulitis', 'None', 'Antibiotics'),
(35, '2030-10-16', 'Hemorrhoids', 'None', 'Topical Creams');

-- Inserting Data into Doctor Table
INSERT INTO Doctor (email, gender, password, name)
VALUES
('dr.james@example.com', 'Male', 'docpass123', 'Dr. James Wilson'),
('dr.susan@example.com', 'Female', 'docpass456', 'Dr. Susan Clark'),
('dr.mike@example.com', 'Male', 'docpass789', 'Dr. Mike Brown'),
('dr.linda@example.com', 'Female', 'docpass101', 'Dr. Linda Green'),
('dr.robert@example.com', 'Male', 'docpass102', 'Dr. Robert White'),
('dr.karen@example.com', 'Female', 'docpass103', 'Dr. Karen Black'),
('dr.david@example.com', 'Male', 'docpass104', 'Dr. David Brown'),
('dr.emily@example.com', 'Female', 'docpass105', 'Dr. Emily Davis'),
('dr.john@example.com', 'Male', 'docpass106', 'Dr. John Smith'),
('dr.sarah@example.com', 'Female', 'docpass107', 'Dr. Sarah Johnson'),
('dr.michael@example.com', 'Male', 'docpass108', 'Dr. Michael Lee'),
('dr.jessica@example.com', 'Female', 'docpass109', 'Dr. Jessica Martinez'),
('dr.william@example.com', 'Male', 'docpass110', 'Dr. William Garcia'),
('dr.amy@example.com', 'Female', 'docpass111', 'Dr. Amy Rodriguez'),
('dr.richard@example.com', 'Male', 'docpass112', 'Dr. Richard Wilson'),
('dr.mary@example.com', 'Female', 'docpass113', 'Dr. Mary Anderson'),
('dr.thomas@example.com', 'Male', 'docpass114', 'Dr. Thomas Thomas'),
('dr.patricia@example.com', 'Female', 'docpass115', 'Dr. Patricia Taylor'),
('dr.charles@example.com', 'Male', 'docpass116', 'Dr. Charles Moore'),
('dr.barbara@example.com', 'Female', 'docpass117', 'Dr. Barbara Jackson'),
('dr.joseph@example.com', 'Male', 'docpass118', 'Dr. Joseph Martin'),
('dr.elizabeth@example.com', 'Female', 'docpass119', 'Dr. Elizabeth Thompson'),
('dr.chris@example.com', 'Male', 'docpass120', 'Dr. Chris Martinez'),
('dr.nancy@example.com', 'Female', 'docpass121', 'Dr. Nancy Harris'),
('dr.daniel@example.com', 'Male', 'docpass122', 'Dr. Daniel Clark'),
('dr.lisa@example.com', 'Female', 'docpass123', 'Dr. Lisa Lewis'),
('dr.paul@example.com', 'Male', 'docpass124', 'Dr. Paul Robinson'),
('dr.kare@example.com', 'Female', 'docpass125', 'Dr. Kare Walker'),
('dr.kevin@example.com', 'Male', 'docpass126', 'Dr. Kevin Young'),
('dr.helen@example.com', 'Female', 'docpass127', 'Dr. Helen King'),
('dr.brian@example.com', 'Male', 'docpass128', 'Dr. Brian Wright'),
('dr.sandra@example.com', 'Female', 'docpass129', 'Dr. Sandra Lopez'),
('dr.edward@example.com', 'Male', 'docpass130', 'Dr. Edward Hill'),
('dr.donna@example.com', 'Female', 'docpass131', 'Dr. Donna Scott'),
('dr.ronald@example.com', 'Male', 'docpass132', 'Dr. Ronald Green'),
('dr.carol@example.com', 'Female', 'docpass133', 'Dr. Carol Adams'),
('dr.kenneth@example.com', 'Male', 'docpass134', 'Dr. Kenneth Baker'),
('dr.ruth@example.com', 'Female', 'docpass135', 'Dr. Ruth Nelson');

-- Inserting Data into Appointment Table
INSERT INTO Appointment (id, date, starttime, endtime, status)
VALUES
(1, '2024-08-10', '10:00:00', '10:30:00', 'Scheduled'),
(2, '2024-08-12', '11:00:00', '11:30:00', 'Completed'),
(3, '2024-08-13', '14:00:00', '14:30:00', 'Cancelled'),
(4, '2024-08-14', '09:00:00', '09:30:00', 'Scheduled'),
(5, '2024-08-15', '10:00:00', '10:30:00', 'Completed'),
(6, '2024-08-16', '11:00:00', '11:30:00', 'Cancelled'),
(7, '2024-08-17', '12:00:00', '12:30:00', 'Scheduled'),
(8, '2024-08-18', '13:00:00', '13:30:00', 'Completed'),
(9, '2024-08-19', '14:00:00', '14:30:00', 'Cancelled'),
(10, '2024-08-20', '15:00:00', '15:30:00', 'Scheduled'),
(11, '2024-08-21', '16:00:00', '16:30:00', 'Completed'),
(12, '2024-08-22', '17:00:00', '17:30:00', 'Cancelled'),
(13, '2024-08-23', '09:00:00', '09:30:00', 'Scheduled'),
(14, '2024-08-24', '10:00:00', '10:30:00', 'Completed'),
(15, '2024-08-25', '11:00:00', '11:30:00', 'Cancelled'),
(16, '2024-08-26', '12:00:00', '12:30:00', 'Scheduled'),
(17, '2024-08-27', '13:00:00', '13:30:00', 'Completed'),
(18, '2024-08-28', '14:00:00', '14:30:00', 'Cancelled'),
(19, '2024-08-29', '15:00:00', '15:30:00', 'Scheduled'),
(20, '2024-08-30', '16:00:00', '16:30:00', 'Completed'),
(21, '2024-08-31', '17:00:00', '17:30:00', 'Cancelled'),
(22, '2024-09-01', '09:00:00', '09:30:00', 'Scheduled'),
(23, '2024-09-02', '10:00:00', '10:30:00', 'Completed'),
(24, '2024-09-03', '11:00:00', '11:30:00', 'Cancelled'),
(25, '2024-09-04', '12:00:00', '12:30:00', 'Scheduled'),
(26, '2024-09-05', '13:00:00', '13:30:00', 'Completed'),
(27, '2024-09-06', '14:00:00', '14:30:00', 'Cancelled'),
(28, '2024-09-07', '15:00:00', '15:30:00', 'Scheduled'),
(29, '2024-09-08', '16:00:00', '16:30:00', 'Completed'),
(30, '2024-09-09', '17:00:00', '17:30:00', 'Cancelled'),
(31, '2024-09-10', '09:00:00', '09:30:00', 'Scheduled'),
(32, '2024-09-11', '10:00:00', '10:30:00', 'Completed'),
(33, '2024-09-12', '11:00:00', '11:30:00', 'Cancelled'),
(34, '2024-09-13', '12:00:00', '12:30:00', 'Scheduled'),
(35, '2024-09-14', '13:00:00', '13:30:00', 'Completed');

-- Inserting Data into PatientsAttendAppointments Table
INSERT INTO PatientsAttendAppointments (patient, appt, concerns, symptoms)
VALUES
('john.doe@example.com', 1, 'Breathing Issues', 'Shortness of breath'),
('jane.smith@example.com', 2, 'Skin Rash', 'Itching and redness'),
('alice.jones@example.com', 3, 'Headache', 'Severe migraines'),
('michael.brown@example.com', 4, 'Chest Pain', 'Sharp pain'),
('emily.davis@example.com', 5, 'Back Pain', 'Lower back pain'),
('david.wilson@example.com', 6, 'Joint Pain', 'Knee pain'),
('sarah.miller@example.com', 7, 'Fatigue', 'Extreme tiredness'),
('chris.moore@example.com', 8, 'Dizziness', 'Lightheadedness'),
('laura.taylor@example.com', 9, 'Nausea', 'Feeling sick'),
('james.anderson@example.com', 10, 'Cough', 'Persistent cough'),
('linda.thomas@example.com', 11, 'Fever', 'High temperature'),
('robert.jackson@example.com', 12, 'Sore Throat', 'Painful swallowing'),
('barbara.white@example.com', 13, 'Ear Pain', 'Earache'),
('charles.harris@example.com', 14, 'Abdominal Pain', 'Stomach ache'),
('patricia.martin@example.com', 15, 'Swelling', 'Swollen ankle'),
('daniel.thompson@example.com', 16, 'Burning Sensation', 'Burning feeling'),
('jennifer.garcia@example.com', 17, 'Blurred Vision', 'Vision problems'),
('matthew.martinez@example.com', 18, 'Cold Symptoms', 'Runny nose'),
('elizabeth.robinson@example.com', 19, 'Muscle Pain', 'Muscle soreness'),
('anthony.clark@example.com', 20, 'Vomiting', 'Throwing up'),
('susan.rodriguez@example.com', 21, 'Diarrhea', 'Loose stools'),
('mark.lewis@example.com', 22, 'Constipation', 'Difficulty passing stools'),
('mary.lee@example.com', 23, 'Rash', 'Skin irritation'),
('paul.walker@example.com', 24, 'Insomnia', 'Trouble sleeping'),
('nancy.hall@example.com', 25, 'Anxiety', 'Feeling anxious'),
('steven.allen@example.com', 26, 'Depression', 'Feeling down'),
('karen.young@example.com', 27, 'Weight Loss', 'Unintentional weight loss'),
('joshua.king@example.com', 28, 'Weight Gain', 'Unintentional weight gain'),
('betty.wright@example.com', 29, 'Hair Loss', 'Thinning hair'),
('kevin.lopez@example.com', 30, 'Memory Loss', 'Forgetfulness'),
('helen.hill@example.com', 31, 'Tingling', 'Pins and needles'),
('brian.scott@example.com', 32, 'Bruising', 'Easy bruising'),
('sandra.green@example.com', 33, 'Bleeding', 'Unexplained bleeding'),
('edward.adams@example.com', 34, 'Palpitations', 'Heart racing'),
('donna.baker@example.com', 35, 'Sweating', 'Excessive sweating');

-- Inserting Data into Diagnose Table
INSERT INTO Diagnose (appt, doctor, diagnosis, prescription)
VALUES
(1, 'dr.james@example.com', 'Asthma', 'Inhaler'),
(2, 'dr.susan@example.com', 'Allergic Reaction', 'Antihistamines'),
(3, 'dr.mike@example.com', 'Migraine', 'Pain Relievers'),
(4, 'dr.linda@example.com', 'Angina', 'Nitroglycerin'),
(5, 'dr.robert@example.com', 'Sciatica', 'Physical Therapy'),
(6, 'dr.karen@example.com', 'Arthritis', 'NSAIDs'),
(7, 'dr.david@example.com', 'Chronic Fatigue', 'Lifestyle Changes'),
(8, 'dr.emily@example.com', 'Vertigo', 'Meclizine'),
(9, 'dr.john@example.com', 'Gastroenteritis', 'Hydration'),
(10, 'dr.sarah@example.com', 'Bronchitis', 'Antibiotics'),
(11, 'dr.michael@example.com', 'Influenza', 'Rest & Fluids'),
(12, 'dr.jessica@example.com', 'Pharyngitis', 'Throat Lozenges'),
(13, 'dr.william@example.com', 'Otitis Media', 'Ear Drops'),
(14, 'dr.amy@example.com', 'Gastritis', 'Antacids'),
(15, 'dr.richard@example.com', 'Edema', 'Diuretics'),
(16, 'dr.mary@example.com', 'Neuropathy', 'Gabapentin'),
(17, 'dr.thomas@example.com', 'Conjunctivitis', 'Eye Drops'),
(18, 'dr.patricia@example.com', 'Common Cold', 'Decongestants'),
(19, 'dr.charles@example.com', 'Myalgia', 'Muscle Relaxants'),
(20, 'dr.barbara@example.com', 'Gastroesophageal Reflux', 'Proton Pump Inhibitors'),
(21, 'dr.joseph@example.com', 'Irritable Bowel Syndrome', 'Dietary Changes'),
(22, 'dr.elizabeth@example.com', 'Constipation', 'Laxatives'),
(23, 'dr.chris@example.com', 'Dermatitis', 'Topical Steroids'),
(24, 'dr.nancy@example.com', 'Insomnia', 'Sleep Aids'),
(25, 'dr.daniel@example.com', 'Generalized Anxiety Disorder', 'SSRIs'),
(26, 'dr.lisa@example.com', 'Major Depressive Disorder', 'Antidepressants'),
(27, 'dr.paul@example.com', 'Hyperthyroidism', 'Methimazole'),
(28, 'dr.karen@example.com', 'Hypothyroidism', 'Levothyroxine'),
(29, 'dr.kevin@example.com', 'Alopecia', 'Minoxidil'),
(30, 'dr.helen@example.com', 'Amnesia', 'Cognitive Therapy'),
(31, 'dr.brian@example.com', 'Peripheral Neuropathy', 'Vitamin B12'),
(32, 'dr.sandra@example.com', 'Purpura', 'Steroids'),
(33, 'dr.edward@example.com', 'Hemophilia', 'Factor Replacement'),
(34, 'dr.donna@example.com', 'Arrhythmia', 'Beta Blockers'),
(35, 'dr.ronald@example.com', 'Hyperhidrosis', 'Antiperspirants');

-- Inserting Data into Schedule Table
INSERT INTO Schedule (id, starttime, endtime, breaktime, day)
VALUES
(1, '08:00:00', '12:00:00', '10:00:00', 'Monday'),
(2, '13:00:00', '17:00:00', '15:00:00', 'Wednesday'),
(3, '09:00:00', '13:00:00', '11:00:00', 'Friday'),
(4, '08:00:00', '12:00:00', '10:00:00', 'Tuesday'),
(5, '13:00:00', '17:00:00', '15:00:00', 'Thursday'),
(6, '09:00:00', '13:00:00', '11:00:00', 'Saturday'),
(7, '08:00:00', '12:00:00', '10:00:00', 'Sunday'),
(8, '13:00:00', '17:00:00', '15:00:00', 'Monday'),
(9, '09:00:00', '13:00:00', '11:00:00', 'Wednesday'),
(10, '08:00:00', '12:00:00', '10:00:00', 'Friday'),
(11, '13:00:00', '17:00:00', '15:00:00', 'Tuesday'),
(12, '09:00:00', '13:00:00', '11:00:00', 'Thursday'),
(13, '08:00:00', '12:00:00', '10:00:00', 'Saturday'),
(14, '13:00:00', '17:00:00', '15:00:00', 'Sunday'),
(15, '09:00:00', '13:00:00', '11:00:00', 'Monday'),
(16, '08:00:00', '12:00:00', '10:00:00', 'Wednesday'),
(17, '13:00:00', '17:00:00', '15:00:00', 'Friday'),
(18, '09:00:00', '13:00:00', '11:00:00', 'Tuesday'),
(19, '08:00:00', '12:00:00', '10:00:00', 'Thursday'),
(20, '13:00:00', '17:00:00', '15:00:00', 'Saturday'),
(21, '09:00:00', '13:00:00', '11:00:00', 'Sunday'),
(22, '08:00:00', '12:00:00', '10:00:00', 'Monday'),
(23, '13:00:00', '17:00:00', '15:00:00', 'Wednesday'),
(24, '09:00:00', '13:00:00', '11:00:00', 'Friday'),
(25, '08:00:00', '12:00:00', '10:00:00', 'Tuesday'),
(26, '13:00:00', '17:00:00', '15:00:00', 'Thursday'),
(27, '09:00:00', '13:00:00', '11:00:00', 'Saturday'),
(28, '08:00:00', '12:00:00', '10:00:00', 'Sunday'),
(29, '13:00:00', '17:00:00', '15:00:00', 'Monday'),
(30, '09:00:00', '13:00:00', '11:00:00', 'Wednesday'),
(31, '08:00:00', '12:00:00', '10:00:00', 'Friday'),
(32, '13:00:00', '17:00:00', '15:00:00', 'Tuesday'),
(33, '09:00:00', '13:00:00', '11:00:00', 'Thursday'),
(34, '08:00:00', '12:00:00', '10:00:00', 'Saturday'),
(35, '13:00:00', '17:00:00', '15:00:00', 'Sunday');

-- Inserting Data into DocsHaveSchedules Table
INSERT INTO DocsHaveSchedules (sched, doctor)
VALUES
(1, 'dr.james@example.com'),
(2, 'dr.susan@example.com'),
(3, 'dr.mike@example.com'),
(4, 'dr.linda@example.com'),
(5, 'dr.robert@example.com'),
(6, 'dr.karen@example.com'),
(7, 'dr.david@example.com'),
(8, 'dr.emily@example.com'),
(9, 'dr.john@example.com'),
(10, 'dr.sarah@example.com'),
(11, 'dr.michael@example.com'),
(12, 'dr.jessica@example.com'),
(13, 'dr.william@example.com'),
(14, 'dr.amy@example.com'),
(15, 'dr.richard@example.com'),
(16, 'dr.mary@example.com'),
(17, 'dr.thomas@example.com'),
(18, 'dr.patricia@example.com'),
(19, 'dr.charles@example.com'),
(20, 'dr.barbara@example.com'),
(21, 'dr.joseph@example.com'),
(22, 'dr.elizabeth@example.com'),
(23, 'dr.chris@example.com'),
(24, 'dr.nancy@example.com'),
(25, 'dr.daniel@example.com'),
(26, 'dr.lisa@example.com'),
(27, 'dr.paul@example.com'),
(28, 'dr.karen@example.com'),
(29, 'dr.kevin@example.com'),
(30, 'dr.helen@example.com'),
(31, 'dr.brian@example.com'),
(32, 'dr.sandra@example.com'),
(33, 'dr.edward@example.com'),
(34, 'dr.donna@example.com'),
(35, 'dr.ronald@example.com');

-- Inserting Data into PatientsFillHistory Table
INSERT INTO PatientsFillHistory (patient, history)
VALUES
('john.doe@example.com', 1),
('jane.smith@example.com', 2),
('alice.jones@example.com', 3),
('michael.brown@example.com', 4),
('emily.davis@example.com', 5),
('david.wilson@example.com', 6),
('sarah.miller@example.com', 7),
('chris.moore@example.com', 8),
('laura.taylor@example.com', 9),
('james.anderson@example.com', 10),
('linda.thomas@example.com', 11),
('robert.jackson@example.com', 12),
('barbara.white@example.com', 13),
('charles.harris@example.com', 14),
('patricia.martin@example.com', 15),
('daniel.thompson@example.com', 16),
('jennifer.garcia@example.com', 17),
('matthew.martinez@example.com', 18),
('elizabeth.robinson@example.com', 19),
('anthony.clark@example.com', 20),
('susan.rodriguez@example.com', 21),
('mark.lewis@example.com', 22),
('mary.lee@example.com', 23),
('paul.walker@example.com', 24),
('nancy.hall@example.com', 25),
('steven.allen@example.com', 26),
('karen.young@example.com', 27),
('joshua.king@example.com', 28),
('betty.wright@example.com', 29),
('kevin.lopez@example.com', 30),
('helen.hill@example.com', 31),
('brian.scott@example.com', 32),
('sandra.green@example.com', 33),
('edward.adams@example.com', 34),
('donna.baker@example.com', 35);

-- Inserting Data into DoctorViewsHistory Table
INSERT INTO DoctorViewsHistory (history, doctor)
VALUES
(1, 'dr.james@example.com'),
(2, 'dr.susan@example.com'),
(3, 'dr.mike@example.com'),
(4, 'dr.linda@example.com'),
(5, 'dr.robert@example.com'),
(6, 'dr.karen@example.com'),
(7, 'dr.david@example.com'),
(8, 'dr.emily@example.com'),
(9, 'dr.john@example.com'),
(10, 'dr.sarah@example.com'),
(11, 'dr.michael@example.com'),
(12, 'dr.jessica@example.com'),
(13, 'dr.william@example.com'),
(14, 'dr.amy@example.com'),
(15, 'dr.richard@example.com'),
(16, 'dr.mary@example.com'),
(17, 'dr.thomas@example.com'),
(18, 'dr.patricia@example.com'),
(19, 'dr.charles@example.com'),
(20, 'dr.barbara@example.com'),
(21, 'dr.joseph@example.com'),
(22, 'dr.elizabeth@example.com'),
(23, 'dr.chris@example.com'),
(24, 'dr.nancy@example.com'),
(25, 'dr.daniel@example.com'),
(26, 'dr.lisa@example.com'),
(27, 'dr.paul@example.com'),
(28, 'dr.karen@example.com'),
(29, 'dr.kevin@example.com'),
(30, 'dr.helen@example.com'),
(31, 'dr.brian@example.com'),
(32, 'dr.sandra@example.com'),
(33, 'dr.edward@example.com'),
(34, 'dr.donna@example.com'),
(35, 'dr.ronald@example.com');

-- Inserting Data into Emergency Table
INSERT INTO Emergency (PatientID, PatientCondition, DoctorID, ArrivalTime)
VALUES
('john.doe@example.com', 'Severe Breathing Difficulty', 'dr.james@example.com', '2024-08-14 13:45:00'),
('jane.smith@example.com', 'High Fever and Dizziness', 'dr.susan@example.com', '2024-08-15 09:30:00'),
('alice.jones@example.com', 'Severe Headache', 'dr.mike@example.com', '2024-08-16 11:00:00'),
('michael.brown@example.com', 'Chest Pain', 'dr.linda@example.com', '2024-08-17 14:20:00'),
('emily.davis@example.com', 'Back Injury', 'dr.robert@example.com', '2024-08-18 16:45:00'),
('david.wilson@example.com', 'Joint Swelling', 'dr.karen@example.com', '2024-08-19 10:30:00'),
('sarah.miller@example.com', 'Extreme Fatigue', 'dr.david@example.com', '2024-08-20 12:15:00'),
('chris.moore@example.com', 'Dizziness and Nausea', 'dr.emily@example.com', '2024-08-21 09:50:00'),
('laura.taylor@example.com', 'Severe Abdominal Pain', 'dr.john@example.com', '2024-08-22 13:10:00'),
('james.anderson@example.com', 'Persistent Cough', 'dr.sarah@example.com', '2024-08-23 15:25:00'),
('linda.thomas@example.com', 'High Fever', 'dr.michael@example.com', '2024-08-24 17:40:00'),
('robert.jackson@example.com', 'Sore Throat', 'dr.jessica@example.com', '2024-08-25 11:05:00'),
('barbara.white@example.com', 'Ear Infection', 'dr.william@example.com', '2024-08-26 14:30:00'),
('charles.harris@example.com', 'Severe Stomach Ache', 'dr.amy@example.com', '2024-08-27 16:55:00'),
('patricia.martin@example.com', 'Swollen Ankle', 'dr.richard@example.com', '2024-08-28 10:20:00'),
('daniel.thompson@example.com', 'Burning Sensation', 'dr.mary@example.com', '2024-08-29 12:45:00'),
('jennifer.garcia@example.com', 'Blurred Vision', 'dr.thomas@example.com', '2024-08-30 15:10:00'),
('matthew.martinez@example.com', 'Cold Symptoms', 'dr.patricia@example.com', '2024-08-31 17:35:00'),
('elizabeth.robinson@example.com', 'Muscle Pain', 'dr.charles@example.com', '2024-09-01 09:00:00'),
('anthony.clark@example.com', 'Vomiting', 'dr.barbara@example.com', '2024-09-02 11:25:00'),
('susan.rodriguez@example.com', 'Diarrhea', 'dr.joseph@example.com', '2024-09-03 13:50:00'),
('mark.lewis@example.com', 'Constipation', 'dr.elizabeth@example.com', '2024-09-04 16:15:00'),
('mary.lee@example.com', 'Skin Rash', 'dr.chris@example.com', '2024-09-05 10:40:00'),
('paul.walker@example.com', 'Insomnia', 'dr.nancy@example.com', '2024-09-06 13:05:00'),
('nancy.hall@example.com', 'Anxiety Attack', 'dr.daniel@example.com', '2024-09-07 15:30:00'),
('steven.allen@example.com', 'Depression', 'dr.lisa@example.com', '2024-09-08 17:55:00'),
('karen.young@example.com', 'Unintentional Weight Loss', 'dr.paul@example.com', '2024-09-09 09:20:00'),
('joshua.king@example.com', 'Unintentional Weight Gain', 'dr.karen@example.com', '2024-09-10 11:45:00'),
('betty.wright@example.com', 'Hair Loss', 'dr.kevin@example.com', '2024-09-11 14:10:00'),
('kevin.lopez@example.com', 'Memory Loss', 'dr.helen@example.com', '2024-09-12 16:35:00'),
('helen.hill@example.com', 'Tingling Sensation', 'dr.brian@example.com', '2024-09-13 10:00:00'),
('brian.scott@example.com', 'Easy Bruising', 'dr.sandra@example.com', '2024-09-14 12:25:00'),
('sandra.green@example.com', 'Unexplained Bleeding', 'dr.edward@example.com', '2024-09-15 14:50:00'),
('edward.adams@example.com', 'Heart Palpitations', 'dr.donna@example.com', '2024-09-16 17:15:00'),
('donna.baker@example.com', 'Excessive Sweating', 'dr.ronald@example.com', '2024-09-17 09:40:00');

-- Inserting Data into Insurance Table
INSERT INTO Insurance (PatientID, ProviderName, PolicyNumber)
VALUES
('john.doe@example.com', 'HealthSecure', 'HS12345'),
('alice.jones@example.com', 'MediCare Plus', 'MC67890'),
('jane.smith@example.com', 'HealthFirst', 'HF11223'),
('michael.brown@example.com', 'WellCare', 'WC44556'),
('emily.davis@example.com', 'UnitedHealth', 'UH77889'),
('david.wilson@example.com', 'BlueCross', 'BC99001'),
('sarah.miller@example.com', 'Aetna', 'AE22334'),
('chris.moore@example.com', 'Cigna', 'CG55667'),
('laura.taylor@example.com', 'Humana', 'HM88990'),
('james.anderson@example.com', 'Kaiser', 'KP11223'),
('linda.thomas@example.com', 'Anthem', 'AT44556'),
('robert.jackson@example.com', 'Oscar', 'OS77889'),
('barbara.white@example.com', 'Molina', 'ML99001'),
('charles.harris@example.com', 'Centene', 'CN22334'),
('patricia.martin@example.com', 'Amerigroup', 'AG55667'),
('daniel.thompson@example.com', 'Medica', 'MD88990'),
('jennifer.garcia@example.com', 'HealthNet', 'HN11223'),
('matthew.martinez@example.com', 'Tricare', 'TR44556'),
('elizabeth.robinson@example.com', 'Fidelis', 'FD77889'),
('anthony.clark@example.com', 'MetroPlus', 'MP99001'),
('susan.rodriguez@example.com', 'Affinity', 'AF22334'),
('mark.lewis@example.com', 'EmblemHealth', 'EH55667'),
('mary.lee@example.com', 'Empire', 'EP88990'),
('paul.walker@example.com', 'Excellus', 'EX11223'),
('nancy.hall@example.com', 'HealthPartners', 'HP44556'),
('steven.allen@example.com', 'Independence', 'IN77889'),
('karen.young@example.com', 'Premera', 'PR99001'),
('joshua.king@example.com', 'Regence', 'RG22334'),
('betty.wright@example.com', 'SelectHealth', 'SH55667'),
('kevin.lopez@example.com', 'Tufts', 'TU88990'),
('helen.hill@example.com', 'UPMC', 'UP11223'),
('brian.scott@example.com', 'Wellmark', 'WM44556'),
('sandra.green@example.com', 'Geisinger', 'GS77889'),
('edward.adams@example.com', 'HealthAlliance', 'HA99001'),
('donna.baker@example.com', 'HealthPartners', 'HP22334'),
('ronald.nelson@example.com', 'Highmark', 'HM55667');

-- Inserting Data into RoomsAndWards Table
INSERT INTO RoomsAndWards (RoomID, RoomType, AvailabilityStatus, AssignedPatientID)
VALUES
(101, 'ICU', 'Occupied', 'john.doe@example.com'),
(102, 'General', 'Available', NULL),
(103, 'Private', 'Occupied', 'alice.jones@example.com'),
(104, 'ICU', 'Available', NULL),
(105, 'General', 'Occupied', 'jane.smith@example.com'),
(106, 'Private', 'Available', NULL),
(107, 'ICU', 'Occupied', 'michael.brown@example.com'),
(108, 'General', 'Available', NULL),
(109, 'Private', 'Occupied', 'emily.davis@example.com'),
(110, 'ICU', 'Available', NULL),
(111, 'General', 'Occupied', 'david.wilson@example.com'),
(112, 'Private', 'Available', NULL),
(113, 'ICU', 'Occupied', 'sarah.miller@example.com'),
(114, 'General', 'Available', NULL),
(115, 'Private', 'Occupied', 'chris.moore@example.com'),
(116, 'ICU', 'Available', NULL),
(117, 'General', 'Occupied', 'laura.taylor@example.com'),
(118, 'Private', 'Available', NULL),
(119, 'ICU', 'Occupied', 'james.anderson@example.com'),
(120, 'General', 'Available', NULL),
(121, 'Private', 'Occupied', 'linda.thomas@example.com'),
(122, 'ICU', 'Available', NULL),
(123, 'General', 'Occupied', 'robert.jackson@example.com'),
(124, 'Private', 'Available', NULL),
(125, 'ICU', 'Occupied', 'barbara.white@example.com'),
(126, 'General', 'Available', NULL),
(127, 'Private', 'Occupied', 'charles.harris@example.com'),
(128, 'ICU', 'Available', NULL),
(129, 'General', 'Occupied', 'patricia.martin@example.com'),
(130, 'Private', 'Available', NULL),
(131, 'ICU', 'Occupied', 'daniel.thompson@example.com'),
(132, 'General', 'Available', NULL),
(133, 'Private', 'Occupied', 'jennifer.garcia@example.com'),
(134, 'ICU', 'Available', NULL),
(135, 'General', 'Occupied', 'matthew.martinez@example.com');

-- Inserting Data into SupportStaff Table
INSERT INTO SupportStaff (StaffID, Name, Role, Department, Shift)
VALUES
(1, 'Emily Johnson', 'Nurse', 'Emergency', 'Evening'),
(2, 'Mark Lee', 'Technician', 'Radiology', 'Night'),
(3, 'Rachel Green', 'Admin', 'Reception', 'Morning'),
(4, 'John Smith', 'Nurse', 'ICU', 'Night'),
(5, 'Linda Brown', 'Technician', 'Laboratory', 'Evening'),
(6, 'Michael Davis', 'Admin', 'Billing', 'Morning'),
(7, 'Sarah Wilson', 'Nurse', 'General Ward', 'Evening'),
(8, 'David Miller', 'Technician', 'Pharmacy', 'Night'),
(9, 'Laura Moore', 'Admin', 'Records', 'Morning'),
(10, 'James Taylor', 'Nurse', 'Surgery', 'Evening'),
(11, 'Barbara Anderson', 'Technician', 'Radiology', 'Night'),
(12, 'Robert Thomas', 'Admin', 'Reception', 'Morning'),
(13, 'Patricia Jackson', 'Nurse', 'Emergency', 'Evening'),
(14, 'Charles Harris', 'Technician', 'Laboratory', 'Night'),
(15, 'Jennifer Martin', 'Admin', 'Billing', 'Morning'),
(16, 'Daniel Thompson', 'Nurse', 'ICU', 'Evening'),
(17, 'Matthew Garcia', 'Technician', 'Pharmacy', 'Night'),
(18, 'Elizabeth Martinez', 'Admin', 'Records', 'Morning'),
(19, 'Anthony Robinson', 'Nurse', 'General Ward', 'Evening'),
(20, 'Susan Clark', 'Technician', 'Radiology', 'Night'),
(21, 'Mark Lewis', 'Admin', 'Reception', 'Morning'),
(22, 'Mary Walker', 'Nurse', 'Surgery', 'Evening'),
(23, 'Paul Hall', 'Technician', 'Laboratory', 'Night'),
(24, 'Nancy Allen', 'Admin', 'Billing', 'Morning'),
(25, 'Steven Young', 'Nurse', 'Emergency', 'Evening'),
(26, 'Karen King', 'Technician', 'Pharmacy', 'Night'),
(27, 'Joshua Wright', 'Admin', 'Records', 'Morning'),
(28, 'Betty Lopez', 'Nurse', 'ICU', 'Evening'),
(29, 'Kevin Hill', 'Technician', 'Radiology', 'Night'),
(30, 'Helen Scott', 'Admin', 'Reception', 'Morning'),
(31, 'Brian Green', 'Nurse', 'General Ward', 'Evening'),
(32, 'Sandra Adams', 'Technician', 'Laboratory', 'Night'),
(33, 'Edward Baker', 'Admin', 'Billing', 'Morning'),
(34, 'Donna Nelson', 'Nurse', 'Surgery', 'Evening'),
(35, 'Ronald Carter', 'Technician', 'Pharmacy', 'Night');

-- Inserting Data into BillingAndPayments Table
INSERT INTO BillingAndPayments (patient_id, appointment_id, total_amount, paid_amount, payment_method, payment_status, payment_date)
VALUES
('john.doe@example.com', 1, 500.00, 500.00, 'Card', 'Paid', '2024-08-10 12:00:00'),
('jane.smith@example.com', 2, 300.00, 150.00, 'Insurance', 'Partially Paid', '2024-08-12 14:00:00'),
('alice.jones@example.com', 3, 200.00, 0.00, 'Online', 'Pending', '2024-08-13 16:00:00'),
('michael.brown@example.com', 4, 450.00, 450.00, 'Cash', 'Paid', '2024-08-14 10:00:00'),
('emily.davis@example.com', 5, 350.00, 200.00, 'Insurance', 'Partially Paid', '2024-08-15 11:00:00'),
('david.wilson@example.com', 6, 250.00, 0.00, 'Online', 'Pending', '2024-08-16 12:00:00'),
('sarah.miller@example.com', 7, 600.00, 600.00, 'Card', 'Paid', '2024-08-17 13:00:00'),
('chris.moore@example.com', 8, 400.00, 200.00, 'Insurance', 'Partially Paid', '2024-08-18 14:00:00'),
('laura.taylor@example.com', 9, 300.00, 0.00, 'Online', 'Pending', '2024-08-19 15:00:00'),
('james.anderson@example.com', 10, 700.00, 700.00, 'Card', 'Paid', '2024-08-20 16:00:00'),
('linda.thomas@example.com', 11, 500.00, 250.00, 'Insurance', 'Partially Paid', '2024-08-21 17:00:00'),
('robert.jackson@example.com', 12, 200.00, 0.00, 'Online', 'Pending', '2024-08-22 18:00:00'),
('barbara.white@example.com', 13, 800.00, 800.00, 'Card', 'Paid', '2024-08-23 19:00:00'),
('charles.harris@example.com', 14, 400.00, 200.00, 'Insurance', 'Partially Paid', '2024-08-24 20:00:00'),
('patricia.martin@example.com', 15, 300.00, 0.00, 'Online', 'Pending', '2024-08-25 21:00:00'),
('daniel.thompson@example.com', 16, 900.00, 900.00, 'Card', 'Paid', '2024-08-26 22:00:00'),
('jennifer.garcia@example.com', 17, 500.00, 250.00, 'Insurance', 'Partially Paid', '2024-08-27 23:00:00'),
('matthew.martinez@example.com', 18, 200.00, 0.00, 'Online', 'Pending', '2024-08-28 08:00:00'),
('elizabeth.robinson@example.com', 19, 1000.00, 1000.00, 'Card', 'Paid', '2024-08-29 09:00:00'),
('anthony.clark@example.com', 20, 600.00, 300.00, 'Insurance', 'Partially Paid', '2024-08-30 10:00:00'),
('susan.rodriguez@example.com', 21, 400.00, 0.00, 'Online', 'Pending', '2024-08-31 11:00:00'),
('mark.lewis@example.com', 22, 1100.00, 1100.00, 'Card', 'Paid', '2024-09-01 12:00:00'),
('mary.lee@example.com', 23, 500.00, 250.00, 'Insurance', 'Partially Paid', '2024-09-02 13:00:00'),
('paul.walker@example.com', 24, 200.00, 0.00, 'Online', 'Pending', '2024-09-03 14:00:00'),
('nancy.hall@example.com', 25, 1200.00, 1200.00, 'Card', 'Paid', '2024-09-04 15:00:00'),
('steven.allen@example.com', 26, 600.00, 300.00, 'Insurance', 'Partially Paid', '2024-09-05 16:00:00'),
('karen.young@example.com', 27, 400.00, 0.00, 'Online', 'Pending', '2024-09-06 17:00:00'),
('joshua.king@example.com', 28, 1300.00, 1300.00, 'Card', 'Paid', '2024-09-07 18:00:00'),
('betty.wright@example.com', 29, 700.00, 350.00, 'Insurance', 'Partially Paid', '2024-09-08 19:00:00'),
('kevin.lopez@example.com', 30, 400.00, 0.00, 'Online', 'Pending', '2024-09-09 20:00:00'),
('helen.hill@example.com', 31, 1400.00, 1400.00, 'Card', 'Paid', '2024-09-10 21:00:00'),
('brian.scott@example.com', 32, 800.00, 400.00, 'Insurance', 'Partially Paid', '2024-09-11 22:00:00'),
('sandra.green@example.com', 33, 400.00, 0.00, 'Online', 'Pending', '2024-09-12 23:00:00'),
('edward.adams@example.com', 34, 1500.00, 1500.00, 'Card', 'Paid', '2024-09-13 08:00:00'),
('donna.baker@example.com', 35, 900.00, 450.00, 'Insurance', 'Partially Paid', '2024-09-14 09:00:00');

-- Inserting Data into MedicineInventory Table
INSERT INTO MedicineInventory (medicine_id, medicine_name, batch_number, manufacturer, category, quantity, unit_price, expiry_date)
VALUES
(1, 'Paracetamol', 'B12345', 'MediCare Pharma', 'Tablet', 100, 0.50, '2025-12-31'),
(2, 'Amoxicillin', 'A98765', 'HealthPlus Ltd.', 'Capsule', 50, 1.20, '2025-06-30'),
(3, 'Cough Syrup', 'C67890', 'GoodHealth Co.', 'Syrup', 30, 3.75, '2024-11-30'),
(4, 'Insulin Injection', 'I54321', 'Wellness Pharma', 'Injection', 20, 25.00, '2025-04-15'),
(5, 'Antifungal Cream', 'F11122', 'SkinCare Ltd.', 'Ointment', 15, 5.99, '2025-09-10'),
(6, 'Ibuprofen', 'I12345', 'PainRelief Pharma', 'Tablet', 200, 0.75, '2025-10-31'),
(7, 'Metformin', 'M98765', 'DiabetesCare Ltd.', 'Tablet', 100, 1.50, '2025-07-30'),
(8, 'Antacid', 'A67890', 'DigestiveHealth Co.', 'Tablet', 50, 0.60, '2024-12-31'),
(9, 'Vitamin D', 'V54321', 'Wellness Pharma', 'Capsule', 40, 0.80, '2025-05-15'),
(10, 'Antibiotic Ointment', 'O11122', 'SkinCare Ltd.', 'Ointment', 25, 4.99, '2025-08-10');


-- ----------------------- Queries ------------------------

-- SIMPLE QUERY 1: To find all the Available Rooms 
SELECT 
    RoomID,
    RoomType,
    AvailabilityStatus
FROM 
    RoomsAndWards
WHERE 
    AvailabilityStatus = 'Available';

-- SIMPLE QUERY 2: Patients and their Insurance Details
SELECT 
    p.name AS PatientName,
    p.email AS PatientEmail,
    i.ProviderName AS InsuranceProvider,
    i.PolicyNumber AS PolicyNumber
FROM 
    Patient p
JOIN 
    Insurance i ON p.email = i.PatientID
ORDER BY 
    p.name;

-- SIMPLE QUERY 3: Query to find the inventory of medicines that are expiring within the next 6 months
SELECT medicine_name, batch_number, manufacturer, category, quantity, unit_price, expiry_date
FROM MedicineInventory
WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- SIMPLE QUERY 4: Query to find the total amount billed and paid by each patient
SELECT p.name AS PatientName, SUM(bp.total_amount) AS TotalBilled, SUM(bp.paid_amount) AS TotalPaid
FROM Patient p
JOIN BillingAndPayments bp ON p.email = bp.patient_id
GROUP BY p.name;

-- SIMPLE QUERY 5: GET MEDICINE STOCK DETAILS WITH LOW INVENTORY / (Inventory Management)
SELECT m.medicine_id, 
       m.medicine_name, 
       m.quantity, 
       m.expiry_date
FROM MedicineInventory m
WHERE m.quantity < 20
ORDER BY m.expiry_date ASC;

-- SIMPLE QUERY 6: GET TOTAL OUTSTANDING DUES / (Finance and Billing)
SELECT SUM(total_amount - paid_amount) AS total_due FROM BillingAndPayments WHERE payment_status != 'Paid';


-- COMPLEX QUERIES
-- Complex Query 1: [For Doctors] Fetch All Patients with Their Medical History and Assigned Rooms
SELECT 
    p.name AS PatientName,
    p.email AS PatientEmail,
    p.address AS PatientAddress,
    p.gender AS PatientGender,
    mh.conditions AS MedicalConditions,
    mh.surgeries AS Surgeries,
    mh.medication AS Medications,
    rw.RoomID,
    rw.RoomType,
    rw.AvailabilityStatus
FROM 
    Patient p
JOIN 
    PatientsFillHistory pfh ON p.email = pfh.patient
JOIN 
    MedicalHistory mh ON pfh.history = mh.id
LEFT JOIN 
    RoomsAndWards rw ON p.email = rw.AssignedPatientID
ORDER BY 
    p.name;

-- Complex Query 2: [New Patient Bookings & For Doctors] Fetch All Doctors with Their Schedules and Appointments
SELECT 
    d.name AS DoctorName,
    d.email AS DoctorEmail,
    s.day AS ScheduleDay,
    s.starttime AS ScheduleStart,
    s.endtime AS ScheduleEnd,
    s.breaktime AS BreakTime,
    a.id AS AppointmentID,
    a.date AS AppointmentDate,
    a.starttime AS AppointmentStart,
    a.endtime AS AppointmentEnd,
    a.status AS AppointmentStatus
FROM 
    Doctor d
JOIN 
    DocsHaveSchedules dhs ON d.email = dhs.doctor
JOIN 
    Schedule s ON dhs.sched = s.id
LEFT JOIN 
    Diagnose di ON d.email = di.doctor
LEFT JOIN 
    Appointment a ON di.appt = a.id
ORDER BY 
    d.name, s.day, a.date;

-- Complex Query 3: [Accounts Department] Billing Details with Patient and Appointment Information
SELECT 
    b.billing_id AS BillingID,
    b.patient_id AS PatientEmail,
    p.name AS PatientName,
    b.appointment_id AS AppointmentID,
    a.date AS AppointmentDate,
    b.total_amount AS TotalAmount,
    b.paid_amount AS PaidAmount,
    b.payment_method AS PaymentMethod,
    b.payment_status AS PaymentStatus,
    b.payment_date AS PaymentDate
FROM 
    BillingAndPayments b
JOIN 
    Patient p ON b.patient_id = p.email
JOIN 
    Appointment a ON b.appointment_id = a.id
ORDER BY 
    b.payment_date DESC;
    
-- Complex Query 4: Query to find the support staff who have worked the most shifts in the 'Emergency' department
SELECT ss.Name, ss.Role, ss.Department, COUNT(ss.Shift) AS ShiftCount
FROM SupportStaff ss
WHERE ss.Department = 'Emergency'
GROUP BY ss.Name, ss.Role, ss.Department
HAVING COUNT(ss.Shift) = (
    SELECT MAX(ShiftCount)
    FROM (
        SELECT COUNT(ss.Shift) AS ShiftCount
        FROM SupportStaff ss
        WHERE ss.Department = 'Emergency'
        GROUP BY ss.Name
    ) AS SubQuery
);

-- Complex Query 5: Query to find the doctors who have handled the most emergency cases
SELECT d.name AS DoctorName, COUNT(e.PatientID) AS EmergencyCases
FROM Doctor d
JOIN Emergency e ON d.email = e.DoctorID
GROUP BY d.name
HAVING COUNT(e.PatientID) = (
    SELECT MAX(EmergencyCases)
    FROM (
        SELECT COUNT(e.PatientID) AS EmergencyCases
        FROM Emergency e
        GROUP BY e.DoctorID
    ) AS SubQuery
);

-- Complex Query 6: Query to find the patients who have the highest total billing amount
SELECT p.name AS PatientName, SUM(bp.total_amount) AS TotalBilling
FROM Patient p
JOIN BillingAndPayments bp ON p.email = bp.patient_id
GROUP BY p.name
HAVING SUM(bp.total_amount) = (
    SELECT MAX(TotalBilling)
    FROM (
        SELECT SUM(bp.total_amount) AS TotalBilling
        FROM BillingAndPayments bp
        GROUP BY bp.patient_id
    ) AS SubQuery
);

-- Complex Query 7: Identify Patients with Appointments and Their Prescribed Medications
-- Purpose - This query gives a complete clinical snapshot: who visited, when, which doctor diagnosed them, and what was prescribed.

SELECT 
    p.name AS PatientName,
    a.date AS AppointmentDate,
    d.name AS DoctorName,
    dg.diagnosis,
    dg.prescription
FROM PatientsAttendAppointments paa
JOIN Appointment a ON paa.appt = a.id
JOIN Patient p ON paa.patient = p.email
JOIN Diagnose dg ON a.id = dg.appt
JOIN Doctor d ON dg.doctor = d.email
ORDER BY a.date DESC;

-- Complex Query 8: List Doctors Who Viewed Histories of Patients Prescribed Specific Medicines
-- Purpose - Finds doctors who are actively using patient history + medication knowledge when diagnosing.

SELECT DISTINCT 
    d.name AS DoctorName,
    d.email AS DoctorEmail,
    mh.id AS MedicalHistoryID,
    mh.medication
FROM DoctorViewsHistory dvh
JOIN Doctor d ON dvh.doctor = d.email
JOIN MedicalHistory mh ON dvh.history = mh.id
WHERE mh.medication IN (
    SELECT DISTINCT prescription
    FROM Diagnose
    WHERE prescription IN (
        SELECT medicine_name
        FROM MedicineInventory
    )
);

-- Complex Query 9: Insurance Providers Covering the Highest Total Billing Amounts
-- Purpose - Finds top 5 insurance providers by total hospital billing amount.

SELECT 
    i.ProviderName,
    COUNT(DISTINCT bp.billing_id) AS NumberOfBills,
    SUM(bp.total_amount) AS TotalBilled
FROM Insurance i
JOIN Patient p ON i.PatientID = p.email
JOIN BillingAndPayments bp ON p.email = bp.patient_id
GROUP BY i.ProviderName
ORDER BY TotalBilled DESC
LIMIT 5;

-- Complex Query 10: LIST PATIENTS WITH PENDING PAYMENTS AND OUTSTANDING DUES / (Finance and Billing)
SELECT p.email AS PatientEmail, 
       p.name AS PatientName, 
       b.total_amount, 
       b.paid_amount, 
       (b.total_amount - b.paid_amount) AS OutstandingAmount
FROM Patient p
JOIN BillingAndPayments b ON p.email = b.patient_id
WHERE b.payment_status = 'Pending';

-- Complex Query 11: RETRIEVE BOTH OCCUPIED AND UNOCCUPIED ROOMS WITH ASSIGNED PATIENTS / (Hospital Admin/Patient Management)
SELECT r.RoomID, 
       r.RoomType, 
       r.AvailabilityStatus,
       IF(p.name IS NULL, 'Unassigned', p.name) AS PatientName
FROM RoomsAndWards r
LEFT JOIN Patient p ON r.AssignedPatientID = p.email;

-- Complex Query 12: RETRIEVE PATIENT DETAILS WITH LATEST APPOINTMENT INFORMATION / (Patient Scheduling)
SELECT p.email AS PatientEmail, 
       p.name AS PatientName, 
       a.date AS AppointmentDate, 
       a.starttime AS StartTime, 
       a.status AS AppointmentStatus
FROM Patient p
LEFT JOIN PatientsAttendAppointments paa ON p.email = paa.patient
LEFT JOIN Appointment a ON paa.appt = a.id
ORDER BY a.date DESC;

-- Calls --------------------------------

-- STORED PROCEDURES 

-- CHINTAN' WORK
-- PROCEDURE 1: Schedule an Appointment
-- USE CASE: Book an appointment for a patient with a doctor.
-- Example: CALL ScheduleAppointment('john.doe@example.com', 'doc@example.com', '2025-04-01', '10:00:00', '10:30:00', 'Scheduled');

-- Scheduling an appointment
CALL ScheduleAppointment('john.doe@example.com', 'dr.jane@example.com', '2025-05-27', '12:00:00', '12:30:00', 'Scheduled');

-- PROCEDURE 2: Process Payment
-- USE CASE: Update a patient's billing record after a payment.
-- Example: CALL ProcessPayment('john.doe@example.com', 101, 50.00, 'Card');

-- Processing Payment
CALL ProcessPayment('jane.smith@example.com', 2, 150.00, 'Card');

-- KHUSHI'S WORK
-- PROCEDURE 3: Generate a billing statement for a given appointment, including patient details, appointment information, diagnosis, prescription, and a placeholder for billing details.

CALL GenerateBillingStatement(1);

-- PROCEDURE 4: Transfers a patient from their current room to a new room, updating the RoomsAndWards table accordingly

-- CALL TransferPatientRoom('alice.jones@example.com', the_new_room_id);
CALL TransferPatientRoom('alice.jones@example.com', 102);

-- Assuming RoomID 103 is occupied
CALL TransferPatientRoom('john.doe@example.com', 103);

-- SACHIN'S WORK
-- Procedure 5: AdmitEmergencyPatient
-- Purpose: Handles the admission workflow of an emergency patient, assigning a doctor, logging the emergency, and allocating an available ICU room.
-- Use Case: Used by the emergency intake system to manage urgent admissions efficiently in one transaction.

-- 👇 Sample CALL to AdmitEmergencyPatient
CALL AdmitEmergencyPatient('john.doe@example.com', 'Severe chest pain and shortness of breath', 'dr.sandra@example.com');

-- Procedure 6: UpdateOrCreateInsuranceRecord
-- Purpose: Validates if the insurance record exists for a patient. If yes → update, if not → create.
-- Use Case: Robust insurance record management across billing, registration, or policy update systems.


-- 👇 Sample CALLs to UpdateOrCreateInsuranceRecord
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'BlueCross', 'POL123456'); -- insert
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'Aetna', 'POL999999'); -- update

-- VIYANK'S WORK
-- PROCEDURE 7: GenerateFinalBill
-- Purpose: Calculates final bill for a given patient by summing up unpaid charges and applying insurance if applicable.
-- Input:  patient_email VARCHAR(50): Email ID of the patient whose final bill is to be generated.
-- Output: Prints total outstanding payment by the patient after considering insurance coverage.

-- Procedure Call
CALL GenerateFinalBill('alice.jones@example.com');

-- PROCEDURE 8: DischargePatient
-- Purpose: Handles full discharge of a patient, finalizes billing, frees assigned room.
-- Input: patient_email VARCHAR(50): Email ID of the patient to be discharged.
-- Output: Updates payment status and room assignment.


-- Example: Discharge the patient with email 'mike.patient@hospital.com'
CALL DischargePatient('mike.patient@hospital.com');


-- FUNCTIONS:-

-- CHINTAN' WORK

-- FUNCTION 1: Get Available Doctor Schedule
-- USE CASE: Fetch a doctor's availability on a given day.
-- Example: SELECT GetDoctorAvailability('doctor@example.com', 'Monday');

-- Function Call
SELECT GetDoctorAvailability('dr.amy@example.com', 'Sunday');

-- FUNCTION 2: Get Medicine Stock Level
-- USE CASE: Fetch the current available quantity of a specific medicine from the inventory.
-- Example: SELECT GetMedicineStockLevel('Paracetamol');

-- Function Call
SELECT GetMedicineStockLevel('Paracetamol') AS AvailableStock;

-- KHUSHI'S WORK

-- FUNCTION 3: Function to calculate Outstanding Balance

SELECT CalculateBalance('alice.jones@example.com');

-- FUNCTION 4: Function to calculate the total cost of medicines prescribed to a patient during a specific appointment 

SELECT CalculatePrescribedMedicineCost('alice.jones@example.com', 102);

-- SACHIN'S WORK

-- Function 5: GetPatientEmergencyVisitCount
-- Purpose: Returns how many times a patient has been to the Emergency Room.
-- Use Case: Helps flag frequent visitors, potentially for case management or alerts.

-- 👇 Sample SELECT using GetPatientEmergencyVisitCount
SELECT GetPatientEmergencyVisitCount('john.doe@example.com') AS EmergencyVisits;

-- Function 6: IsInsuranceValid
-- Purpose: Returns 'Yes' if a patient has valid insurance; 'No' otherwise.
-- Use Case: Useful inside conditions for billing workflows or eligibility checks.

-- 👇 Sample SELECT using IsInsuranceValid
SELECT IsInsuranceValid('john.doe@example.com') AS InsuranceStatus;

-- VIYANK'S WORK

-- Function 7: Calculate percentage of scheduled time used in appointments.
-- It calculates the percentage of a doctor’s scheduled time that is actually used for patient appointments. By comparing total scheduled time and actual appointment time, this function can help in optimizing schedules.
-- Input: doctor_email (VARCHAR)
-- Output: DECIMAL(5,2) - Utilization percentage


SELECT GetDoctorUtilization('dr.jane@hospital.com') AS utilization_percentage;

-- Function 8: Calculate total unpaid amount for a patient.
-- Input: patient_email (VARCHAR)
-- Output: DECIMAL(10,2) - Total outstanding balance

-- Example: Get outstanding balance for patient with email 'patient.mike@hospital.com'
SELECT CalculateOutstandingBalance('patient.mike@hospital.com') AS pending_dues;

-- TRIGGERS:- 

-- CHINTAN' WORK

-- Trigger 1:
/*
RoomsAndWards table with:
	•	RoomID
	•	AvailabilityStatus
	•	AssignedPatientID

Trigger to:
	•	Set AvailabilityStatus to ‘Occupied’ when AssignedPatientID is updated (i.e., a patient is assigned).
	•	Set AvailabilityStatus to ‘Available’ when AssignedPatientID is set to NULL (i.e., patient discharged).
*/

-- Example cases:

-- 1. Assign a patient to Room 101
UPDATE RoomsAndWards
SET AssignedPatientID = 'john.doe@example.com'
WHERE RoomID = 101;

-- Now, the trigger will automatically set AvailabilityStatus = 'Occupied'.

-- 2. Discharge a patient from Room 101
UPDATE RoomsAndWards
SET AssignedPatientID = NULL
WHERE RoomID = 101;

-- Now, the trigger will automatically set AvailabilityStatus = 'Available'.

-- Trigger 2:
/*
Appointment table with:
    • id
    • date
    • status

Trigger to:
    • Set status to 'Completed' when the appointment date is in the past
    • Only if the current status is 'Scheduled' to avoid overwriting manually updated statuses
*/

-- Example: Removes backlog scheduled appointments

-- Dummy update on an old appointment
UPDATE Appointment
SET starttime = starttime -- no change, just triggers the event
WHERE id = 105;

-- KHUSHI'S WORK

-- Trigger 3: Trigger to prevent the quantity of a medicine from being reduced if it has expired.

   UPDATE MedicineInventory
   SET
       quantity = quantity - 5  -- Attempt to dispense 5 units
   WHERE
       medicine_id = 301;
       
-- Trigger 4: Trigger to automatically update the payment_status in the BillingAndPayments table.
   
      UPDATE BillingAndPayments
   SET
       paid_amount = 30.00
   WHERE
       billing_id = 102;
       
SELECT * FROM BillingAndPayments WHERE billing_id = 102;

-- SACHIN'S WORK

-- Trigger 5: after_emergency_insert_log_returning_patient
-- Purpose: Automatically logs a note in a new table called EmergencyVisitLog when a patient visits the emergency room more than once.
-- Why it matters: Hospitals often track repeat ER visitors for follow-up care or case management.

-- First create the log table

-- Test Trigger: after_emergency_insert_log_returning_patient
-- First time – should not trigger log
CALL AdmitEmergencyPatient('jane.doe@example.com', 'High fever', 'dr.james@example.com');

-- Second time – should trigger log
CALL AdmitEmergencyPatient('jane.doe@example.com', 'Dizziness', 'dr.james@example.com');

-- Verify trigger log
SELECT * FROM EmergencyVisitLog WHERE PatientID = 'jane.doe@example.com';

-- Trigger 6: after_schedule_delete_cleanup_access
-- Purpose: When a doctor’s schedule is removed, this trigger revokes their access to patient histories.
-- Why it matters: Ensures access control and maintains patient confidentiality.

-- Test Trigger: after_schedule_delete_cleanup_access
-- Step 1: Grant access to a doctor
CALL AssignDoctorScheduleAndHistoryView('dr.miller@example.com', 3, 202);

-- Step 2: Verify doctor has access
SELECT * FROM DoctorViewsHistory WHERE doctor = 'dr.miller@example.com';

-- Step 3: Remove schedule (will trigger automatic access removal)
DELETE FROM DocsHaveSchedules WHERE doctor = 'dr.miller@example.com' AND sched = 3;

-- Step 4: Verify access is revoked
SELECT * FROM DoctorViewsHistory WHERE doctor = 'dr.miller@example.com';

-- VIYANK'S WORK

-- Trigger 7:
-- BeforeInsert_BillingValidation
-- Purpose: Prevent inserting billing records where paid_amount exceeds total_amount.
-- Timing: BEFORE INSERT
-- Table: BillingAndPayments

-- Trigger to ensure no overpayment occurs in BillingAndPayments

-- This should FAIL because paid_amount > total_amount
INSERT INTO BillingAndPayments (billing_id, paid_amount, total_amount, payment_status)
VALUES (1, 120, 100, 'Pending');
-- This should SUCCEED
INSERT INTO BillingAndPayments (billing_id, paid_amount, total_amount, payment_status)
VALUES (2, 80, 100, 'Pending');

--  Trigger 8: AfterUpdate_PaymentCompletedLog
-- Purpose: Log when a payment status changes to 'Paid'.
-- Timing: AFTER UPDATE
-- Table: BillingAndPayments


-- Trigger to log status changes to Paid

-- Insert initial billing record
INSERT INTO BillingAndPayments (billing_id, paid_amount, total_amount, payment_status)
VALUES (3, 50, 100, 'Pending');
-- Update to trigger the AFTER UPDATE trigger
UPDATE BillingAndPayments
SET payment_status = 'Paid'
WHERE billing_id = 3;
-- should show a log entry is created
SELECT * FROM PaymentLogs;
