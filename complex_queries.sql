
-- QUERIES

-- Query to find the inventory of medicines that are expiring within the next 6 months
SELECT medicine_name, batch_number, manufacturer, category, quantity, unit_price, expiry_date
FROM MedicineInventory
WHERE expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- Query to find the total amount billed and paid by each patient
SELECT p.name AS PatientName, SUM(bp.total_amount) AS TotalBilled, SUM(bp.paid_amount) AS TotalPaid
FROM Patient p
JOIN BillingAndPayments bp ON p.email = bp.patient_id
GROUP BY p.name;

-- Query to find the patients who have the highest total billing amount
SELECT p.name AS PatientName, SUM(bp.total_amount) AS TotalBilling
FROM Patient p
JOIN BillingAndPayments bp ON p.email = bp.patient_id
GROUP BY p.name
HAVING SUM(bp.total_amount) = (
    SELECT MAX(TotalBilling)
    FROM (
        SELECT SUM(bp.total_amount) AS TotalBilling
        FROM BillingAndPayments bp
        GROUP BY bp.patient_id
    ) AS SubQuery
);

-- Query to find the doctors who have handled the most emergency cases
SELECT d.name AS DoctorName, COUNT(e.PatientID) AS EmergencyCases
FROM Doctor d
JOIN Emergency e ON d.email = e.DoctorID
GROUP BY d.name
HAVING COUNT(e.PatientID) = (
    SELECT MAX(EmergencyCases)
    FROM (
        SELECT COUNT(e.PatientID) AS EmergencyCases
        FROM Emergency e
        GROUP BY e.DoctorID
    ) AS SubQuery
);

-- Query to find the support staff who have worked the most shifts in the 'Emergency' department
SELECT ss.Name, ss.Role, ss.Department, COUNT(ss.Shift) AS ShiftCount
FROM SupportStaff ss
WHERE ss.Department = 'Emergency'
GROUP BY ss.Name, ss.Role, ss.Department
HAVING COUNT(ss.Shift) = (
    SELECT MAX(ShiftCount)
    FROM (
        SELECT COUNT(ss.Shift) AS ShiftCount
        FROM SupportStaff ss
        WHERE ss.Department = 'Emergency'
        GROUP BY ss.Name
    ) AS SubQuery
);
