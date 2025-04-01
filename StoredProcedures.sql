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
