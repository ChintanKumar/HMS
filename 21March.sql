use project;

show tables;

select Database();

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
