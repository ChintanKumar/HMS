DROP DATABASE IF EXISTS HMS;

CREATE DATABASE IF NOT EXISTS HMS;
USE HMS;

-- Creating Patient Table
CREATE TABLE Patient(
    email VARCHAR(50) PRIMARY KEY,                     -- Unique identifier for each patient (email-based)
    password VARCHAR(30) NOT NULL,                     -- Password for patient login
    name VARCHAR(50) NOT NULL,                         -- Patient's full name
    address VARCHAR(60) NOT NULL,                      -- Patient's residential address
    gender VARCHAR(20) NOT NULL                        -- Patient's gender
);

-- Creating MedicalHistory Table
CREATE TABLE MedicalHistory(
    id INT PRIMARY KEY,                               -- Unique identifier for medical history
    date DATE NOT NULL,                               -- Date of record entry
    conditions VARCHAR(100) NOT NULL,                 -- List of medical conditions
    surgeries VARCHAR(100) NOT NULL,                  -- List of previous surgeries
    medication VARCHAR(100) NOT NULL                  -- List of prescribed medications
);

-- Creating Doctor Table
CREATE TABLE Doctor(
    email VARCHAR(50) PRIMARY KEY,                    -- Unique identifier for each doctor (email-based)
    gender VARCHAR(20) NOT NULL,                      -- Doctor's gender
    password VARCHAR(30) NOT NULL,                    -- Password for doctor login
    name VARCHAR(50) NOT NULL                         -- Doctor's full name
);

-- Creating Appointment Table
CREATE TABLE Appointment(
    id INT PRIMARY KEY,                                -- Unique identifier for each appointment
    date DATE NOT NULL,                                -- Date of appointment
    starttime TIME NOT NULL,                           -- Start time of the appointment
    endtime TIME NOT NULL,                             -- End time of the appointment
    status VARCHAR(15) NOT NULL                        -- Appointment status (e.g., Scheduled, Completed, Cancelled)
);

-- Creating PatientsAttendAppointments Table
CREATE TABLE PatientsAttendAppointments(
    patient VARCHAR(50) NOT NULL,                     -- Email of the patient attending the appointment
    appt INT NOT NULL,                                -- Appointment ID
    concerns VARCHAR(40) NOT NULL,                    -- Patient's concerns for the appointment
    symptoms VARCHAR(40) NOT NULL,                    -- Symptoms reported by the patient
    FOREIGN KEY (patient) REFERENCES Patient (email) ON DELETE CASCADE,
    FOREIGN KEY (appt) REFERENCES Appointment (id) ON DELETE CASCADE,
    PRIMARY KEY (patient, appt)
);

-- Creating Schedule Table
CREATE TABLE Schedule(
    id INT NOT NULL,                                   -- Unique identifier for the schedule
    starttime TIME NOT NULL,                           -- Start time of the doctor's shift
    endtime TIME NOT NULL,                             -- End time of the doctor's shift
    breaktime TIME NOT NULL,                           -- Break time during the shift
    day VARCHAR(20) NOT NULL,                          -- Day of the week
    PRIMARY KEY (id, starttime, endtime, breaktime, day)
);

-- Creating PatientsFillHistory Table
CREATE TABLE PatientsFillHistory(
    patient VARCHAR(50) NOT NULL,                     -- Email of the patient filling the history
    history INT NOT NULL,                             -- Medical History ID
    FOREIGN KEY (patient) REFERENCES Patient (email) ON DELETE CASCADE,
    FOREIGN KEY (history) REFERENCES MedicalHistory (id) ON DELETE CASCADE,
    PRIMARY KEY (patient, history)                    -- Updated to composite primary key
);

-- Creating Diagnose Table
CREATE TABLE Diagnose(
    appt INT NOT NULL,                                -- Appointment ID
    doctor VARCHAR(50) NOT NULL,                      -- Email of the diagnosing doctor
    diagnosis VARCHAR(40) NOT NULL,                   -- Diagnosis details
    prescription VARCHAR(50) NOT NULL,                -- Prescription details
    FOREIGN KEY (appt) REFERENCES Appointment (id) ON DELETE CASCADE,
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    PRIMARY KEY (appt, doctor)
);

