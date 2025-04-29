-- STORED PROCEDURES

-- CHINTAN' WORK
-- PROCEDURE 1: Schedule an Appointment
-- USE CASE: Book an appointment for a patient with a doctor.
-- Example: CALL ScheduleAppointment('john.doe@example.com', 'doc@example.com', '2025-04-01', '10:00:00', '10:30:00', 'Scheduled');

-- Scheduling an appointment
CALL ScheduleAppointment('john.doe@example.com', 'dr.jane@example.com', '2025-04-25', '10:00:00', '10:30:00', 'Scheduled');

-- PROCEDURE 2: Process Payment
-- USE CASE: Update a patient's billing record after a payment.
-- Example: CALL ProcessPayment('john.doe@example.com', 101, 50.00, 'Card');

-- Processing Payment
CALL ProcessPayment('john.doe@example.com', 101, 50.00, 'Card');

-- KHUSHI'S WORK
-- PROCEDURE 3: Generate a billing statement for a given appointment, including patient details, appointment information, diagnosis, prescription, and a placeholder for billing details.

CALL GenerateBillingStatement(1);

-- PROCEDURE 4: Transfers a patient from their current room to a new room, updating the RoomsAndWards table accordingly

-- CALL TransferPatientRoom('alice.jones@example.com', the_new_room_id);
CALL TransferPatientRoom('alice.jones@example.com', 102);

-- Assuming RoomID 103 is occupied
CALL TransferPatientRoom('john.doe@example.com', 103);

-- SACHIN'S WORK
-- Procedure 5: AdmitEmergencyPatient
-- Purpose: Handles the admission workflow of an emergency patient, assigning a doctor, logging the emergency, and allocating an available ICU room.
-- Use Case: Used by the emergency intake system to manage urgent admissions efficiently in one transaction.

-- 👇 Sample CALL to AdmitEmergencyPatient
CALL AdmitEmergencyPatient('john.doe@example.com', 'Severe chest pain and shortness of breath', 'dr.smith@example.com');

-- Procedure 6: UpdateOrCreateInsuranceRecord
-- Purpose: Validates if the insurance record exists for a patient. If yes → update, if not → create.
-- Use Case: Robust insurance record management across billing, registration, or policy update systems.


-- 👇 Sample CALLs to UpdateOrCreateInsuranceRecord
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'BlueCross', 'POL123456'); -- insert
CALL UpdateOrCreateInsuranceRecord('john.doe@example.com', 'Aetna', 'POL999999'); -- update

-- VIYANK'S WORK
-- PROCEDURE 7: GenerateFinalBill
-- Purpose: Calculates final bill for a given patient by summing up unpaid charges and applying insurance if applicable.
-- Input:  patient_email VARCHAR(50): Email ID of the patient whose final bill is to be generated.
-- Output: Prints total outstanding payment by the patient after considering insurance coverage.

-- PROCEDURE 8: DischargePatient
-- Purpose: Handles full discharge of a patient, finalizes billing, frees assigned room.
-- Input: patient_email VARCHAR(50): Email ID of the patient to be discharged.
-- Output: Updates payment status and room assignment.


-- Example: Discharge the patient with email 'mike.patient@hospital.com'
CALL DischargePatient('mike.patient@hospital.com');


-- FUNCTIONS:-

-- CHINTAN' WORK

-- FUNCTION 1: Get Available Doctor Schedule
-- USE CASE: Fetch a doctor's availability on a given day.
-- Example: SELECT GetDoctorAvailability('doctor@example.com', 'Monday');

-- Function Call
SELECT GetDoctorAvailability('dr.jane@example.com', 'Monday');

-- FUNCTION 2: Get Medicine Stock Level
-- USE CASE: Fetch the current available quantity of a specific medicine from the inventory.
-- Example: SELECT GetMedicineStockLevel('Paracetamol');

-- Function Call
SELECT GetMedicineStockLevel('Paracetamol') AS AvailableStock;

-- KHUSHI'S WORK

-- FUNCTION 3: Function to calculate Outstanding Balance

SELECT CalculateBalance('alice.jones@example.com');

-- FUNCTION 4: Function to calculate the total cost of medicines prescribed to a patient during a specific appointment 

SELECT CalculatePrescribedMedicineCost('alice.jones@example.com', 102);

-- SACHIN'S WORK

-- Function 5: GetPatientEmergencyVisitCount
-- Purpose: Returns how many times a patient has been to the Emergency Room.
-- Use Case: Helps flag frequent visitors, potentially for case management or alerts.

-- 👇 Sample SELECT using GetPatientEmergencyVisitCount
SELECT GetPatientEmergencyVisitCount('john.doe@example.com') AS EmergencyVisits;

-- Function 6: IsInsuranceValid
-- Purpose: Returns 'Yes' if a patient has valid insurance; 'No' otherwise.
-- Use Case: Useful inside conditions for billing workflows or eligibility checks.

-- 👇 Sample SELECT using IsInsuranceValid
SELECT IsInsuranceValid('john.doe@example.com') AS InsuranceStatus;

-- VIYANK'S WORK

-- Function 7: Calculate percentage of scheduled time used in appointments.
-- It calculates the percentage of a doctor’s scheduled time that is actually used for patient appointments. By comparing total scheduled time and actual appointment time, this function can help in optimizing schedules.
-- Input: doctor_email (VARCHAR)
-- Output: DECIMAL(5,2) - Utilization percentage


SELECT GetDoctorUtilization('dr.jane@hospital.com') AS utilization_percentage;

-- Function 8: Calculate total unpaid amount for a patient.
-- Input: patient_email (VARCHAR)
-- Output: DECIMAL(10,2) - Total outstanding balance

-- Example: Get outstanding balance for patient with email 'patient.mike@hospital.com'
SELECT CalculateOutstandingBalance('patient.mike@hospital.com') AS pending_dues;