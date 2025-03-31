-- STORED PROCEDURES by Sachin Pant 

-- Procedure 1: AddPatientAppointment

-- Purpose: Adding a new patient appointment with concerns and symptoms involves multiple insertions and checks. This encapsulates that logic in a reusable block.

-- Use Case: Doctors/admins use this when scheduling a new appointment and recording patient's visit reason at once.


DELIMITER //

CREATE PROCEDURE AddPatientAppointment(
    IN p_email VARCHAR(50),
    IN a_date DATE,
    IN a_start TIME,
    IN a_end TIME,
    IN concerns VARCHAR(255),
    IN symptoms VARCHAR(255)
)
BEGIN
    DECLARE appt_id INT;

    -- Insert into Appointment
    INSERT INTO Appointment (date, starttime, endtime)
    VALUES (a_date, a_start, a_end);

    SET appt_id = LAST_INSERT_ID();

    -- Insert into PatientsAttendAppointments
    INSERT INTO PatientsAttendAppointments (patient, appt, concerns, symptoms)
    VALUES (p_email, appt_id, concerns, symptoms);
END //

DELIMITER ;


-- Procedure 2: UpdateMedicineStock

-- Purpose: Frequently required to restock medicines or adjust inventory due to consumption or expiry. This centralizes logic and improves consistency.

-- Use Case: Used by the pharmacy staff or inventory system to quickly update stocks.

DELIMITER //

CREATE PROCEDURE UpdateMedicineStock(
    IN med_id INT,
    IN new_quantity INT
)
BEGIN
    UPDATE MedicineInventory
    SET quantity = new_quantity
    WHERE medicine_id = med_id;
END //

DELIMITER ;


-- Procedure 3: AssignInsuranceToPatient

-- Purpose: A patient may not have insurance initially. This procedure safely assigns or updates insurance details.

-- Use Case: Useful at patient registration or when a new insurance policy is provided.

DELIMITER //

CREATE PROCEDURE AssignInsuranceToPatient(
    IN patient_email VARCHAR(50),
    IN provider VARCHAR(255),
    IN policy_no VARCHAR(50)
)
BEGIN
    INSERT INTO Insurance (PatientID, ProviderName, PolicyNumber)
    VALUES (patient_email, provider, policy_no)
    ON DUPLICATE KEY UPDATE 
        ProviderName = VALUES(ProviderName),
        PolicyNumber = VALUES(PolicyNumber);
END //

DELIMITER ;





