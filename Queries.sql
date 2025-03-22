------------------------------------------------ PREVIOUSLY ADDED QUERIES ----------------------------------------------------------

-- CALCULATE TOTAL REVENUE GENERATED FROM ALL APPOINTMENTS / (Finance and Billing)
SELECT SUM(paid_amount) AS total_revenue FROM BillingAndPayments WHERE payment_status = 'Paid';

-- GET TOTAL OUTSTANDING DUES / (Finance and Billing)
SELECT SUM(total_amount - paid_amount) AS total_due FROM BillingAndPayments WHERE payment_status != 'Paid';

-- RETRIEVE ALL MEDICINES DETAILS IN THE INVENTORY / (Inventory Management)
SELECT * FROM MedicineInventory;

-- RETRIEVE MEDICINES EXPIRING IN THE NEXT 30 DAYS / (Inventory Management)
SELECT * FROM MedicineInventory WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 30 DAY);


----------------------------------------------- NEWLY ADDED COMPLEX QUERIES ---------------------------------------------------------

-- 1) LIST PATIENTS WITH PENDING PAYMENTS AND OUTSTANDING DUES / (Finance and Billing)
SELECT p.email AS PatientEmail, 
       p.name AS PatientName, 
       b.total_amount, 
       b.paid_amount, 
       (b.total_amount - b.paid_amount) AS OutstandingAmount
FROM Patient p
JOIN BillingAndPayments b ON p.email = b.patient_id
WHERE b.payment_status = 'Pending';


-- 2) GET MEDICINE STOCK DETAILS WITH LOW INVENTORY / (Inventory Management)
SELECT m.medicine_id, 
       m.medicine_name, 
       m.quantity, 
       m.expiry_date
FROM MedicineInventory m
WHERE m.quantity < 20
ORDER BY m.expiry_date ASC;

-- 3) RETRIEVE BOTH OCCUPIED AND UNOCCUPIED ROOMS WITH ASSIGNED PATIENTS / (Hospital Admin/Patient Management)
SELECT r.RoomID, 
       r.RoomType, 
       r.AvailabilityStatus,
       IF(p.name IS NULL, 'Unassigned', p.name) AS PatientName
FROM RoomsAndWards r
LEFT JOIN Patient p ON r.AssignedPatientID = p.email;


-- 4) RETRIEVE EMERGENCY CASES HANDLED BY A SPECIFIC DOCTOR / (Emergency Unit)
SELECT e.EmergencyID, 
       e.PatientCondition, 
       e.ArrivalTime, 
       d.name AS DoctorName
FROM Emergency e
JOIN Doctor d ON e.DoctorID = d.email
WHERE d.email = 'dummy@example.com';


-- 5) RETRIEVE PATIENT DETAILS WITH LATEST APPOINTMENT INFORMATION / (Patient Scheduling)
SELECT p.email AS PatientEmail, 
       p.name AS PatientName, 
       a.date AS AppointmentDate, 
       a.starttime AS StartTime, 
       a.status AS AppointmentStatus
FROM Patient p
LEFT JOIN PatientsAttendAppointments paa ON p.email = paa.patient
LEFT JOIN Appointment a ON paa.appt = a.id
ORDER BY a.date DESC;


-- 6) LIST PATIENTS WITH MEDICAL HISTORY AND ASSOCIATED DOCTORS / (Patient Records)
SELECT p.name AS PatientName, 
       mh.conditions AS MedicalConditions, 
       d.name AS DoctorName
FROM Patient p
JOIN PatientsFillHistory pfh ON p.email = pfh.patient
JOIN MedicalHistory mh ON pfh.history = mh.id
JOIN DoctorViewsHistory dvh ON mh.id = dvh.history
JOIN Doctor d ON dvh.doctor = d.email;


