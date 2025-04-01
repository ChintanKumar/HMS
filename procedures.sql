-- PROCEDURE: Register a New Patient
-- USE CASE: Add a new patient to the system.
-- Example: CALL RegisterPatient('john.doe@example.com', 'securepass', 'John Doe', '123 Elm St', 'Male');
DELIMITER //
CREATE PROCEDURE RegisterPatient(
    IN p_email VARCHAR(50),
    IN p_password VARCHAR(30),
    IN p_name VARCHAR(50),
    IN p_address VARCHAR(60),
    IN p_gender ENUM('Male', 'Female', 'Other')
)
BEGIN
    INSERT INTO Patient (email, password, name, address, gender)
    VALUES (p_email, p_password, p_name, p_address, p_gender);
END //
DELIMITER ;


-- PROCEDURE: Schedule an Appointment
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


-- PROCEDURE: Process Payment
-- USE CASE: Update a patient's billing record after a payment.
-- Example: CALL ProcessPayment('john.doe@example.com', 101, 50.00, 'Card');
DELIMITER //
CREATE PROCEDURE ProcessPayment(
    IN p_patient_id VARCHAR(50),
    IN p_appointment_id INT,
    IN p_paid_amount DECIMAL(10,2),
    IN p_payment_method ENUM('Cash', 'Card', 'Insurance', 'Online')
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