-- ============================
-- STORED PROCEDURES
-- ============================

-- 1. Add New Patient
DELIMITER //
CREATE PROCEDURE AddNewPatient(
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


-- 2. Schedule an Appointment
DELIMITER //
CREATE PROCEDURE ScheduleAppointment(
    IN p_date DATE,
    IN p_starttime TIME,
    IN p_endtime TIME
)
BEGIN
    INSERT INTO Appointment (date, starttime, endtime)
    VALUES (p_date, p_starttime, p_endtime);
END //
DELIMITER ;


-- 3. Assign Room to Patient
DELIMITER //
CREATE PROCEDURE AssignRoom(
    IN p_patient_email VARCHAR(50),
    IN p_room_id INT
)
BEGIN
    UPDATE RoomsAndWards
    SET AssignedPatientID = p_patient_email, AvailabilityStatus = 'Occupied'
    WHERE RoomID = p_room_id;
END //
DELIMITER ;


-- 4. Record Diagnosis
DELIMITER //
CREATE PROCEDURE RecordDiagnosis(
    IN p_appt INT,
    IN p_doctor_email VARCHAR(50),
    IN p_diagnosis VARCHAR(255),
    IN p_prescription VARCHAR(255)
)
BEGIN
    INSERT INTO Diagnose (appt, doctor, diagnosis, prescription)
    VALUES (p_appt, p_doctor_email, p_diagnosis, p_prescription);
END //
DELIMITER ;


-- 5. Update Payment Status
DELIMITER //
CREATE PROCEDURE UpdatePaymentStatus(
    IN p_billing_id INT,
    IN p_paid_amount DECIMAL(10,2)
)
BEGIN
    UPDATE BillingAndPayments
    SET paid_amount = paid_amount + p_paid_amount,
        payment_status = CASE WHEN paid_amount + p_paid_amount >= total_amount THEN 'Paid' ELSE 'Partially Paid' END
    WHERE billing_id = p_billing_id;
END //
DELIMITER ;


-- ============================
-- FUNCTIONS
-- ============================

-- 1. Calculate Outstanding Balance
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


-- 2. Get Patient's Appointment Count
DELIMITER //
CREATE FUNCTION GetAppointmentCount(p_patient_email VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE appt_count INT;

    SELECT COUNT(*) INTO appt_count
    FROM PatientsAttendAppointments
    WHERE patient = p_patient_email;

    RETURN appt_count;
END //
DELIMITER ;


-- 3. Check Room Availability
DELIMITER //
CREATE FUNCTION CheckRoomAvailability(p_room_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE room_status VARCHAR(20);

    SELECT AvailabilityStatus INTO room_status
    FROM RoomsAndWards
    WHERE RoomID = p_room_id;

    RETURN room_status;
END //
DELIMITER ;
