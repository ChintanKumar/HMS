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

-- Function Call
SELECT GetDoctorAvailability('dr.jane@example.com', 'Monday');

-- FUNCTION: Get Medicine Stock Level
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