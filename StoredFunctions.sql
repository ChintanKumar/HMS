------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) Calculate percentage of scheduled time used in appointments.
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


-- Example: Check utilization for Doctor ID 102
SELECT GetDoctorUtilization(102) AS utilization_percentage;
------------------------------------------------------------------------------------------------------------------------------------------------
-- 2) Calculate the total billing amount for a specific patient.
-- Input: patient_email (the patient’s unique email ID).
-- Output: Returns the total sum of all billing amounts (total_amount) for the given patient.
    
CREATE FUNCTION CalculateTotalBillingAmount(patient_email VARCHAR(50))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    -- Sum total billing amount for the given patient
    SELECT SUM(total_amount) INTO total
    FROM BillingAndPayments
    WHERE patient_id = patient_email;
    
    -- Return the total billing amount
    RETURN total;
END;

------------------------------------------------------------------------------------------------------------------------------------------------
-- 3) Calculate total unpaid amount for a patient.
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


-- Example: Get outstanding balance for Patient ID 205
SELECT CalculateOutstandingBalance(205) AS pending_dues;
------------------------------------------------------------------------------------------------------------------------------------------------
-- 4) Count number of appointments paid through insurance.
-- Input: patient_email (VARCHAR)
-- Output: INT - Number of insured appointments

CREATE FUNCTION CheckInsuranceCoverage(patient_email VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    -- Declare variable to store count of insured appointments
    DECLARE covered_count INT;

    -- Count all billing records where payment method is 'Insurance'
    SELECT COUNT(*) INTO covered_count
    FROM BillingAndPayments B
    JOIN Insurance I ON B.patient_id = I.PatientID
    WHERE B.patient_id = patient_email AND B.payment_method = 'Insurance';

    -- Return the count
    RETURN covered_count;
END;

------------------------------------------------------------------------------------------------------------------------------------------------
-- 5) Check if a specific medicine is available in stock.
-- Input: medicine_name (VARCHAR)
-- Output: BOOLEAN - TRUE if available, FALSE otherwise


CREATE FUNCTION IsMedicineInStock(medicine_name VARCHAR(100))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    -- Declare boolean variable to hold availability status
    DECLARE is_available BOOLEAN;

    -- Check if any quantity of the specified medicine exists
    SELECT quantity > 0 INTO is_available
    FROM MedicineInventory
    WHERE medicine_name = medicine_name
    LIMIT 1;

    -- Return TRUE if available, otherwise FALSE
    RETURN IFNULL(is_available, FALSE);
END;

------------------------------------------------------------------------------------------------------------------------------------------------








