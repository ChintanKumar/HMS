-- STORED PROCEDURES

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

-- Scheduling an appointment
CALL ScheduleAppointment('john.doe@example.com', 'dr.jane@example.com', '2025-04-25', '10:00:00', '10:30:00', 'Scheduled');

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

-- Processing Payment
CALL ProcessPayment('john.doe@example.com', 101, 50.00, 'Card');

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
    JOIN Appointment a ON paa.appt = p_appointment_id
    LEFT JOIN Diagnose d ON a.id = d.appt
    WHERE a.id = p_appointment_id;

    -- You would typically add logic here to calculate charges based on services, medicines, etc.
    -- For simplicity, we'll just display a placeholder for now.
    SELECT '--- BILLING DETAILS ---' AS BillingHeader;
    SELECT 'Consultation Fee' AS Item, 50.00 AS Amount; -- Example charge
    SELECT 'Medication Cost (if applicable)' AS Item, 0.00 AS Amount; -- Placeholder
    SELECT '--- END OF STATEMENT ---' AS BillingFooter;

END //
DELIMITER ;

CALL GenerateBillingStatement(1);

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

-- CALL TransferPatientRoom('alice.jones@example.com', the_new_room_id);
CALL TransferPatientRoom('alice.jones@example.com', 102);

-- Assuming RoomID 103 is occupied
CALL TransferPatientRoom('john.doe@example.com', 103);

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

-- 👇 Sample CALL to AdmitEmergencyPatient
CALL AdmitEmergencyPatient('john.doe@example.com', 'Severe chest pain and shortness of breath', 'dr.smith@example.com');

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

-- 👇 Sample CALLs to UpdateOrCreateInsuranceRecord
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'BlueCross', 'POL123456'); -- insert
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'Aetna', 'POL999999'); -- update

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

-- Procedure Call
CALL GenerateFinalBill('john.doe@example.com');

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

-- Example: Discharge the patient with email 'mike.patient@hospital.com'
CALL DischargePatient('mike.patient@hospital.com');


-- FUNCTIONS:-

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

-- Function Call
SELECT GetDoctorAvailability('dr.jane@example.com', 'Monday');

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

-- Function Call
SELECT GetMedicineStockLevel('Paracetamol') AS AvailableStock;

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

SELECT CalculateBalance('alice.jones@example.com');

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

SELECT CalculatePrescribedMedicineCost('alice.jones@example.com', 102);

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

-- 👇 Sample SELECT using GetPatientEmergencyVisitCount
SELECT GetPatientEmergencyVisitCount('john.doe@example.com') AS EmergencyVisits;

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

-- 👇 Sample SELECT using IsInsuranceValid
SELECT IsInsuranceValid('john.doe@example.com') AS InsuranceStatus;

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

SELECT GetDoctorUtilization('dr.jane@hospital.com') AS utilization_percentage;

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

-- Example: Removes backlog scheduled appointments

-- Dummy update on an old appointment
UPDATE Appointment
SET starttime = starttime -- no change, just triggers the event
WHERE id = 105;

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

   UPDATE MedicineInventory
   SET
       quantity = quantity - 5  -- Attempt to dispense 5 units
   WHERE
       medicine_id = 301;
       
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

-- 👇 Test Trigger: after_emergency_insert_log_returning_patient
-- First time – should not trigger log
CALL AdmitEmergencyPatient('jane.doe@example.com', 'High fever', 'dr.james@example.com');

-- Second time – should trigger log
CALL AdmitEmergencyPatient('jane.doe@example.com', 'Dizziness', 'dr.james@example.com');

-- Verify trigger log
SELECT * FROM EmergencyVisitLog WHERE PatientID = 'jane.doe@example.com';

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

-- 👇 Test Trigger: after_schedule_delete_cleanup_access
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
- 1) BeforeInsert_BillingValidation
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

-- Insert initial billing record
INSERT INTO BillingAndPayments (billing_id, paid_amount, total_amount, payment_status)
VALUES (3, 50, 100, 'Pending');
-- Update to trigger the AFTER UPDATE trigger
UPDATE BillingAndPayments
SET payment_status = 'Paid'
WHERE billing_id = 3;
-- should show a log entry is created
SELECT * FROM PaymentLogs;
