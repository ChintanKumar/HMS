-------------------------------------------------------------------------------------------------------------------------------------------------
-- NEWLY ADDED STORED PROCEDURES
-------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) GenerateFinalBill
-- Purpose: Calculates final bill for a given patient by summing up unpaid charges and applying insurance if applicable.
-- Input:  patient_email VARCHAR(50): Email ID of the patient whose final bill is to be generated.
-- Output: Prints total outstanding payment by the patient after considering insurance coverage.

CREATE PROCEDURE GenerateFinalBill(IN patient_email VARCHAR(50))
BEGIN
    -- Declare variable to store total unpaid amount
    DECLARE unpaid_total DECIMAL(10,2) DEFAULT 0;

    -- Declare variable to store count of appointments covered by insurance
    DECLARE insurance_covered_appointments INT DEFAULT 0;

    -- Calculate total unpaid amount for patient
    SELECT SUM(total_amount - paid_amount)
    INTO unpaid_total
    FROM BillingAndPayments
    WHERE patient_id = patient_email AND payment_status != 'Paid';

    -- Count how many appointments are covered by insurance
    SELECT COUNT(*)
    INTO insurance_covered_appointments
    FROM Insurance i
    JOIN Patient p ON p.email = i.PatientID
    JOIN BillingAndPayments b ON b.patient_id = p.email
    WHERE p.email = patient_email;

    -- Apply a discount for insurance-covered appointments 
    IF insurance_covered_appointments > 0 THEN
        SET unpaid_total = unpaid_total * 0.8;  -- Applying 20% coverage from insurance
    END IF;

    -- Return the final amount
    SELECT unpaid_total AS Final_Amount_To_Pay;
END;

----------------------------------------------------------------------------------------------------------------------------------------------
-- 2) DischargePatient
-- Purpose: Handles full discharge of a patient, finalizes billing, frees assigned room.
-- Input: patient_email VARCHAR(50): Email ID of the patient to be discharged.
-- Output: Updates payment status and room assignment.

DELIMITER //
CREATE PROCEDURE DischargePatient(IN patient_email VARCHAR(50))
BEGIN
    -- Mark all unpaid bills as Paid
    UPDATE BillingAndPayments
    SET payment_status = 'Paid', paid_amount = total_amount
    WHERE patient_id = patient_email AND payment_status != 'Paid';

    -- Set room as available for reuse
    UPDATE RoomsAndWards
    SET AvailabilityStatus = 'Available', AssignedPatientID = NULL
    WHERE AssignedPatientID = patient_email;
END;


-- Example: Discharge the patient with email 'mike.patient@hospital.com'
CALL DischargePatient('mike.patient@hospital.com');
----------------------------------------------------------------------------------------------------------------------------------------------
-- 3) HandleEmergencyAdmission
-- Purpose: Handles an emergency admission by creating an emergency record, assigning a doctor and room if available.
-- Input: patient_email VARCHAR(50): Patient's email, condition_desc TEXT: Description of emergency condition
-- Output: Inserts into Emergency table and assigns a room to patient.

DELIMITER //
CREATE PROCEDURE HandleEmergencyAdmission(
    IN patient_email VARCHAR(50),
    IN condition_desc TEXT
)
BEGIN
    DECLARE emergency_doc VARCHAR(50);
    DECLARE room_id INT;

    -- Select first available doctor
    SELECT email INTO emergency_doc
    FROM Doctor
    LIMIT 1;

    -- Select an available room
    SELECT RoomID INTO room_id
    FROM RoomsAndWards
    WHERE AvailabilityStatus = 'Available'
    LIMIT 1;

    -- Create emergency case
    INSERT INTO Emergency (PatientID, PatientCondition, DoctorID, ArrivalTime)
    VALUES (patient_email, condition_desc, emergency_doc, NOW());

    -- Assign patient to room
    UPDATE RoomsAndWards
    SET AssignedPatientID = patient_email, AvailabilityStatus = 'Occupied'
    WHERE RoomID = room_id;
END;


-- Example: Admit patient 'emily.smith@hospital.com' for an emergency condition
CALL HandleEmergencyAdmission('emily.smith@hospital.com', 'Severe abdominal pain and shortness of breath');
----------------------------------------------------------------------------------------------------------------------------------------------
-- PREVIOUSLY ADDED STORED PROCEDURES
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) STORED PROCEDURE FOR ADDING NEW BILLING RECORD 
-- Input Parameters:
-- p_patient_id: The unique email ID of the patient.
-- p_appointment_id: The ID of the appointment.
-- p_total_amount: The total bill amount.
-- p_payment_method: The payment method used.
-- p_payment_status: The payment status (Paid, Pending, Partially Paid).

CREATE PROCEDURE AddNewBilling(
    IN p_patient_id VARCHAR(50), 
    IN p_appointment_id INT, 
    IN p_total_amount DECIMAL(10,2), 
    IN p_payment_method ENUM('Cash', 'Card', 'Insurance', 'Online'), 
    IN p_payment_status ENUM('Paid', 'Pending', 'Partially Paid')
)
BEGIN
    -- Insert new billing record into BillingAndPayments table
    INSERT INTO BillingAndPayments(
        patient_id, 
        appointment_id, 
        total_amount, 
        payment_method, 
        payment_status
    )
    VALUES (p_patient_id, p_appointment_id, p_total_amount, p_payment_method, p_payment_status);
END //

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2) STORED PROCEDURE TO UPDATE PAYMENT STATUS
-- Input Parameters:
-- p_billing_id: The unique ID of the billing record to update.
-- p_payment_status: The new payment status (Paid, Pending, Partially Paid).

CREATE PROCEDURE UpdatePaymentStatus(
    IN p_billing_id INT, 
    IN p_payment_status ENUM('Paid', 'Pending', 'Partially Paid')
)
BEGIN
    -- Update the payment status for the given billing record
    UPDATE BillingAndPayments
    SET payment_status = p_payment_status
    WHERE billing_id = p_billing_id;
END //
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3) STORED PROCESURE TO ADD AN EMERGENCY CASE 
--Input Parameters:
-- p_patient_id: The patient’s unique email ID.
-- p_patient_condition: A detailed description of the patient's condition.
-- p_doctor_id: The ID of the attending doctor (Doctor's email).

CREATE PROCEDURE AddEmergencyCase(
    IN p_patient_id VARCHAR(50), 
    IN p_patient_condition TEXT, 
    IN p_doctor_id VARCHAR(50)
)
BEGIN
    -- Insert new emergency case into Emergency table
    INSERT INTO Emergency(PatientID, PatientCondition, DoctorID)
    VALUES (p_patient_id, p_patient_condition, p_doctor_id);
END //

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





