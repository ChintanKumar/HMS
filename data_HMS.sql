USE HMS;

-- Inserting Data into Patient Table
INSERT INTO Patient (email, password, name, address, gender)
VALUES
('john.doe@example.com', 'password123', 'John Doe', '123 Main St, Cityville', 'Male'),
('jane.smith@example.com', 'securepass', 'Jane Smith', '456 Elm St, Townsville', 'Female'),
('alice.jones@example.com', 'alice123', 'Alice Jones', '789 Oak St, Villageville', 'Female'),
('michael.brown@example.com', 'mikepass', 'Michael Brown', '101 Pine St, Hamlet', 'Male'),
('emily.davis@example.com', 'emilypass', 'Emily Davis', '202 Birch St, Metropolis', 'Female'),
('david.wilson@example.com', 'davidpass', 'David Wilson', '303 Cedar St, Smalltown', 'Male'),
('sarah.miller@example.com', 'sarahpass', 'Sarah Miller', '404 Maple St, Bigcity', 'Female'),
('chris.moore@example.com', 'chrispass', 'Chris Moore', '505 Walnut St, Suburbia', 'Male'),
('laura.taylor@example.com', 'laurapass', 'Laura Taylor', '606 Chestnut St, Countryside', 'Female'),
('james.anderson@example.com', 'jamespass', 'James Anderson', '707 Spruce St, Uptown', 'Male'),
('linda.thomas@example.com', 'lindapass', 'Linda Thomas', '808 Fir St, Downtown', 'Female'),
('robert.jackson@example.com', 'robertpass', 'Robert Jackson', '909 Redwood St, Seaside', 'Male'),
('barbara.white@example.com', 'barbarapass', 'Barbara White', '1010 Cypress St, Riverside', 'Female'),
('charles.harris@example.com', 'charlespass', 'Charles Harris', '1111 Willow St, Lakeside', 'Male'),
('patricia.martin@example.com', 'patriciapass', 'Patricia Martin', '1212 Poplar St, Hillside', 'Female'),
('daniel.thompson@example.com', 'danielpass', 'Daniel Thompson', '1313 Alder St, Valleyview', 'Male'),
('jennifer.garcia@example.com', 'jenniferpass', 'Jennifer Garcia', '1414 Ash St, Mountainview', 'Female'),
('matthew.martinez@example.com', 'matthewpass', 'Matthew Martinez', '1515 Beech St, Forestville', 'Male'),
('elizabeth.robinson@example.com', 'elizabethpass', 'Elizabeth Robinson', '1616 Elm St, Meadowbrook', 'Female'),
('anthony.clark@example.com', 'anthonypass', 'Anthony Clark', '1717 Pine St, Brookside', 'Male'),
('susan.rodriguez@example.com', 'susanpass', 'Susan Rodriguez', '1818 Birch St, Parkview', 'Female'),
('mark.lewis@example.com', 'markpass', 'Mark Lewis', '1919 Cedar St, Woodside', 'Male'),
('mary.lee@example.com', 'marypass', 'Mary Lee', '2020 Maple St, Cliffside', 'Female'),
('paul.walker@example.com', 'paulpass', 'Paul Walker', '2121 Walnut St, Bayside', 'Male'),
('nancy.hall@example.com', 'nancypass', 'Nancy Hall', '2222 Chestnut St, Creekside', 'Female'),
('steven.allen@example.com', 'stevenpass', 'Steven Allen', '2323 Spruce St, Riverside', 'Male'),
('karen.young@example.com', 'karenpass', 'Karen Young', '2424 Fir St, Lakeside', 'Female'),
('joshua.king@example.com', 'joshuapass', 'Joshua King', '2525 Redwood St, Hillside', 'Male'),
('betty.wright@example.com', 'bettypass', 'Betty Wright', '2626 Cypress St, Valleyview', 'Female'),
('kevin.lopez@example.com', 'kevinpass', 'Kevin Lopez', '2727 Willow St, Mountainview', 'Male'),
('helen.hill@example.com', 'helenpass', 'Helen Hill', '2828 Poplar St, Forestville', 'Female'),
('brian.scott@example.com', 'brianpass', 'Brian Scott', '2929 Alder St, Meadowbrook', 'Male'),
('sandra.green@example.com', 'sandrapass', 'Sandra Green', '3030 Ash St, Brookside', 'Female'),
('edward.adams@example.com', 'edwardpass', 'Edward Adams', '3131 Beech St, Parkview', 'Male'),
('donna.baker@example.com', 'donnapass', 'Donna Baker', '3232 Elm St, Woodside', 'Female'),
('ronald.nelson@example.com', 'ronaldpass', 'Ronald Nelson', '3333 Pine St, Cliffside', 'Male'),
('carol.carter@example.com', 'carolpass', 'Carol Carter', '3434 Birch St, Bayside', 'Female'),
('kenneth.mitchell@example.com', 'kennethpass', 'Kenneth Mitchell', '3535 Cedar St, Creekside', 'Male'),
('ruth.perez@example.com', 'ruthpass', 'Ruth Perez', '3636 Maple St, Riverside', 'Female');

