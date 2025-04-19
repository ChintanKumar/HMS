-- Sachin's STORED PROCEDURES

-- Procedure 1: AdmitEmergencyPatient
-- Purpose: Handles the admission workflow of an emergency patient, assigning a doctor, logging the emergency, and allocating an available ICU room.
-- Use Case: Used by the emergency intake system to manage urgent admissions efficiently in one transaction.

DELIMITER //

CREATE PROCEDURE AdmitEmergencyPatient(
    IN patient_email VARCHAR(50),
    IN condition_text TEXT,
    IN doctor_email VARCHAR(50)
)
BEGIN
    DECLARE room_id INT;

    -- Step 1: Log Emergency
    INSERT INTO Emergency (PatientID, PatientCondition, DoctorID)
    VALUES (patient_email, condition_text, doctor_email);

    -- Step 2: Find Available ICU Room
    SELECT RoomID INTO room_id
    FROM RoomsAndWards
    WHERE RoomType = 'ICU' AND AvailabilityStatus = 'Available'
    LIMIT 1;

    -- Step 3: Assign Room (if available)
    IF room_id IS NOT NULL THEN
        UPDATE RoomsAndWards
        SET AvailabilityStatus = 'Occupied',
            AssignedPatientID = patient_email
        WHERE RoomID = room_id;
    END IF;
END //

DELIMITER ;

-- 👇 Sample CALL to AdmitEmergencyPatient
CALL AdmitEmergencyPatient('john.doe@example.com', 'Severe chest pain and shortness of breath', 'dr.smith@example.com');



-- Procedure 2: AssignDoctorScheduleAndHistoryView
-- Purpose: Assigns a new schedule to a doctor and grants access to a medical history record simultaneously.
-- Use Case: Used during onboarding of a new doctor to set their schedule and give them access to a relevant patient history.

DELIMITER //

CREATE PROCEDURE AssignDoctorScheduleAndHistoryView(
    IN doctor_email VARCHAR(50),
    IN sched_id INT,
    IN history_id INT
)
BEGIN
    -- Assign Schedule
    INSERT INTO DocsHaveSchedules (sched, doctor)
    VALUES (sched_id, doctor_email);

    -- Grant History View Access
    INSERT INTO DoctorViewsHistory (history, doctor)
    VALUES (history_id, doctor_email);
END //

DELIMITER ;

-- 👇 Sample CALL to AssignDoctorScheduleAndHistoryView
CALL AssignDoctorScheduleAndHistoryView('dr.smith@example.com', 2, 101);



-- Procedure 3: UpdateOrCreateInsuranceRecord
-- Purpose: Validates if the insurance record exists for a patient. If yes → update, if not → create.
-- Use Case: Robust insurance record management across billing, registration, or policy update systems.

DELIMITER //

CREATE PROCEDURE UpdateOrCreateInsuranceRecord(
    IN patient_email VARCHAR(50),
    IN provider_name VARCHAR(255),
    IN policy_no VARCHAR(50)
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Insurance WHERE PatientID = patient_email
    ) THEN
        UPDATE Insurance
        SET ProviderName = provider_name,
            PolicyNumber = policy_no
        WHERE PatientID = patient_email;
    ELSE
        INSERT INTO Insurance (PatientID, ProviderName, PolicyNumber)
        VALUES (patient_email, provider_name, policy_no);
    END IF;
END //

DELIMITER ;

-- 👇 Sample CALLs to UpdateOrCreateInsuranceRecord
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'BlueCross', 'POL123456'); -- insert
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'Aetna', 'POL999999'); -- update



-- Sachin's STORED FUNCTIONS

-- Function 1: GetPatientEmergencyVisitCount
-- Purpose: Returns how many times a patient has been to the Emergency Room.
-- Use Case: Helps flag frequent visitors, potentially for case management or alerts.

DELIMITER //

