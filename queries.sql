-- ------------------------------ Simple Queries ------------------------------

-- 1. All Available Rooms 
SELECT 
    RoomID,
    RoomType,
    AvailabilityStatus
FROM 
    RoomsAndWards
WHERE 
    AvailabilityStatus = 'Available';

-- 2. Patients and their Insurance Details
SELECT 
    p.name AS PatientName,
    p.email AS PatientEmail,
    i.ProviderName AS InsuranceProvider,
    i.PolicyNumber AS PolicyNumber
FROM 
    Patient p
JOIN 
    Insurance i ON p.email = i.PatientID
ORDER BY 
    p.name;

-- ------------------------------ Complex Queries ------------------------------

-- 3. [For Doctors] Fetch All Patients with Their Medical History and Assigned Rooms
SELECT 
    p.name AS PatientName,
    p.email AS PatientEmail,
    p.address AS PatientAddress,
    p.gender AS PatientGender,
    mh.conditions AS MedicalConditions,
    mh.surgeries AS Surgeries,
    mh.medication AS Medications,
    rw.RoomID,
    rw.RoomType,
    rw.AvailabilityStatus
FROM 
    Patient p
JOIN 
    PatientsFillHistory pfh ON p.email = pfh.patient
JOIN 
    MedicalHistory mh ON pfh.history = mh.id
LEFT JOIN 
    RoomsAndWards rw ON p.email = rw.AssignedPatientID
ORDER BY 
    p.name;


-- 4. [New Patient Bookings & For Doctors] Fetch All Doctors with Their Schedules and Appointments
SELECT 
    d.name AS DoctorName,
    d.email AS DoctorEmail,
    s.day AS ScheduleDay,
    s.starttime AS ScheduleStart,
    s.endtime AS ScheduleEnd,
    s.breaktime AS BreakTime,
    a.id AS AppointmentID,
    a.date AS AppointmentDate,
    a.starttime AS AppointmentStart,
    a.endtime AS AppointmentEnd,
    a.status AS AppointmentStatus
FROM 
    Doctor d
JOIN 
    DocsHaveSchedules dhs ON d.email = dhs.doctor
JOIN 
    Schedule s ON dhs.sched = s.id
LEFT JOIN 
    Diagnose di ON d.email = di.doctor
LEFT JOIN 
    Appointment a ON di.appt = a.id
ORDER BY 
    d.name, s.day, a.date;

-- 5. [Accounts Department] Billing Details with Patient and Appointment Information
SELECT 
    b.billing_id AS BillingID,
    b.patient_id AS PatientEmail,
    p.name AS PatientName,
    b.appointment_id AS AppointmentID,
    a.date AS AppointmentDate,
    b.total_amount AS TotalAmount,
    b.paid_amount AS PaidAmount,
    b.payment_method AS PaymentMethod,
    b.payment_status AS PaymentStatus,
    b.payment_date AS PaymentDate
FROM 
    BillingAndPayments b
JOIN 
    Patient p ON b.patient_id = p.email
JOIN 
    Appointment a ON b.appointment_id = a.id
ORDER BY 
    b.payment_date DESC;
