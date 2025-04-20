-- 1. Generate a billing statement for a given appointment, including patient details, appointment information, diagnosis, prescription, and a placeholder for billing details.
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

-------------

--  2. Transfers a patient from their current room to a new room, updating the RoomsAndWards table accordingly

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