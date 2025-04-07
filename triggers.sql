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