-- Inserting Data into MedicalHistory Table
INSERT INTO MedicalHistory (id, date, conditions, surgeries, medication)
VALUES
(1, '2024-01-15', 'Asthma', 'Appendectomy', 'Inhaler'),
(2, '2024-03-22', 'Diabetes', 'None', 'Insulin'),
(3, '2024-05-10', 'Hypertension', 'Gallbladder Removal', 'Beta Blockers'),
(4, '2024-07-18', 'Allergies', 'None', 'Antihistamines'),
(5, '2024-09-25', 'Arthritis', 'Knee Replacement', 'Painkillers'),
(6, '2024-11-30', 'Migraine', 'None', 'Triptans'),
(7, '2025-02-14', 'Depression', 'None', 'SSRIs'),
(8, '2025-04-20', 'Anxiety', 'None', 'Benzodiazepines'),
(9, '2025-06-28', 'Thyroid Disorder', 'None', 'Levothyroxine'),
(10, '2025-08-05', 'Cholesterol', 'None', 'Statins'),
(11, '2025-10-12', 'Heart Disease', 'Bypass Surgery', 'Aspirin'),
(12, '2025-12-19', 'Kidney Stones', 'None', 'Painkillers'),
(13, '2026-02-25', 'Liver Disease', 'None', 'Ursodiol'),
(14, '2026-05-03', 'Pneumonia', 'None', 'Antibiotics'),
(15, '2026-07-10', 'Tuberculosis', 'None', 'Isoniazid'),
(16, '2026-09-17', 'Hepatitis', 'None', 'Interferon'),
(17, '2026-11-24', 'HIV/AIDS', 'None', 'Antiretrovirals'),
(18, '2027-02-01', 'Cancer', 'Chemotherapy', 'Tamoxifen'),
(19, '2027-04-10', 'Stroke', 'None', 'Warfarin'),
(20, '2027-06-17', 'Epilepsy', 'None', 'Carbamazepine'),
(21, '2027-08-24', 'Parkinson\'s Disease', 'None', 'Levodopa'),
(22, '2027-11-01', 'Multiple Sclerosis', 'None', 'Interferon beta'),
(23, '2028-01-08', 'Alzheimer\'s Disease', 'None', 'Donepezil'),
(24, '2028-03-15', 'Osteoporosis', 'None', 'Bisphosphonates'),
(25, '2028-05-22', 'Gout', 'None', 'Allopurinol'),
(26, '2028-07-29', 'Psoriasis', 'None', 'Topical Steroids'),
(27, '2028-10-05', 'Lupus', 'None', 'Hydroxychloroquine'),
(28, '2029-01-12', 'Crohn\'s Disease', 'None', 'Infliximab'),
(29, '2029-03-19', 'Ulcerative Colitis', 'None', 'Mesalamine'),
(30, '2029-05-26', 'Celiac Disease', 'None', 'Gluten-free Diet'),
(31, '2029-08-02', 'Irritable Bowel Syndrome', 'None', 'Antispasmodics'),
(32, '2029-10-09', 'Diverticulitis', 'None', 'Antibiotics'),
(33, '2030-01-16', 'Hemorrhoids', 'None', 'Topical Creams'),
(34, '2030-05-09', 'Diverticulitis', 'None', 'Antibiotics'),
(35, '2030-10-16', 'Hemorrhoids', 'None', 'Topical Creams');

-- Inserting Data into Doctor Table
INSERT INTO Doctor (email, gender, password, name)
VALUES
('dr.james@example.com', 'Male', 'docpass123', 'Dr. James Wilson'),
('dr.susan@example.com', 'Female', 'docpass456', 'Dr. Susan Clark'),
('dr.mike@example.com', 'Male', 'docpass789', 'Dr. Mike Brown'),
('dr.linda@example.com', 'Female', 'docpass101', 'Dr. Linda Green'),
('dr.robert@example.com', 'Male', 'docpass102', 'Dr. Robert White'),
('dr.karen@example.com', 'Female', 'docpass103', 'Dr. Karen Black'),
('dr.david@example.com', 'Male', 'docpass104', 'Dr. David Brown'),
('dr.emily@example.com', 'Female', 'docpass105', 'Dr. Emily Davis'),
('dr.john@example.com', 'Male', 'docpass106', 'Dr. John Smith'),
('dr.sarah@example.com', 'Female', 'docpass107', 'Dr. Sarah Johnson'),
('dr.michael@example.com', 'Male', 'docpass108', 'Dr. Michael Lee'),
('dr.jessica@example.com', 'Female', 'docpass109', 'Dr. Jessica Martinez'),
('dr.william@example.com', 'Male', 'docpass110', 'Dr. William Garcia'),
('dr.amy@example.com', 'Female', 'docpass111', 'Dr. Amy Rodriguez'),
('dr.richard@example.com', 'Male', 'docpass112', 'Dr. Richard Wilson'),
('dr.mary@example.com', 'Female', 'docpass113', 'Dr. Mary Anderson'),
('dr.thomas@example.com', 'Male', 'docpass114', 'Dr. Thomas Thomas'),
('dr.patricia@example.com', 'Female', 'docpass115', 'Dr. Patricia Taylor'),
('dr.charles@example.com', 'Male', 'docpass116', 'Dr. Charles Moore'),
('dr.barbara@example.com', 'Female', 'docpass117', 'Dr. Barbara Jackson'),
('dr.joseph@example.com', 'Male', 'docpass118', 'Dr. Joseph Martin'),
('dr.elizabeth@example.com', 'Female', 'docpass119', 'Dr. Elizabeth Thompson'),
('dr.chris@example.com', 'Male', 'docpass120', 'Dr. Chris Martinez'),
('dr.nancy@example.com', 'Female', 'docpass121', 'Dr. Nancy Harris'),
('dr.daniel@example.com', 'Male', 'docpass122', 'Dr. Daniel Clark'),
('dr.lisa@example.com', 'Female', 'docpass123', 'Dr. Lisa Lewis'),
('dr.paul@example.com', 'Male', 'docpass124', 'Dr. Paul Robinson'),
('dr.kare@example.com', 'Female', 'docpass125', 'Dr. Kare Walker'),
('dr.kevin@example.com', 'Male', 'docpass126', 'Dr. Kevin Young'),
('dr.helen@example.com', 'Female', 'docpass127', 'Dr. Helen King'),
('dr.brian@example.com', 'Male', 'docpass128', 'Dr. Brian Wright'),
('dr.sandra@example.com', 'Female', 'docpass129', 'Dr. Sandra Lopez'),
('dr.edward@example.com', 'Male', 'docpass130', 'Dr. Edward Hill'),
('dr.donna@example.com', 'Female', 'docpass131', 'Dr. Donna Scott'),
('dr.ronald@example.com', 'Male', 'docpass132', 'Dr. Ronald Green'),
('dr.carol@example.com', 'Female', 'docpass133', 'Dr. Carol Adams'),
('dr.kenneth@example.com', 'Male', 'docpass134', 'Dr. Kenneth Baker'),
('dr.ruth@example.com', 'Female', 'docpass135', 'Dr. Ruth Nelson');