-- Creating DocsHaveSchedules Table
CREATE TABLE DocsHaveSchedules(
    sched INT NOT NULL,                               -- Schedule ID
    doctor VARCHAR(50) NOT NULL,                      -- Email of the doctor
    FOREIGN KEY (sched) REFERENCES Schedule (id) ON DELETE CASCADE,
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    PRIMARY KEY (sched, doctor)
);

-- Creating DoctorViewsHistory Table
CREATE TABLE DoctorViewsHistory(
    history INT NOT NULL,                             -- Medical History ID
    doctor VARCHAR(50) NOT NULL,                      -- Email of the doctor viewing the history
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    FOREIGN KEY (history) REFERENCES MedicalHistory (id) ON DELETE CASCADE,
    PRIMARY KEY (history, doctor)
);

-- Creating RoomsAndWards Table
CREATE TABLE RoomsAndWards (
    RoomID INT PRIMARY KEY,                            -- Unique room identifier
    RoomType VARCHAR(50),                              -- Type of room (e.g., General, ICU, Private)
    AvailabilityStatus VARCHAR(50),                    -- Availability status (e.g., Available, Occupied)
    AssignedPatientID VARCHAR(255),                    -- Email of the assigned patient (if any)
    FOREIGN KEY (AssignedPatientID) REFERENCES Patient(email)
);

-- Creating SupportStaff Table
CREATE TABLE SupportStaff (
    StaffID INT PRIMARY KEY,                           -- Unique identifier for support staff
    Name VARCHAR(255),                                 -- Support staff's full name
    Role VARCHAR(100),                                 -- Staff role (e.g., Nurse, Technician, Admin)
    Department VARCHAR(100),                           -- Department where the staff works
    Shift VARCHAR(50)                                  -- Staff shift details (e.g., Morning, Evening, Night)
);

-- Creating BillingAndPayments Table
CREATE TABLE BillingAndPayments (
    billing_id INT PRIMARY KEY AUTO_INCREMENT,      									-- Unique identifier for each bill
    patient_id VARCHAR(50),                                 							-- Links to the Patients table
    appointment_id INT,                             									-- Links to the Appointments table
    total_amount DECIMAL(10,2),                     									-- The total bill amount
    paid_amount DECIMAL(10,2),                      									-- The amount already paid
    payment_method ENUM('Cash', 'Card', 'Insurance', 'Online'),  			            -- Payment mode
    payment_status ENUM('Paid', 'Pending', 'Partially Paid'),     		                -- Payment status
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  									
    FOREIGN KEY (patient_id) REFERENCES Patient(email),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(id)
);

-- Creating MedicineInventory Table
CREATE TABLE MedicineInventory (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,        -- Unique ID for each medicine
    medicine_name VARCHAR(100) NOT NULL,               -- Name of the medicine
    batch_number VARCHAR(50) NOT NULL,                 -- Unique batch number for tracking
    manufacturer VARCHAR(100),                         -- Manufacturer of the medicine
    category ENUM('Tablet', 'Capsule', 'Syrup', 'Injection', 'Ointment'), -- Type of medicine
    quantity INT NOT NULL DEFAULT 0,                   -- Current stock level
    unit_price DECIMAL(10,2) NOT NULL,                 -- Price per unit
    expiry_date DATE                                   -- Expiration date
);

-- Creating Emergency Table
CREATE TABLE Emergency (
    EmergencyID INT PRIMARY KEY AUTO_INCREMENT,        -- Unique identifier for each emergency case
    PatientID VARCHAR(50) NOT NULL,                    -- Patient ID linked to the emergency
    PatientCondition TEXT NOT NULL,                    -- Description of the patient’s condition
    DoctorID VARCHAR(50) NOT NULL,                     -- Assigned Doctor ID
    ArrivalTime DATETIME NOT NULL,                     -- Time of patient arrival
    FOREIGN KEY (PatientID) REFERENCES Patient(email) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(email) ON DELETE CASCADE
);

-- Creating Insurance Table
CREATE TABLE Insurance (
    InsuranceID INT PRIMARY KEY AUTO_INCREMENT,        -- Unique identifier for each insurance record
    PatientID VARCHAR(50) NOT NULL,                    -- Patient ID linked to the insurance
    ProviderName VARCHAR(255) NOT NULL,                -- Insurance provider name
    PolicyNumber VARCHAR(50) UNIQUE NOT NULL,          -- Unique policy number
    FOREIGN KEY (PatientID) REFERENCES Patient(email)
);