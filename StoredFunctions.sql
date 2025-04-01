-- Purpose: This function returns the total billing amount for a specific patient.
-- Input: patient_email (the patient’s unique email ID).
-- Output: Returns the total sum of all billing amounts (total_amount) for the given patient.



DELIMITER //

CREATE FUNCTION CalculateTotalBillingAmount(patient_email VARCHAR(50))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    
    -- Sum total billing amount for the given patient
    SELECT SUM(total_amount) INTO total
    FROM BillingAndPayments
    WHERE patient_id = patient_email;
    
    -- Return the total billing amount
    RETURN total;
END //

DELIMITER ;