-- Inserting Data into Appointment Table
INSERT INTO Appointment (id, date, starttime, endtime, status)
VALUES
(1, '2024-08-10', '10:00:00', '10:30:00', 'Scheduled'),
(2, '2024-08-12', '11:00:00', '11:30:00', 'Completed'),
(3, '2024-08-13', '14:00:00', '14:30:00', 'Cancelled'),
(4, '2024-08-14', '09:00:00', '09:30:00', 'Scheduled'),
(5, '2024-08-15', '10:00:00', '10:30:00', 'Completed'),
(6, '2024-08-16', '11:00:00', '11:30:00', 'Cancelled'),
(7, '2024-08-17', '12:00:00', '12:30:00', 'Scheduled'),
(8, '2024-08-18', '13:00:00', '13:30:00', 'Completed'),
(9, '2024-08-19', '14:00:00', '14:30:00', 'Cancelled'),
(10, '2024-08-20', '15:00:00', '15:30:00', 'Scheduled'),
(11, '2024-08-21', '16:00:00', '16:30:00', 'Completed'),
(12, '2024-08-22', '17:00:00', '17:30:00', 'Cancelled'),
(13, '2024-08-23', '09:00:00', '09:30:00', 'Scheduled'),
(14, '2024-08-24', '10:00:00', '10:30:00', 'Completed'),
(15, '2024-08-25', '11:00:00', '11:30:00', 'Cancelled'),
(16, '2024-08-26', '12:00:00', '12:30:00', 'Scheduled'),
(17, '2024-08-27', '13:00:00', '13:30:00', 'Completed'),
(18, '2024-08-28', '14:00:00', '14:30:00', 'Cancelled'),
(19, '2024-08-29', '15:00:00', '15:30:00', 'Scheduled'),
(20, '2024-08-30', '16:00:00', '16:30:00', 'Completed'),
(21, '2024-08-31', '17:00:00', '17:30:00', 'Cancelled'),
(22, '2024-09-01', '09:00:00', '09:30:00', 'Scheduled'),
(23, '2024-09-02', '10:00:00', '10:30:00', 'Completed'),
(24, '2024-09-03', '11:00:00', '11:30:00', 'Cancelled'),
(25, '2024-09-04', '12:00:00', '12:30:00', 'Scheduled'),
(26, '2024-09-05', '13:00:00', '13:30:00', 'Completed'),
(27, '2024-09-06', '14:00:00', '14:30:00', 'Cancelled'),
(28, '2024-09-07', '15:00:00', '15:30:00', 'Scheduled'),
(29, '2024-09-08', '16:00:00', '16:30:00', 'Completed'),
(30, '2024-09-09', '17:00:00', '17:30:00', 'Cancelled'),
(31, '2024-09-10', '09:00:00', '09:30:00', 'Scheduled'),
(32, '2024-09-11', '10:00:00', '10:30:00', 'Completed'),
(33, '2024-09-12', '11:00:00', '11:30:00', 'Cancelled'),
(34, '2024-09-13', '12:00:00', '12:30:00', 'Scheduled'),
(35, '2024-09-14', '13:00:00', '13:30:00', 'Completed');

-- Inserting Data into PatientsAttendAppointments Table
INSERT INTO PatientsAttendAppointments (patient, appt, concerns, symptoms)
VALUES
('john.doe@example.com', 1, 'Breathing Issues', 'Shortness of breath'),
('jane.smith@example.com', 2, 'Skin Rash', 'Itching and redness'),
('alice.jones@example.com', 3, 'Headache', 'Severe migraines'),
('michael.brown@example.com', 4, 'Chest Pain', 'Sharp pain'),
('emily.davis@example.com', 5, 'Back Pain', 'Lower back pain'),
('david.wilson@example.com', 6, 'Joint Pain', 'Knee pain'),
('sarah.miller@example.com', 7, 'Fatigue', 'Extreme tiredness'),
('chris.moore@example.com', 8, 'Dizziness', 'Lightheadedness'),
('laura.taylor@example.com', 9, 'Nausea', 'Feeling sick'),
('james.anderson@example.com', 10, 'Cough', 'Persistent cough'),
('linda.thomas@example.com', 11, 'Fever', 'High temperature'),
('robert.jackson@example.com', 12, 'Sore Throat', 'Painful swallowing'),
('barbara.white@example.com', 13, 'Ear Pain', 'Earache'),
('charles.harris@example.com', 14, 'Abdominal Pain', 'Stomach ache'),
('patricia.martin@example.com', 15, 'Swelling', 'Swollen ankle'),
('daniel.thompson@example.com', 16, 'Burning Sensation', 'Burning feeling'),
('jennifer.garcia@example.com', 17, 'Blurred Vision', 'Vision problems'),
('matthew.martinez@example.com', 18, 'Cold Symptoms', 'Runny nose'),
('elizabeth.robinson@example.com', 19, 'Muscle Pain', 'Muscle soreness'),
('anthony.clark@example.com', 20, 'Vomiting', 'Throwing up'),
('susan.rodriguez@example.com', 21, 'Diarrhea', 'Loose stools'),
('mark.lewis@example.com', 22, 'Constipation', 'Difficulty passing stools'),
('mary.lee@example.com', 23, 'Rash', 'Skin irritation'),
('paul.walker@example.com', 24, 'Insomnia', 'Trouble sleeping'),
('nancy.hall@example.com', 25, 'Anxiety', 'Feeling anxious'),
('steven.allen@example.com', 26, 'Depression', 'Feeling down'),
('karen.young@example.com', 27, 'Weight Loss', 'Unintentional weight loss'),
('joshua.king@example.com', 28, 'Weight Gain', 'Unintentional weight gain'),
('betty.wright@example.com', 29, 'Hair Loss', 'Thinning hair'),
('kevin.lopez@example.com', 30, 'Memory Loss', 'Forgetfulness'),
('helen.hill@example.com', 31, 'Tingling', 'Pins and needles'),
('brian.scott@example.com', 32, 'Bruising', 'Easy bruising'),
('sandra.green@example.com', 33, 'Bleeding', 'Unexplained bleeding'),
('edward.adams@example.com', 34, 'Palpitations', 'Heart racing'),
('donna.baker@example.com', 35, 'Sweating', 'Excessive sweating');

