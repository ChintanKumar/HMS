-- 1) BeforeInsert_BillingValidation
-- Purpose: Prevent inserting billing records where paid_amount exceeds total_amount.
-- Timing: BEFORE INSERT
-- Table: BillingAndPayments

-- Trigger to ensure no overpayment occurs in BillingAndPayments
DELIMITER $$

CREATE TRIGGER BeforeInsert_BillingValidation
BEFORE INSERT ON BillingAndPayments
FOR EACH ROW
BEGIN
  -- Check if paid amount is more than total amount
  IF NEW.paid_amount > NEW.total_amount THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Paid amount cannot exceed total amount.';
  END IF;
END$$

DELIMITER ;

-- This should FAIL because paid_amount > total_amount
INSERT INTO BillingAndPayments (billing_id, paid_amount, total_amount, payment_status)
VALUES (1, 120, 100, 'Pending');
-- This should SUCCEED
INSERT INTO BillingAndPayments (billing_id, paid_amount, total_amount, payment_status)
VALUES (2, 80, 100, 'Pending');
--------------------------------------------------------------------------------------------------------------------------------------------------
-- 2) AfterUpdate_PaymentCompletedLog
-- Purpose: Log when a payment status changes to 'Paid'.
-- Timing: AFTER UPDATE
-- Table: BillingAndPayments


-- Trigger to log status changes to Paid
DELIMITER $$

CREATE TRIGGER AfterUpdate_PaymentCompletedLog
AFTER UPDATE ON BillingAndPayments
FOR EACH ROW
BEGIN
  -- Check if the status changed to Paid from something else
  IF NEW.payment_status = 'Paid' AND OLD.payment_status <> 'Paid' THEN
    INSERT INTO PaymentLogs (billing_id, change_time, note)
    VALUES (NEW.billing_id, NOW(), 'Payment marked as Paid.');
  END IF;
END$$

DELIMITER ;

-- Insert initial billing record
INSERT INTO BillingAndPayments (billing_id, paid_amount, total_amount, payment_status)
VALUES (3, 50, 100, 'Pending');
-- Update to trigger the AFTER UPDATE trigger
UPDATE BillingAndPayments
SET payment_status = 'Paid'
WHERE billing_id = 3;
-- should show a log entry is created
SELECT * FROM PaymentLogs;

------------------------------------------------------------------------------------------------------------------------------------------------
-- 3) BeforeInsert_DoctorScheduleConflict
-- Purpose: Prevent overlapping shifts for the same doctor.
-- Timing: BEFORE INSERT
-- Tables: Schedule, DocsHaveSchedules

-- Trigger to prevent assigning overlapping schedule to same doctor
DELIMITER $$

CREATE TRIGGER BeforeInsert_DoctorScheduleConflict
BEFORE INSERT ON DocsHaveSchedules
FOR EACH ROW
BEGIN
  -- Check if doctor already has a schedule with same shift timing
  IF EXISTS (
    SELECT 1 FROM Schedule s
    JOIN DocsHaveSchedules d ON s.id = d.sched
    WHERE d.doctor = NEW.doctor AND s.day = (
      SELECT day FROM Schedule WHERE id = NEW.sched
    )
    AND (
      (s.starttime < (SELECT endtime FROM Schedule WHERE id = NEW.sched) AND
       s.endtime > (SELECT starttime FROM Schedule WHERE id = NEW.sched))
    )
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Doctor already has a conflicting schedule.';
  END IF;
END$$

DELIMITER ;

-- Insert doctor-schedule mapping
INSERT INTO DocsHaveSchedules (doctor, sched)
VALUES (1, 1); -- Suppose Schedule ID 1 is Mon 9AM-12PM
-- Try to assign overlapping schedule
INSERT INTO DocsHaveSchedules (doctor, sched)
VALUES (1, 2); -- Suppose Schedule ID 2 is Mon 11AM-2PM → Overlaps 9AM-12PM
------------------------------------------------------------------------------------------------------------------------------------------------