CREATE FUNCTION GetPatientEmergencyVisitCount(p_email VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE visit_count INT;

    SELECT COUNT(*) INTO visit_count
    FROM Emergency
    WHERE PatientID = p_email;

    RETURN visit_count;
END //

DELIMITER ;

-- 👇 Sample SELECT using GetPatientEmergencyVisitCount
SELECT GetPatientEmergencyVisitCount('john.doe@example.com') AS EmergencyVisits;



-- Function 2: GetDoctorDailyScheduleCount
-- Purpose: Returns the number of days a doctor is scheduled in a week.
-- Use Case: Used in dashboard metrics or workload balancing systems.

DELIMITER //

CREATE FUNCTION GetDoctorDailyScheduleCount(doc_email VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE count_days INT;

    SELECT COUNT(DISTINCT s.day) INTO count_days
    FROM DocsHaveSchedules dhs
    JOIN Schedule s ON dhs.sched = s.id
    WHERE dhs.doctor = doc_email;

    RETURN count_days;
END //

DELIMITER ;

-- 👇 Sample SELECT using GetDoctorDailyScheduleCount
SELECT GetDoctorDailyScheduleCount('dr.smith@example.com') AS ScheduledDays;



-- Function 3: IsInsuranceValid
-- Purpose: Returns 'Yes' if a patient has valid insurance; 'No' otherwise.
-- Use Case: Useful inside conditions for billing workflows or eligibility checks.

DELIMITER //

CREATE FUNCTION IsInsuranceValid(p_email VARCHAR(50))
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    DECLARE has_insurance INT;

    SELECT COUNT(*) INTO has_insurance
    FROM Insurance
    WHERE PatientID = p_email;

    RETURN IF(has_insurance > 0, 'Yes', 'No');
END //

DELIMITER ;

-- 👇 Sample SELECT using IsInsuranceValid
SELECT IsInsuranceValid('john.doe@example.com') AS InsuranceStatus;



-- Sachin's Triggers

-- Trigger Name: after_emergency_insert_log_returning_patient
-- Purpose: Automatically logs a note in a new table called EmergencyVisitLog when a patient visits the emergency room more than once.
-- Why it matters: Hospitals often track repeat ER visitors for follow-up care or case management.

-- First create the log table
CREATE TABLE IF NOT EXISTS EmergencyVisitLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID VARCHAR(50),
    VisitCount INT,
    Note TEXT,
    LoggedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Now the trigger
DELIMITER //

CREATE TRIGGER after_emergency_insert_log_returning_patient
AFTER INSERT ON Emergency
FOR EACH ROW
BEGIN
    DECLARE count_visits INT;

    SELECT COUNT(*) INTO count_visits
    FROM Emergency
    WHERE PatientID = NEW.PatientID;

    IF count_visits > 1 THEN
        INSERT INTO EmergencyVisitLog (PatientID, VisitCount, Note)
        VALUES (
            NEW.PatientID,
            count_visits,
            CONCAT('Patient has visited emergency room ', count_visits, ' times.')
        );
    END IF;
END //

DELIMITER ;

-- 👇 Test Trigger: after_emergency_insert_log_returning_patient
-- First time – should not trigger log
CALL AdmitEmergencyPatient('jane.doe@example.com', 'High fever', 'dr.james@example.com');

-- Second time – should trigger log
CALL AdmitEmergencyPatient('jane.doe@example.com', 'Dizziness', 'dr.james@example.com');

-- Verify trigger log
SELECT * FROM EmergencyVisitLog WHERE PatientID = 'jane.doe@example.com';



-- Trigger Name: after_schedule_delete_cleanup_access
-- Purpose: When a doctor’s schedule is removed, this trigger revokes their access to patient histories.
-- Why it matters: Ensures access control and maintains patient confidentiality.

DELIMITER //

CREATE TRIGGER after_schedule_delete_cleanup_access
AFTER DELETE ON DocsHaveSchedules
FOR EACH ROW
BEGIN
    DELETE FROM DoctorViewsHistory
    WHERE doctor = OLD.doctor;
END //

DELIMITER ;

-- 👇 Test Trigger: after_schedule_delete_cleanup_access
-- Step 1: Grant access to a doctor
CALL AssignDoctorScheduleAndHistoryView('dr.miller@example.com', 3, 202);

-- Step 2: Verify doctor has access
SELECT * FROM DoctorViewsHistory WHERE doctor = 'dr.miller@example.com';

-- Step 3: Remove schedule (will trigger automatic access removal)
DELETE FROM DocsHaveSchedules WHERE doctor = 'dr.miller@example.com' AND sched = 3;

-- Step 4: Verify access is revoked
SELECT * FROM DoctorViewsHistory WHERE doctor = 'dr.miller@example.com';