-- Inserting Data into Diagnose Table
INSERT INTO Diagnose (appt, doctor, diagnosis, prescription)
VALUES
(1, 'dr.james@example.com', 'Asthma', 'Inhaler'),
(2, 'dr.susan@example.com', 'Allergic Reaction', 'Antihistamines'),
(3, 'dr.mike@example.com', 'Migraine', 'Pain Relievers'),
(4, 'dr.linda@example.com', 'Angina', 'Nitroglycerin'),
(5, 'dr.robert@example.com', 'Sciatica', 'Physical Therapy'),
(6, 'dr.karen@example.com', 'Arthritis', 'NSAIDs'),
(7, 'dr.david@example.com', 'Chronic Fatigue', 'Lifestyle Changes'),
(8, 'dr.emily@example.com', 'Vertigo', 'Meclizine'),
(9, 'dr.john@example.com', 'Gastroenteritis', 'Hydration'),
(10, 'dr.sarah@example.com', 'Bronchitis', 'Antibiotics'),
(11, 'dr.michael@example.com', 'Influenza', 'Rest & Fluids'),
(12, 'dr.jessica@example.com', 'Pharyngitis', 'Throat Lozenges'),
(13, 'dr.william@example.com', 'Otitis Media', 'Ear Drops'),
(14, 'dr.amy@example.com', 'Gastritis', 'Antacids'),
(15, 'dr.richard@example.com', 'Edema', 'Diuretics'),
(16, 'dr.mary@example.com', 'Neuropathy', 'Gabapentin'),
(17, 'dr.thomas@example.com', 'Conjunctivitis', 'Eye Drops'),
(18, 'dr.patricia@example.com', 'Common Cold', 'Decongestants'),
(19, 'dr.charles@example.com', 'Myalgia', 'Muscle Relaxants'),
(20, 'dr.barbara@example.com', 'Gastroesophageal Reflux', 'Proton Pump Inhibitors'),
(21, 'dr.joseph@example.com', 'Irritable Bowel Syndrome', 'Dietary Changes'),
(22, 'dr.elizabeth@example.com', 'Constipation', 'Laxatives'),
(23, 'dr.chris@example.com', 'Dermatitis', 'Topical Steroids'),
(24, 'dr.nancy@example.com', 'Insomnia', 'Sleep Aids'),
(25, 'dr.daniel@example.com', 'Generalized Anxiety Disorder', 'SSRIs'),
(26, 'dr.lisa@example.com', 'Major Depressive Disorder', 'Antidepressants'),
(27, 'dr.paul@example.com', 'Hyperthyroidism', 'Methimazole'),
(28, 'dr.karen@example.com', 'Hypothyroidism', 'Levothyroxine'),
(29, 'dr.kevin@example.com', 'Alopecia', 'Minoxidil'),
(30, 'dr.helen@example.com', 'Amnesia', 'Cognitive Therapy'),
(31, 'dr.brian@example.com', 'Peripheral Neuropathy', 'Vitamin B12'),
(32, 'dr.sandra@example.com', 'Purpura', 'Steroids'),
(33, 'dr.edward@example.com', 'Hemophilia', 'Factor Replacement'),
(34, 'dr.donna@example.com', 'Arrhythmia', 'Beta Blockers'),
(35, 'dr.ronald@example.com', 'Hyperhidrosis', 'Antiperspirants');

-- Inserting Data into Schedule Table
INSERT INTO Schedule (id, starttime, endtime, breaktime, day)
VALUES
(1, '08:00:00', '12:00:00', '10:00:00', 'Monday'),
(2, '13:00:00', '17:00:00', '15:00:00', 'Wednesday'),
(3, '09:00:00', '13:00:00', '11:00:00', 'Friday'),
(4, '08:00:00', '12:00:00', '10:00:00', 'Tuesday'),
(5, '13:00:00', '17:00:00', '15:00:00', 'Thursday'),
(6, '09:00:00', '13:00:00', '11:00:00', 'Saturday'),
(7, '08:00:00', '12:00:00', '10:00:00', 'Sunday'),
(8, '13:00:00', '17:00:00', '15:00:00', 'Monday'),
(9, '09:00:00', '13:00:00', '11:00:00', 'Wednesday'),
(10, '08:00:00', '12:00:00', '10:00:00', 'Friday'),
(11, '13:00:00', '17:00:00', '15:00:00', 'Tuesday'),
(12, '09:00:00', '13:00:00', '11:00:00', 'Thursday'),
(13, '08:00:00', '12:00:00', '10:00:00', 'Saturday'),
(14, '13:00:00', '17:00:00', '15:00:00', 'Sunday'),
(15, '09:00:00', '13:00:00', '11:00:00', 'Monday'),
(16, '08:00:00', '12:00:00', '10:00:00', 'Wednesday'),
(17, '13:00:00', '17:00:00', '15:00:00', 'Friday'),
(18, '09:00:00', '13:00:00', '11:00:00', 'Tuesday'),
(19, '08:00:00', '12:00:00', '10:00:00', 'Thursday'),
(20, '13:00:00', '17:00:00', '15:00:00', 'Saturday'),
(21, '09:00:00', '13:00:00', '11:00:00', 'Sunday'),
(22, '08:00:00', '12:00:00', '10:00:00', 'Monday'),
(23, '13:00:00', '17:00:00', '15:00:00', 'Wednesday'),
(24, '09:00:00', '13:00:00', '11:00:00', 'Friday'),
(25, '08:00:00', '12:00:00', '10:00:00', 'Tuesday'),
(26, '13:00:00', '17:00:00', '15:00:00', 'Thursday'),
(27, '09:00:00', '13:00:00', '11:00:00', 'Saturday'),
(28, '08:00:00', '12:00:00', '10:00:00', 'Sunday'),
(29, '13:00:00', '17:00:00', '15:00:00', 'Monday'),
(30, '09:00:00', '13:00:00', '11:00:00', 'Wednesday'),
(31, '08:00:00', '12:00:00', '10:00:00', 'Friday'),
(32, '13:00:00', '17:00:00', '15:00:00', 'Tuesday'),
(33, '09:00:00', '13:00:00', '11:00:00', 'Thursday'),
(34, '08:00:00', '12:00:00', '10:00:00', 'Saturday'),
(35, '13:00:00', '17:00:00', '15:00:00', 'Sunday');

