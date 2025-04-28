-- Trigger 1 --------------------
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



-- Trigger 2 --------------------
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

