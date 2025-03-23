----------------------------------------------- NEWLY ADDED COMPLEX QUERIES ---------------------------------------------------------

-- Complex Query 1: Identify Patients with Appointments and Their Prescribed Medications

-- Purpose - This query gives a complete clinical snapshot: who visited, when, which doctor diagnosed them, and what was prescribed.

-- Usecase Useful for hospital administration, pharmacists, or insurance audits to track prescriptions and medical justification for treatments.

SELECT 
    p.name AS PatientName,
    a.date AS AppointmentDate,
    d.name AS DoctorName,
    dg.diagnosis,
    dg.prescription
FROM PatientsAttendAppointments paa
JOIN Appointment a ON paa.appt = a.id
JOIN Patient p ON paa.patient = p.email
JOIN Diagnose dg ON a.id = dg.appt
JOIN Doctor d ON dg.doctor = d.email
ORDER BY a.date DESC;



 -- Query 2: List Doctors Who Viewed Histories of Patients Prescribed Specific Medicines


-- Purpose - Finds doctors who are actively using patient history + medication knowledge when diagnosing.

-- Use Case - Great for compliance and training—helps hospitals evaluate which doctors are reviewing history before prescribing certain drugs.


SELECT DISTINCT 
    d.name AS DoctorName,
    d.email AS DoctorEmail,
    mh.id AS MedicalHistoryID,
    mh.medication
FROM DoctorViewsHistory dvh
JOIN Doctor d ON dvh.doctor = d.email
JOIN MedicalHistory mh ON dvh.history = mh.id
WHERE mh.medication IN (
    SELECT DISTINCT prescription
    FROM Diagnose
    WHERE prescription IN (
        SELECT medicine_name
        FROM MedicineInventory
    )
);


-- Query 3: Insurance Providers Covering the Highest Total Billing Amounts

-- Purpose - Finds top 5 insurance providers by total hospital billing amount.

-- Use Case - Essential for the finance team to negotiate with insurance companies, analyze dependencies, or design strategic partnerships.

SELECT 
    i.ProviderName,
    COUNT(DISTINCT bp.billing_id) AS NumberOfBills,
    SUM(bp.total_amount) AS TotalBilled
FROM Insurance i
JOIN Patient p ON i.PatientID = p.email
JOIN BillingAndPayments bp ON p.email = bp.patient_id
GROUP BY i.ProviderName
ORDER BY TotalBilled DESC
LIMIT 5;

------------------------------------------------ PREVIOUSLY ADDED QUERIES ----------------------------------------------------------


-- tables created by sachin pant

-- Creating Emergency Table
CREATE TABLE Emergency (
    EmergencyID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    PatientCondition TEXT NOT NULL,
    DoctorID INT NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE
);

-- Creating Insurance Table
CREATE TABLE Insurance (
InsuranceID INT PRIMARY KEY AUTO_INCREMENT,
PatientID INT NOT NULL, 
ProviderName VARCHAR(255) NOT NULL,
PolicyNumber VARCHAR(50) UNIQUE NOT NULL, 
FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE
);
