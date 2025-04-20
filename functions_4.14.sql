-- 1. Function to calculate Outstanding Balance
DELIMITER //
CREATE FUNCTION CalculateBalance(p_patient_email VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_due DECIMAL(10,2);
    DECLARE total_paid DECIMAL(10,2);

    SELECT COALESCE(SUM(total_amount), 0), COALESCE(SUM(paid_amount), 0)
    INTO total_due, total_paid
    FROM BillingAndPayments
    WHERE patient_id = p_patient_email;

    RETURN total_due - total_paid;
END //
DELIMITER ;

SELECT CalculateBalance('alice.jones@example.com');

-------

-- 2. Function to calculate the total cost of medicines prescribed to a patient during a specific appointment 

DELIMITER //
CREATE FUNCTION CalculatePrescribedMedicineCost(
    p_patient_email VARCHAR(50),
    p_appointment_id INT
) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_medicine_cost DECIMAL(10, 2);

    -- Initialize the total cost
    SET total_medicine_cost = 0.00;

    -- Select the patient's prescription from the Diagnose table for the given appointment
    SELECT
        GROUP_CONCAT(prescription) INTO @prescriptions
    FROM
        Diagnose
    WHERE
        appt = p_appointment_id;

    -- Check if there are any prescriptions
    IF @prescriptions IS NOT NULL THEN
        -- Split the prescription string into individual medicines (assuming they are comma-separated)
        SET @prescription_count = LENGTH(@prescriptions) - LENGTH(REPLACE(@prescriptions, ',', '')) + 1;
        SET @i = 1;

        WHILE @i <= @prescription_count DO
            -- Extract each medicine name
            SET @medicine_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(@prescriptions, ',', @i), ',', -1));

            -- Get the unit price of the medicine from the MedicineInventory table
            SELECT
                unit_price INTO @medicine_price
            FROM
                MedicineInventory
            WHERE
                medicine_name = @medicine_name;

            -- If the medicine is found in the inventory, add its price to the total cost
            IF @medicine_price IS NOT NULL THEN
                SET total_medicine_cost = total_medicine_cost + @medicine_price;
            END IF;

            SET @i = @i + 1;
        END WHILE;
    END IF;

    -- Return the total cost of the prescribed medicines
    RETURN total_medicine_cost;
END //
DELIMITER ;

SELECT CalculatePrescribedMedicineCost('alice.jones@example.com', 102);
