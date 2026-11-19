USE SmartHospitalDB;

INSERT INTO Clinic (ClinicName, City, ContactNumber)
VALUES
('Meridian Central Clinic', 'Chennai', '9876500001'),
('Meridian North Clinic', 'Chennai', '9876500002'),
('Meridian South Clinic', 'Chennai', '9876500003'),
('Meridian East Clinic', 'Chennai', '9876500004'),
('Meridian West Clinic', 'Chennai', '9876500005'),
('Meridian Health Clinic', 'Coimbatore', '9876500006'),
('Meridian Care Clinic', 'Madurai', '9876500007'),
('Meridian Wellness Clinic', 'Salem', '9876500008'),
('Meridian Specialty Clinic', 'Trichy', '9876500009'),
('Meridian Regional Hospital', 'Chennai', '9876500010');

INSERT INTO Patient
(FirstName, LastName, DateOfBirth, Gender, Phone, Email, BloodGroup, RegisteredDate)
VALUES
('Arun', 'Kumar', '1998-05-12', 'Male', '9000000001', 'arun.k@example.com', 'O+', '2026-01-10'),
('Priya', 'Sharma', '2000-08-22', 'Female', '9000000002', 'priya.s@example.com', 'A+', '2026-01-11'),
('Rahul', 'Reddy', '1995-11-30', 'Male', '9000000003', 'rahul.r@example.com', 'B+', '2026-01-12'),
('Divya', 'Nair', '2002-02-18', 'Female', '9000000004', 'divya.n@example.com', 'AB+', '2026-01-13'),
('Karthik', 'Raj', '1989-07-25', 'Male', '9000000005', 'karthik.r@example.com', 'O-', '2026-01-14'),
('Meena', 'Lakshmi', '1978-03-09', 'Female', '9000000006', 'meena.l@example.com', 'A-', '2026-01-15'),
('Vijay', 'Anand', '1992-09-14', 'Male', '9000000007', 'vijay.a@example.com', 'B-', '2026-01-16'),
('Sneha', 'Mohan', '2001-12-05', 'Female', '9000000008', 'sneha.m@example.com', 'O+', '2026-01-17'),
('Ajay', 'Prakash', '1985-06-20', 'Male', '9000000009', 'ajay.p@example.com', 'AB-', '2026-01-18'),
('Lakshmi', 'Devi', '1999-04-02', 'Female', '9000000010', 'lakshmi.d@example.com', 'A+', '2026-01-19');

INSERT INTO Doctor
(FirstName, LastName, Specialization, ClinicID, ConsultationFee, YearsOfExperience)
VALUES
('Ramesh', 'Iyer', 'Cardiology', 1, 800.00, 15),
('Anitha', 'Rajan', 'Dermatology', 2, 600.00, 10),
('Suresh', 'Menon', 'Orthopedics', 3, 750.00, 12),
('Kavitha', 'Balan', 'Pediatrics', 4, 500.00, 8),
('Arvind', 'Shankar', 'Neurology', 5, 1000.00, 18),
('Deepa', 'Krishnan', 'Gynecology', 6, 700.00, 11),
('Manoj', 'Kumar', 'General Medicine', 7, 400.00, 7),
('Revathi', 'Sundar', 'ENT', 8, 550.00, 9),
('Naveen', 'Joseph', 'Ophthalmology', 9, 650.00, 6),
('Swetha', 'Ravi', 'General Medicine', 10, 450.00, 5);

;WITH AppointmentDays AS (
    SELECT 0 AS DayOffset
    UNION ALL
    SELECT DayOffset + 1
    FROM AppointmentDays
    WHERE DayOffset < 19
),
Doctors AS (
    SELECT DoctorID,
           ROW_NUMBER() OVER (ORDER BY DoctorID) AS DoctorNumber
    FROM Doctor
),
Patients AS (
    SELECT PatientID,
           ROW_NUMBER() OVER (ORDER BY PatientID) AS PatientNumber
    FROM Patient
)
INSERT INTO Appointment
(PatientID, DoctorID, AppointmentDate, Status, Reason)
SELECT
    p.PatientID,
    d.DoctorID,
    DATEADD(
        MINUTE,
        (d.DoctorNumber - 1) * 30,
        DATEADD(
            DAY,
            ad.DayOffset,
            CAST('2026-01-01' AS DATETIME2)
        )
    ),
    CASE
        WHEN ad.DayOffset % 5 = 0 THEN 'Completed'
        WHEN ad.DayOffset % 5 = 1 THEN 'Scheduled'
        WHEN ad.DayOffset % 5 = 2 THEN 'Cancelled'
        WHEN ad.DayOffset % 5 = 3 THEN 'Completed'
        ELSE 'Scheduled'
    END,
    CASE
        WHEN ad.DayOffset % 4 = 0 THEN 'Regular checkup'
        WHEN ad.DayOffset % 4 = 1 THEN 'Follow-up'
        WHEN ad.DayOffset % 4 = 2 THEN 'General consultation'
        ELSE 'Health screening'
    END
FROM AppointmentDays ad
CROSS JOIN Doctors d
JOIN Patients p
    ON p.PatientNumber =
       ((ad.DayOffset + d.DoctorNumber - 1) % 10) + 1
OPTION (MAXRECURSION 100);

INSERT INTO Prescription
(AppointmentID, MedicineName, Dosage, DurationDays)
SELECT
    AppointmentID,
    CASE
        WHEN AppointmentID % 5 = 0 THEN 'Paracetamol'
        WHEN AppointmentID % 5 = 1 THEN 'Cetirizine'
        WHEN AppointmentID % 5 = 2 THEN 'Amoxicillin'
        WHEN AppointmentID % 5 = 3 THEN 'Vitamin D'
        ELSE 'Ibuprofen'
    END,
    '1 tablet twice daily',
    5 + (AppointmentID % 10)
FROM (
    SELECT TOP 10 AppointmentID
    FROM Appointment
    ORDER BY AppointmentID
) A;

INSERT INTO Billing
(AppointmentID, Amount, PaymentStatus, BillDate)
SELECT
    AppointmentID,
    CASE
        WHEN AppointmentID % 5 = 0 THEN 800.00
        WHEN AppointmentID % 5 = 1 THEN 600.00
        WHEN AppointmentID % 5 = 2 THEN 750.00
        WHEN AppointmentID % 5 = 3 THEN 500.00
        ELSE 400.00
    END,
    CASE
        WHEN AppointmentID % 2 = 0 THEN 'Paid'
        ELSE 'Pending'
    END,
    CAST(AppointmentDate AS DATE)
FROM (
    SELECT TOP 10 AppointmentID, AppointmentDate
    FROM Appointment
    ORDER BY AppointmentID
) A;
