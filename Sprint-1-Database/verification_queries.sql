USE SmartHospitalDB;
GO

-- 1. Count records in all tables
SELECT 'Clinic' AS TableName, COUNT(*) AS TotalRecords FROM Clinic
UNION ALL
SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL
SELECT 'Doctor', COUNT(*) FROM Doctor
UNION ALL
SELECT 'Appointment', COUNT(*) FROM Appointment
UNION ALL
SELECT 'Prescription', COUNT(*) FROM Prescription
UNION ALL
SELECT 'Billing', COUNT(*) FROM Billing;
GO

-- 2. View patients
SELECT * FROM Patient;
GO

-- 3. View doctors with clinics
SELECT
    D.DoctorID,
    D.FirstName,
    D.LastName,
    D.Specialization,
    C.ClinicName,
    D.ConsultationFee
FROM Doctor D
JOIN Clinic C
    ON D.ClinicID = C.ClinicID;
GO

-- 4. View appointments with patient and doctor names
SELECT
    A.AppointmentID,
    P.FirstName + ' ' + P.LastName AS PatientName,
    D.FirstName + ' ' + D.LastName AS DoctorName,
    D.Specialization,
    A.AppointmentDate,
    A.Status,
    A.Reason
FROM Appointment A
JOIN Patient P
    ON A.PatientID = P.PatientID
JOIN Doctor D
    ON A.DoctorID = D.DoctorID
ORDER BY A.AppointmentDate;
GO

-- 5. View prescriptions
SELECT * FROM Prescription;
GO

-- 6. View billing
SELECT * FROM Billing;
GO