-- Inserting Data into DocsHaveSchedules Table
INSERT INTO DocsHaveSchedules (sched, doctor)
VALUES
(1, 'dr.james@example.com'),
(2, 'dr.susan@example.com'),
(3, 'dr.mike@example.com'),
(4, 'dr.linda@example.com'),
(5, 'dr.robert@example.com'),
(6, 'dr.karen@example.com'),
(7, 'dr.david@example.com'),
(8, 'dr.emily@example.com'),
(9, 'dr.john@example.com'),
(10, 'dr.sarah@example.com'),
(11, 'dr.michael@example.com'),
(12, 'dr.jessica@example.com'),
(13, 'dr.william@example.com'),
(14, 'dr.amy@example.com'),
(15, 'dr.richard@example.com'),
(16, 'dr.mary@example.com'),
(17, 'dr.thomas@example.com'),
(18, 'dr.patricia@example.com'),
(19, 'dr.charles@example.com'),
(20, 'dr.barbara@example.com'),
(21, 'dr.joseph@example.com'),
(22, 'dr.elizabeth@example.com'),
(23, 'dr.chris@example.com'),
(24, 'dr.nancy@example.com'),
(25, 'dr.daniel@example.com'),
(26, 'dr.lisa@example.com'),
(27, 'dr.paul@example.com'),
(28, 'dr.karen@example.com'),
(29, 'dr.kevin@example.com'),
(30, 'dr.helen@example.com'),
(31, 'dr.brian@example.com'),
(32, 'dr.sandra@example.com'),
(33, 'dr.edward@example.com'),
(34, 'dr.donna@example.com'),
(35, 'dr.ronald@example.com');

-- Inserting Data into PatientsFillHistory Table
INSERT INTO PatientsFillHistory (patient, history)
VALUES
('john.doe@example.com', 1),
('jane.smith@example.com', 2),
('alice.jones@example.com', 3),
('michael.brown@example.com', 4),
('emily.davis@example.com', 5),
('david.wilson@example.com', 6),
('sarah.miller@example.com', 7),
('chris.moore@example.com', 8),
('laura.taylor@example.com', 9),
('james.anderson@example.com', 10),
('linda.thomas@example.com', 11),
('robert.jackson@example.com', 12),
('barbara.white@example.com', 13),
('charles.harris@example.com', 14),
('patricia.martin@example.com', 15),
('daniel.thompson@example.com', 16),
('jennifer.garcia@example.com', 17),
('matthew.martinez@example.com', 18),
('elizabeth.robinson@example.com', 19),
('anthony.clark@example.com', 20),
('susan.rodriguez@example.com', 21),
('mark.lewis@example.com', 22),
('mary.lee@example.com', 23),
('paul.walker@example.com', 24),
('nancy.hall@example.com', 25),
('steven.allen@example.com', 26),
('karen.young@example.com', 27),
('joshua.king@example.com', 28),
('betty.wright@example.com', 29),
('kevin.lopez@example.com', 30),
('helen.hill@example.com', 31),
('brian.scott@example.com', 32),
('sandra.green@example.com', 33),
('edward.adams@example.com', 34),
('donna.baker@example.com', 35);

-- Inserting Data into DoctorViewsHistory Table
INSERT INTO DoctorViewsHistory (history, doctor)
VALUES
(1, 'dr.james@example.com'),
(2, 'dr.susan@example.com'),
(3, 'dr.mike@example.com'),
(4, 'dr.linda@example.com'),
(5, 'dr.robert@example.com'),
(6, 'dr.karen@example.com'),
(7, 'dr.david@example.com'),
(8, 'dr.emily@example.com'),
(9, 'dr.john@example.com'),
(10, 'dr.sarah@example.com'),
(11, 'dr.michael@example.com'),
(12, 'dr.jessica@example.com'),
(13, 'dr.william@example.com'),
(14, 'dr.amy@example.com'),
(15, 'dr.richard@example.com'),
(16, 'dr.mary@example.com'),
(17, 'dr.thomas@example.com'),
(18, 'dr.patricia@example.com'),
(19, 'dr.charles@example.com'),
(20, 'dr.barbara@example.com'),
(21, 'dr.joseph@example.com'),
(22, 'dr.elizabeth@example.com'),
(23, 'dr.chris@example.com'),
(24, 'dr.nancy@example.com'),
(25, 'dr.daniel@example.com'),
(26, 'dr.lisa@example.com'),
(27, 'dr.paul@example.com'),
(28, 'dr.karen@example.com'),
(29, 'dr.kevin@example.com'),
(30, 'dr.helen@example.com'),
(31, 'dr.brian@example.com'),
(32, 'dr.sandra@example.com'),
(33, 'dr.edward@example.com'),
(34, 'dr.donna@example.com'),
(35, 'dr.ronald@example.com');

