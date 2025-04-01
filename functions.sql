-- FUNCTION: Get Available Doctor Schedule
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