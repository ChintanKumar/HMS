-- Stored Functions by Sachin Pant

-- Function 1: GetOutstandingAmount

-- Purpose: Reusable logic for computing dues for billing.

-- Use Case: Can be used in financial dashboards or reports directly in SELECT queries.

DELIMITER //

CREATE FUNCTION GetOutstandingAmount(bill_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE outstanding DECIMAL(10,2);

    SELECT (total_amount - paid_amount)
    INTO outstanding
    FROM BillingAndPayments
    WHERE billing_id = bill_id;

    RETURN outstanding;
END //

DELIMITER ;

-- Function 2: CheckMedicineStockStatus

-- Purpose: Returns a status label ('Low', 'Normal', 'High') for better inventory insights.

-- Use Case: Inventory UI panels or alerts.

DELIMITER //

CREATE FUNCTION CheckMedicineStockStatus(med_id INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE qty INT;

    SELECT quantity INTO qty
    FROM MedicineInventory
    WHERE medicine_id = med_id;

    RETURN CASE
        WHEN qty < 20 THEN 'Low'
        WHEN qty BETWEEN 20 AND 100 THEN 'Normal'
        ELSE 'High'
    END;
END //

DELIMITER ;

 -- Function 3: GetInsuranceProviderByEmail

-- Purpose: Quickly fetch insurance provider using patient email.

-- Use Case: Used within reports or API backends for retrieving insurance data quickly.


DELIMITER //

CREATE FUNCTION GetInsuranceProviderByEmail(p_email VARCHAR(50))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE provider VARCHAR(255);

    SELECT ProviderName INTO provider
    FROM Insurance
    WHERE PatientID = p_email;

    RETURN provider;
END //

DELIMITER ;

-- Function 4: GetDoctorAppointmentsCount

-- Purpose: Count number of appointments handled by a doctor – useful for analytics and performance evaluation.

-- Use Case: Can be included in dashboards or analytic queries.

DELIMITER //

CREATE FUNCTION GetDoctorAppointmentsCount(doc_email VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE appt_count INT;

    SELECT COUNT(*)
    INTO appt_count
    FROM Diagnose
    WHERE doctor = doc_email;

    RETURN appt_count;
END //

DELIMITER ;