-- Inserting Data into Emergency Table
INSERT INTO Emergency (PatientID, PatientCondition, DoctorID, ArrivalTime)
VALUES
('john.doe@example.com', 'Severe Breathing Difficulty', 'dr.james@example.com', '2024-08-14 13:45:00'),
('jane.smith@example.com', 'High Fever and Dizziness', 'dr.susan@example.com', '2024-08-15 09:30:00'),
('alice.jones@example.com', 'Severe Headache', 'dr.mike@example.com', '2024-08-16 11:00:00'),
('michael.brown@example.com', 'Chest Pain', 'dr.linda@example.com', '2024-08-17 14:20:00'),
('emily.davis@example.com', 'Back Injury', 'dr.robert@example.com', '2024-08-18 16:45:00'),
('david.wilson@example.com', 'Joint Swelling', 'dr.karen@example.com', '2024-08-19 10:30:00'),
('sarah.miller@example.com', 'Extreme Fatigue', 'dr.david@example.com', '2024-08-20 12:15:00'),
('chris.moore@example.com', 'Dizziness and Nausea', 'dr.emily@example.com', '2024-08-21 09:50:00'),
('laura.taylor@example.com', 'Severe Abdominal Pain', 'dr.john@example.com', '2024-08-22 13:10:00'),
('james.anderson@example.com', 'Persistent Cough', 'dr.sarah@example.com', '2024-08-23 15:25:00'),
('linda.thomas@example.com', 'High Fever', 'dr.michael@example.com', '2024-08-24 17:40:00'),
('robert.jackson@example.com', 'Sore Throat', 'dr.jessica@example.com', '2024-08-25 11:05:00'),
('barbara.white@example.com', 'Ear Infection', 'dr.william@example.com', '2024-08-26 14:30:00'),
('charles.harris@example.com', 'Severe Stomach Ache', 'dr.amy@example.com', '2024-08-27 16:55:00'),
('patricia.martin@example.com', 'Swollen Ankle', 'dr.richard@example.com', '2024-08-28 10:20:00'),
('daniel.thompson@example.com', 'Burning Sensation', 'dr.mary@example.com', '2024-08-29 12:45:00'),
('jennifer.garcia@example.com', 'Blurred Vision', 'dr.thomas@example.com', '2024-08-30 15:10:00'),
('matthew.martinez@example.com', 'Cold Symptoms', 'dr.patricia@example.com', '2024-08-31 17:35:00'),
('elizabeth.robinson@example.com', 'Muscle Pain', 'dr.charles@example.com', '2024-09-01 09:00:00'),
('anthony.clark@example.com', 'Vomiting', 'dr.barbara@example.com', '2024-09-02 11:25:00'),
('susan.rodriguez@example.com', 'Diarrhea', 'dr.joseph@example.com', '2024-09-03 13:50:00'),
('mark.lewis@example.com', 'Constipation', 'dr.elizabeth@example.com', '2024-09-04 16:15:00'),
('mary.lee@example.com', 'Skin Rash', 'dr.chris@example.com', '2024-09-05 10:40:00'),
('paul.walker@example.com', 'Insomnia', 'dr.nancy@example.com', '2024-09-06 13:05:00'),
('nancy.hall@example.com', 'Anxiety Attack', 'dr.daniel@example.com', '2024-09-07 15:30:00'),
('steven.allen@example.com', 'Depression', 'dr.lisa@example.com', '2024-09-08 17:55:00'),
('karen.young@example.com', 'Unintentional Weight Loss', 'dr.paul@example.com', '2024-09-09 09:20:00'),
('joshua.king@example.com', 'Unintentional Weight Gain', 'dr.karen@example.com', '2024-09-10 11:45:00'),
('betty.wright@example.com', 'Hair Loss', 'dr.kevin@example.com', '2024-09-11 14:10:00'),
('kevin.lopez@example.com', 'Memory Loss', 'dr.helen@example.com', '2024-09-12 16:35:00'),
('helen.hill@example.com', 'Tingling Sensation', 'dr.brian@example.com', '2024-09-13 10:00:00'),
('brian.scott@example.com', 'Easy Bruising', 'dr.sandra@example.com', '2024-09-14 12:25:00'),
('sandra.green@example.com', 'Unexplained Bleeding', 'dr.edward@example.com', '2024-09-15 14:50:00'),
('edward.adams@example.com', 'Heart Palpitations', 'dr.donna@example.com', '2024-09-16 17:15:00'),
('donna.baker@example.com', 'Excessive Sweating', 'dr.ronald@example.com', '2024-09-17 09:40:00');

-- Inserting Data into Insurance Table
INSERT INTO Insurance (PatientID, ProviderName, PolicyNumber)
VALUES
('john.doe@example.com', 'HealthSecure', 'HS12345'),
('alice.jones@example.com', 'MediCare Plus', 'MC67890'),
('jane.smith@example.com', 'HealthFirst', 'HF11223'),
('michael.brown@example.com', 'WellCare', 'WC44556'),
('emily.davis@example.com', 'UnitedHealth', 'UH77889'),
('david.wilson@example.com', 'BlueCross', 'BC99001'),
('sarah.miller@example.com', 'Aetna', 'AE22334'),
('chris.moore@example.com', 'Cigna', 'CG55667'),
('laura.taylor@example.com', 'Humana', 'HM88990'),
('james.anderson@example.com', 'Kaiser', 'KP11223'),
('linda.thomas@example.com', 'Anthem', 'AT44556'),
('robert.jackson@example.com', 'Oscar', 'OS77889'),
('barbara.white@example.com', 'Molina', 'ML99001'),
('charles.harris@example.com', 'Centene', 'CN22334'),
('patricia.martin@example.com', 'Amerigroup', 'AG55667'),
('daniel.thompson@example.com', 'Medica', 'MD88990'),
('jennifer.garcia@example.com', 'HealthNet', 'HN11223'),
('matthew.martinez@example.com', 'Tricare', 'TR44556'),
('elizabeth.robinson@example.com', 'Fidelis', 'FD77889'),
('anthony.clark@example.com', 'MetroPlus', 'MP99001'),
('susan.rodriguez@example.com', 'Affinity', 'AF22334'),
('mark.lewis@example.com', 'EmblemHealth', 'EH55667'),
('mary.lee@example.com', 'Empire', 'EP88990'),
('paul.walker@example.com', 'Excellus', 'EX11223'),
('nancy.hall@example.com', 'HealthPartners', 'HP44556'),
('steven.allen@example.com', 'Independence', 'IN77889'),
('karen.young@example.com', 'Premera', 'PR99001'),
('joshua.king@example.com', 'Regence', 'RG22334'),
('betty.wright@example.com', 'SelectHealth', 'SH55667'),
('kevin.lopez@example.com', 'Tufts', 'TU88990'),
('helen.hill@example.com', 'UPMC', 'UP11223'),
('brian.scott@example.com', 'Wellmark', 'WM44556'),
('sandra.green@example.com', 'Geisinger', 'GS77889'),
('edward.adams@example.com', 'HealthAlliance', 'HA99001'),
('donna.baker@example.com', 'HealthPartners', 'HP22334'),
('ronald.nelson@example.com', 'Highmark', 'HM55667');

