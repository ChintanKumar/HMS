CREATE DATABASE HMS;
USE HMS;

CREATE TABLE Patient(
email varchar(50) PRIMARY KEY,
password varchar(30) NOT NULL,
name varchar(50) NOT NULL,
address varchar(60) NOT NULL,
gender VARCHAR(20) NOT NULL
);

CREATE TABLE RoomsAndWards (
    RoomID INT PRIMARY KEY,
    RoomType VARCHAR(50),
    AvailabilityStatus VARCHAR(50),
    AssignedPatientID VARCHAR(255),
    FOREIGN KEY (AssignedPatientID) REFERENCES Patient(email)
);

-- Table: SupportStaff
CREATE TABLE SupportStaff (
    StaffID INT PRIMARY KEY,
    Name VARCHAR(255),
    Role VARCHAR(100),
    Department VARCHAR(100),
    Shift VARCHAR(50)
);



INSERT INTO Patient(email,password,name,address,gender)
VALUES
('ramesh@gmail.com','password','Ramesh','Tamil Nadu', 'male'),
('suresh@gmail.com','password','Suresh','Karnataka', 'male'),
('rakesh@gmail.com','password','Rakesh','Gujarat', 'male'),
('kamlesh@gmail.com','password','Kamlesh','Maharashtra', 'male'),
('heera@gmail.com','password','Heera','Goa', 'female')
;

-- Insert Data into RoomsAndWards
INSERT INTO RoomsAndWards (RoomID, RoomType, AvailabilityStatus, AssignedPatientID)
VALUES
(101, 'Single', 'Available', NULL),
(102, 'Double', 'Occupied', 'ramesh@gmail.com'),
(103, 'ICU', 'Occupied', 'suresh@gmail.com'),
(104, 'General', 'Available', NULL);

-- Insert Data into SupportStaff
INSERT INTO SupportStaff (StaffID, Name, Role, Department, Shift)
VALUES
(1, 'John Doe', 'Nurse', 'Emergency', 'Day'),
(2, 'Jane Smith', 'Technician', 'Radiology', 'Night'),
(3, 'Emily Johnson', 'Receptionist', 'Front Desk', 'Day'),
(4, 'Michael Lee', 'Pharmacist', 'Pharmacy', 'Evening');

-- Queries

-- get all occupied rooms
SELECT * FROM RoomsAndWards WHERE AvailabilityStatus = 'Occupied';

-- Find Room Assigned to a Specific Patient
SELECT RoomID, RoomType FROM RoomsAndWards WHERE AssignedPatientID = 'ramesh@gmail.com';

-- Find Patients Without Room Assignment
SELECT P.Name, P.Email
FROM Patient P
LEFT JOIN RoomsAndWards R ON P.Email = R.AssignedPatientID
WHERE R.AssignedPatientID IS NULL;



