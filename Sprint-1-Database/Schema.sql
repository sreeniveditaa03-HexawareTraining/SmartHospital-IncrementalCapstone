CREATE DATABASE SmartHospitalDB;

USE SmartHospitalDB;

CREATE TABLE Clinic (
    ClinicID INT IDENTITY(1,1) PRIMARY KEY,
    ClinicName VARCHAR(100),
    City VARCHAR(50),
    ContactNumber VARCHAR(20)
);

CREATE TABLE Patient (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10),
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    BloodGroup VARCHAR(5),
    RegisteredDate DATE
);

CREATE TABLE Doctor (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(80),
    ClinicID INT,
    ConsultationFee DECIMAL(10,2)
        CHECK (ConsultationFee >= 0),
    YearsOfExperience INT,

    CONSTRAINT FK_Doctor_Clinic
        FOREIGN KEY (ClinicID)
        REFERENCES Clinic(ClinicID)
);

CREATE TABLE Appointment (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME2 NOT NULL,
    Status VARCHAR(20) DEFAULT 'Scheduled',
    Reason VARCHAR(200),

    CONSTRAINT FK_Appointment_Patient
        FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),

    CONSTRAINT FK_Appointment_Doctor
        FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID),

    CONSTRAINT UQ_Doctor_Appointment
        UNIQUE (DoctorID, AppointmentDate)
);

CREATE TABLE Prescription (
    PrescriptionID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    MedicineName VARCHAR(100),
    Dosage VARCHAR(50),
    DurationDays INT
        CHECK (DurationDays > 0),

    CONSTRAINT FK_Prescription_Appointment
        FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
);

CREATE TABLE Billing (
    BillID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    Amount DECIMAL(10,2)
        CHECK (Amount >= 0),
    PaymentStatus VARCHAR(20),
    BillDate DATE,

    CONSTRAINT FK_Billing_Appointment
        FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;