-- Inserting Data into RoomsAndWards Table
INSERT INTO RoomsAndWards (RoomID, RoomType, AvailabilityStatus, AssignedPatientID)
VALUES
(101, 'ICU', 'Occupied', 'john.doe@example.com'),
(102, 'General', 'Available', NULL),
(103, 'Private', 'Occupied', 'alice.jones@example.com'),
(104, 'ICU', 'Available', NULL),
(105, 'General', 'Occupied', 'jane.smith@example.com'),
(106, 'Private', 'Available', NULL),
(107, 'ICU', 'Occupied', 'michael.brown@example.com'),
(108, 'General', 'Available', NULL),
(109, 'Private', 'Occupied', 'emily.davis@example.com'),
(110, 'ICU', 'Available', NULL),
(111, 'General', 'Occupied', 'david.wilson@example.com'),
(112, 'Private', 'Available', NULL),
(113, 'ICU', 'Occupied', 'sarah.miller@example.com'),
(114, 'General', 'Available', NULL),
(115, 'Private', 'Occupied', 'chris.moore@example.com'),
(116, 'ICU', 'Available', NULL),
(117, 'General', 'Occupied', 'laura.taylor@example.com'),
(118, 'Private', 'Available', NULL),
(119, 'ICU', 'Occupied', 'james.anderson@example.com'),
(120, 'General', 'Available', NULL),
(121, 'Private', 'Occupied', 'linda.thomas@example.com'),
(122, 'ICU', 'Available', NULL),
(123, 'General', 'Occupied', 'robert.jackson@example.com'),
(124, 'Private', 'Available', NULL),
(125, 'ICU', 'Occupied', 'barbara.white@example.com'),
(126, 'General', 'Available', NULL),
(127, 'Private', 'Occupied', 'charles.harris@example.com'),
(128, 'ICU', 'Available', NULL),
(129, 'General', 'Occupied', 'patricia.martin@example.com'),
(130, 'Private', 'Available', NULL),
(131, 'ICU', 'Occupied', 'daniel.thompson@example.com'),
(132, 'General', 'Available', NULL),
(133, 'Private', 'Occupied', 'jennifer.garcia@example.com'),
(134, 'ICU', 'Available', NULL),
(135, 'General', 'Occupied', 'matthew.martinez@example.com');

-- Inserting Data into SupportStaff Table
INSERT INTO SupportStaff (StaffID, Name, Role, Department, Shift)
VALUES
(1, 'Emily Johnson', 'Nurse', 'Emergency', 'Day'),
(2, 'Mark Lee', 'Technician', 'Radiology', 'Night'),
(3, 'Rachel Green', 'Admin', 'Reception', 'Morning'),
(4, 'John Smith', 'Nurse', 'ICU', 'Night'),
(5, 'Linda Brown', 'Technician', 'Laboratory', 'Day'),
(6, 'Michael Davis', 'Admin', 'Billing', 'Morning'),
(7, 'Sarah Wilson', 'Nurse', 'General Ward', 'Day'),
(8, 'David Miller', 'Technician', 'Pharmacy', 'Night'),
(9, 'Laura Moore', 'Admin', 'Records', 'Morning'),
(10, 'James Taylor', 'Nurse', 'Surgery', 'Day'),
(11, 'Barbara Anderson', 'Technician', 'Radiology', 'Night'),
(12, 'Robert Thomas', 'Admin', 'Reception', 'Morning'),
(13, 'Patricia Jackson', 'Nurse', 'Emergency', 'Day'),
(14, 'Charles Harris', 'Technician', 'Laboratory', 'Night'),
(15, 'Jennifer Martin', 'Admin', 'Billing', 'Morning'),
(16, 'Daniel Thompson', 'Nurse', 'ICU', 'Day'),
(17, 'Matthew Garcia', 'Technician', 'Pharmacy', 'Night'),
(18, 'Elizabeth Martinez', 'Admin', 'Records', 'Morning'),
(19, 'Anthony Robinson', 'Nurse', 'General Ward', 'Day'),
(20, 'Susan Clark', 'Technician', 'Radiology', 'Night'),
(21, 'Mark Lewis', 'Admin', 'Reception', 'Morning'),
(22, 'Mary Walker', 'Nurse', 'Surgery', 'Day'),
(23, 'Paul Hall', 'Technician', 'Laboratory', 'Night'),
(24, 'Nancy Allen', 'Admin', 'Billing', 'Morning'),
(25, 'Steven Young', 'Nurse', 'Emergency', 'Day'),
(26, 'Karen King', 'Technician', 'Pharmacy', 'Night'),
(27, 'Joshua Wright', 'Admin', 'Records', 'Morning'),
(28, 'Betty Lopez', 'Nurse', 'ICU', 'Day'),
(29, 'Kevin Hill', 'Technician', 'Radiology', 'Night'),
(30, 'Helen Scott', 'Admin', 'Reception', 'Morning'),
(31, 'Brian Green', 'Nurse', 'General Ward', 'Day'),
(32, 'Sandra Adams', 'Technician', 'Laboratory', 'Night'),
(33, 'Edward Baker', 'Admin', 'Billing', 'Morning'),
(34, 'Donna Nelson', 'Nurse', 'Surgery', 'Day'),
(35, 'Ronald Carter', 'Technician', 'Pharmacy', 'Night');

-- Inserting Data into BillingAndPayments Table
INSERT INTO BillingAndPayments (patient_id, appointment_id, total_amount, paid_amount, payment_method, payment_status, payment_date)
VALUES
('john.doe@example.com', 1, 500.00, 500.00, 'Card', 'Paid', '2024-08-10 12:00:00'),
('jane.smith@example.com', 2, 300.00, 150.00, 'Insurance', 'Partially Paid', '2024-08-12 14:00:00'),
('alice.jones@example.com', 3, 200.00, 0.00, 'Online', 'Pending', '2024-08-13 16:00:00'),
('michael.brown@example.com', 4, 450.00, 450.00, 'Cash', 'Paid', '2024-08-14 10:00:00'),
('emily.davis@example.com', 5, 350.00, 200.00, 'Insurance', 'Partially Paid', '2024-08-15 11:00:00'),
('david.wilson@example.com', 6, 250.00, 0.00, 'Online', 'Pending', '2024-08-16 12:00:00'),
('sarah.miller@example.com', 7, 600.00, 600.00, 'Card', 'Paid', '2024-08-17 13:00:00'),
('chris.moore@example.com', 8, 400.00, 200.00, 'Insurance', 'Partially Paid', '2024-08-18 14:00:00'),
('laura.taylor@example.com', 9, 300.00, 0.00, 'Online', 'Pending', '2024-08-19 15:00:00'),
('james.anderson@example.com', 10, 700.00, 700.00, 'Card', 'Paid', '2024-08-20 16:00:00'),
('linda.thomas@example.com', 11, 500.00, 250.00, 'Insurance', 'Partially Paid', '2024-08-21 17:00:00'),
('robert.jackson@example.com', 12, 200.00, 0.00, 'Online', 'Pending', '2024-08-22 18:00:00'),
('barbara.white@example.com', 13, 800.00, 800.00, 'Card', 'Paid', '2024-08-23 19:00:00'),
('charles.harris@example.com', 14, 400.00, 200.00, 'Insurance', 'Partially Paid', '2024-08-24 20:00:00'),
('patricia.martin@example.com', 15, 300.00, 0.00, 'Online', 'Pending', '2024-08-25 21:00:00'),
('daniel.thompson@example.com', 16, 900.00, 900.00, 'Card', 'Paid', '2024-08-26 22:00:00'),
('jennifer.garcia@example.com', 17, 500.00, 250.00, 'Insurance', 'Partially Paid', '2024-08-27 23:00:00'),
('matthew.martinez@example.com', 18, 200.00, 0.00, 'Online', 'Pending', '2024-08-28 08:00:00'),
('elizabeth.robinson@example.com', 19, 1000.00, 1000.00, 'Card', 'Paid', '2024-08-29 09:00:00'),
('anthony.clark@example.com', 20, 600.00, 300.00, 'Insurance', 'Partially Paid', '2024-08-30 10:00:00'),
('susan.rodriguez@example.com', 21, 400.00, 0.00, 'Online', 'Pending', '2024-08-31 11:00:00'),
('mark.lewis@example.com', 22, 1100.00, 1100.00, 'Card', 'Paid', '2024-09-01 12:00:00'),
('mary.lee@example.com', 23, 500.00, 250.00, 'Insurance', 'Partially Paid', '2024-09-02 13:00:00'),
('paul.walker@example.com', 24, 200.00, 0.00, 'Online', 'Pending', '2024-09-03 14:00:00'),
('nancy.hall@example.com', 25, 1200.00, 1200.00, 'Card', 'Paid', '2024-09-04 15:00:00'),
('steven.allen@example.com', 26, 600.00, 300.00, 'Insurance', 'Partially Paid', '2024-09-05 16:00:00'),
('karen.young@example.com', 27, 400.00, 0.00, 'Online', 'Pending', '2024-09-06 17:00:00'),
('joshua.king@example.com', 28, 1300.00, 1300.00, 'Card', 'Paid', '2024-09-07 18:00:00'),
('betty.wright@example.com', 29, 700.00, 350.00, 'Insurance', 'Partially Paid', '2024-09-08 19:00:00'),
('kevin.lopez@example.com', 30, 400.00, 0.00, 'Online', 'Pending', '2024-09-09 20:00:00'),
('helen.hill@example.com', 31, 1400.00, 1400.00, 'Card', 'Paid', '2024-09-10 21:00:00'),
('brian.scott@example.com', 32, 800.00, 400.00, 'Insurance', 'Partially Paid', '2024-09-11 22:00:00'),
('sandra.green@example.com', 33, 400.00, 0.00, 'Online', 'Pending', '2024-09-12 23:00:00'),
('edward.adams@example.com', 34, 1500.00, 1500.00, 'Card', 'Paid', '2024-09-13 08:00:00'),
('donna.baker@example.com', 35, 900.00, 450.00, 'Insurance', 'Partially Paid', '2024-09-14 09:00:00');

-- Inserting Data into MedicineInventory Table
INSERT INTO MedicineInventory (medicine_id, medicine_name, batch_number, manufacturer, category, quantity, unit_price, expiry_date)
VALUES
(1, 'Paracetamol', 'B12345', 'MediCare Pharma', 'Tablet', 100, 0.50, '2025-12-31'),
(2, 'Amoxicillin', 'A98765', 'HealthPlus Ltd.', 'Capsule', 50, 1.20, '2025-06-30'),
(3, 'Cough Syrup', 'C67890', 'GoodHealth Co.', 'Syrup', 30, 3.75, '2024-11-30'),
(4, 'Insulin Injection', 'I54321', 'Wellness Pharma', 'Injection', 20, 25.00, '2025-04-15'),
(5, 'Antifungal Cream', 'F11122', 'SkinCare Ltd.', 'Ointment', 15, 5.99, '2025-09-10'),
(6, 'Ibuprofen', 'I12345', 'PainRelief Pharma', 'Tablet', 200, 0.75, '2025-10-31'),
(7, 'Metformin', 'M98765', 'DiabetesCare Ltd.', 'Tablet', 100, 1.50, '2025-07-30'),
(8, 'Antacid', 'A67890', 'DigestiveHealth Co.', 'Tablet', 50, 0.60, '2024-12-31'),
(9, 'Vitamin D', 'V54321', 'Wellness Pharma', 'Capsule', 40, 0.80, '2025-05-15'),
(10, 'Antibiotic Ointment', 'O11122', 'SkinCare Ltd.', 'Ointment', 25, 4.99, '2025-08-10');




