CREATE DATABASE HospitalManagement_ERD;
USE HospitalManagement_ERD;

CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT,
    patient_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    registration_date DATE NOT NULL,

    CONSTRAINT pk_patients
        PRIMARY KEY (patient_id),

    CONSTRAINT chk_patient_age
        CHECK (age IS NULL OR age >= 0)
) ENGINE=InnoDB;

CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),

    CONSTRAINT pk_departments
        PRIMARY KEY (department_id),

    CONSTRAINT uq_department_name
        UNIQUE (department_name)
) ENGINE=InnoDB;


-- TABLE 3: DOCTORS

CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20) NOT NULL UNIQUE,
    consultation_fee DECIMAL(10,2) NOT NULL,
    department_id INT NOT NULL,

    CONSTRAINT pk_doctors
        PRIMARY KEY (doctor_id),

    CONSTRAINT chk_consultation_fee
        CHECK (consultation_fee >= 0),

    CONSTRAINT fk_doctors_department
        FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',

    CONSTRAINT pk_appointments
        PRIMARY KEY (appointment_id),

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES Doctors(doctor_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    INDEX idx_appointment_date (appointment_date)
) ENGINE=InnoDB;


CREATE TABLE Bills (
    bill_id INT AUTO_INCREMENT,
    patient_id INT NOT NULL,
    appointment_id INT NOT NULL,
    consultation_amount DECIMAL(10,2) NOT NULL,
    medicine_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    bill_date DATE NOT NULL,

    CONSTRAINT pk_bills
        PRIMARY KEY (bill_id),

    CONSTRAINT uq_bill_appointment
        UNIQUE (appointment_id),

    CONSTRAINT fk_bills_patient
        FOREIGN KEY (patient_id)
        REFERENCES Patients(patient_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_bills_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES Appointments(appointment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_bill_amounts
        CHECK (
            consultation_amount >= 0
            AND medicine_amount >= 0
            AND total_amount >= 0
        )
) ENGINE=InnoDB;


ALTER TABLE Patients
ADD address VARCHAR(200);


ALTER TABLE Patients
MODIFY phone VARCHAR(20);


ALTER TABLE Doctors
RENAME COLUMN specialization TO expertise;


ALTER TABLE Patients
DROP COLUMN address;

INSERT INTO Patients
(patient_name, age, gender, phone, email, city, registration_date)
VALUES
('Ancy',22,'Female','9876543210','ancy@gmail.com','Kochi','2026-01-10'),
('Arun',55,'Male','9876543211','arun@gmail.com','Trivandrum','2026-01-15'),
('Sneha',30,'Female','9876543212','sneha@gmail.com','Calicut','2026-02-01'),
('Anand',45,'Male','9876543213','anand@gmail.com','Kochi','2026-02-05'),
('Meera',35,'Female','9876543214','meera@gmail.com','Kollam','2026-02-10'),
('Rahul',60,'Male','9876543215','rahul@gmail.com','Calicut','2026-03-01'),
('Sanjay',28,'Male','9876543216','sanjay@gmail.com','Kochi','2026-03-05'),
('Divya',40,'Female','9876543217','divya@gmail.com','Trivandrum','2026-03-10'),
('Kiran',50,'Male','9876543218','kiran@gmail.com','Kannur','2026-04-01'),
('Nisha',25,'Female','9876543219','nisha@gmail.com','Kollam','2026-04-05');


INSERT INTO Departments
(department_name, location)
VALUES
('Cardiology','Block A'),
('Neurology','Block B'),
('Orthopedics','Block C'),
('Pediatrics','Block D'),
('Dermatology','Block E');


INSERT INTO Doctors
(doctor_name, expertise, phone, consultation_fee, department_id)
VALUES
('Dr. Arun','Heart Specialist','9000000001',800,1),
('Dr. John','Brain Specialist','9000000002',1000,2),
('Dr. Priya','Bone Specialist','9000000003',600,3),
('Dr. Meera','Child Specialist','9000000004',500,4),
('Dr. David','Skin Specialist','9000000005',700,5),
('Dr. Anjali','Cardiologist','9000000006',1200,1),
('Dr. Rahul','Neurologist','9000000007',900,2),
('Dr. Sneha','Heart Specialist','9000000008',750,1);


INSERT INTO Appointments
(patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES
(1,1,'2026-01-12','09:00:00','Scheduled'),
(2,2,'2026-01-16','10:00:00','Scheduled'),
(3,3,'2026-02-02','11:00:00','Completed'),
(4,1,'2026-02-06','09:30:00','Scheduled'),
(5,4,'2026-02-11','12:00:00','Completed'),
(6,5,'2026-03-02','10:30:00','Scheduled'),
(7,6,'2026-03-06','11:30:00','Scheduled'),
(8,7,'2026-03-11','09:00:00','Completed'),
(9,8,'2026-04-02','10:00:00','Scheduled'),
(10,1,'2026-04-06','11:00:00','Scheduled'),
(1,2,'2026-04-10','12:00:00','Completed'),
(2,3,'2026-04-12','09:30:00','Scheduled'),
(3,4,'2026-04-15','10:30:00','Scheduled'),
(4,5,'2026-04-18','11:30:00','Completed'),
(5,6,'2026-04-20','09:00:00','Scheduled');

INSERT INTO Bills
(patient_id, appointment_id, consultation_amount,
 medicine_amount, total_amount, payment_status, bill_date)
VALUES
(1,1,800,500,1300,'Pending','2026-01-12'),
(2,2,1000,700,1700,'Paid','2026-01-16'),
(3,3,600,300,900,'Paid','2026-02-02'),
(4,4,800,400,1200,'Pending','2026-02-06'),
(5,5,500,250,750,'Paid','2026-02-11'),
(6,6,700,600,1300,'Pending','2026-03-02'),
(7,7,1200,800,2000,'Paid','2026-03-06'),
(8,8,900,350,1250,'Pending','2026-03-11'),
(9,9,750,450,1200,'Paid','2026-04-02'),
(10,10,800,500,1300,'Pending','2026-04-06');


INSERT INTO Patients
(patient_name, age, gender, phone, email, city, registration_date)
VALUES
('Kavya',24,'Female','9876543220','kavya@gmail.com','Kochi','2026-05-01');


INSERT INTO Departments
(department_name, location)
VALUES
('ENT','Block F');


INSERT INTO Doctors
(doctor_name, expertise, phone, consultation_fee, department_id)
VALUES
('Dr. Kumar','ENT Specialist','9000000009',850,6);


UPDATE Patients
SET phone = '9998887770'
WHERE patient_id = 1;


UPDATE Doctors
SET consultation_fee = 1500
WHERE doctor_id = 1;


UPDATE Appointments
SET status = 'Completed'
WHERE appointment_id = 1;


UPDATE Bills
SET payment_status = 'Paid'
WHERE bill_id = 1;


DELETE FROM Patients
WHERE patient_id = 11
AND NOT EXISTS (
    SELECT 1
    FROM Appointments
    WHERE Appointments.patient_id = Patients.patient_id
);

SELECT * FROM Patients;
SELECT * FROM Departments;
SELECT * FROM Doctors;
SELECT * FROM Appointments;
SELECT * FROM Bills;


SELECT * FROM Patients
WHERE city = 'Kochi';

SELECT * FROM Patients
WHERE age > 50;


SELECT * FROM Patients
WHERE patient_name LIKE 'S%';


SELECT * FROM Patients
WHERE patient_name LIKE '%an%';


SELECT * FROM Patients
WHERE age BETWEEN 20 AND 40;


SELECT Doctors.*
FROM Doctors
JOIN Departments
ON Doctors.department_id = Departments.department_id
WHERE Departments.department_name
IN ('Cardiology','Neurology');


SELECT * FROM Patients
WHERE email IS NOT NULL;


SELECT * FROM Doctors
WHERE consultation_fee > 500;


SELECT * FROM Patients
ORDER BY registration_date DESC;


SELECT * FROM Patients
ORDER BY registration_date DESC
LIMIT 5;


SELECT * FROM Appointments
WHERE status = 'Scheduled';


SELECT * FROM Bills
WHERE payment_status = 'Pending';


SELECT COUNT(*) AS total_patients
FROM Patients;


SELECT AVG(age) AS average_age
FROM Patients;


SELECT MAX(consultation_fee) AS highest_fee
FROM Doctors;


SELECT MIN(consultation_fee) AS lowest_fee
FROM Doctors;


SELECT SUM(total_amount) AS total_collected
FROM Bills
WHERE payment_status = 'Paid';


SELECT city, COUNT(*) AS total_patients
FROM Patients
GROUP BY city;


SELECT Departments.department_name,
       COUNT(Doctors.doctor_id) AS total_doctors
FROM Departments
LEFT JOIN Doctors
ON Departments.department_id = Doctors.department_id
GROUP BY Departments.department_id,
         Departments.department_name;


SELECT doctor_id,
       COUNT(*) AS total_appointments
FROM Appointments
GROUP BY doctor_id;


SELECT Departments.department_name,
       COUNT(Doctors.doctor_id) AS total_doctors
FROM Departments
JOIN Doctors
ON Departments.department_id = Doctors.department_id
GROUP BY Departments.department_id,
         Departments.department_name
HAVING COUNT(Doctors.doctor_id) > 2;

-- 10. Average consultation fee
SELECT AVG(consultation_fee) AS average_fee
FROM Doctors;


SELECT Patients.patient_name,
       Appointments.appointment_date
FROM Patients
INNER JOIN Appointments
ON Patients.patient_id = Appointments.patient_id;


SELECT Doctors.doctor_name,
       Departments.department_name
FROM Doctors
INNER JOIN Departments
ON Doctors.department_id = Departments.department_id;


SELECT Patients.patient_name,
       Doctors.doctor_name,
       Appointments.appointment_date
FROM Appointments
JOIN Patients
ON Appointments.patient_id = Patients.patient_id
JOIN Doctors
ON Appointments.doctor_id = Doctors.doctor_id;


SELECT Patients.patient_name,
       Appointments.appointment_date
FROM Patients
LEFT JOIN Appointments
ON Patients.patient_id = Appointments.patient_id;


SELECT Departments.department_name,
       Doctors.doctor_name
FROM Departments
LEFT JOIN Doctors
ON Departments.department_id = Doctors.department_id;


SELECT Patients.patient_name,
       Bills.total_amount
FROM Patients
JOIN Bills
ON Patients.patient_id = Bills.patient_id;


SELECT Doctors.doctor_name,
       COUNT(Appointments.appointment_id) AS total_appointments
FROM Doctors
LEFT JOIN Appointments
ON Doctors.doctor_id = Appointments.doctor_id
GROUP BY Doctors.doctor_id,
         Doctors.doctor_name;


SELECT Patients.patient_name,
       Doctors.doctor_name,
       Appointments.status
FROM Appointments
JOIN Patients
ON Appointments.patient_id = Patients.patient_id
JOIN Doctors
ON Appointments.doctor_id = Doctors.doctor_id;


SELECT *
FROM Patients
WHERE age > (
    SELECT AVG(age)
    FROM Patients
);


SELECT *
FROM Doctors
WHERE consultation_fee = (
    SELECT MAX(consultation_fee)
    FROM Doctors
);


SELECT *
FROM Doctors
WHERE consultation_fee > (
    SELECT AVG(consultation_fee)
    FROM Doctors
);


SELECT *
FROM Patients
WHERE patient_id IN (
    SELECT patient_id
    FROM Appointments
    WHERE doctor_id IN (
        SELECT doctor_id
        FROM Doctors
        WHERE doctor_name = 'Dr. Arun'
    )
);


SELECT *
FROM Bills
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM Bills
);


SELECT Doctors.doctor_id,
       Doctors.doctor_name,
       COUNT(Appointments.appointment_id) AS total_appointments
FROM Doctors
LEFT JOIN Appointments
ON Doctors.doctor_id = Appointments.doctor_id
GROUP BY Doctors.doctor_id,
         Doctors.doctor_name
HAVING COUNT(Appointments.appointment_id) > (
    SELECT AVG(appointment_count)
    FROM (
        SELECT COUNT(Appointments.appointment_id) AS appointment_count
        FROM Doctors
        LEFT JOIN Appointments
        ON Doctors.doctor_id = Appointments.doctor_id
        GROUP BY Doctors.doctor_id
    ) AS doctor_counts
);


SELECT UPPER(patient_name) AS uppercase_name
FROM Patients;


SELECT LOWER(doctor_name) AS lowercase_name
FROM Doctors;


SELECT patient_name,
       LENGTH(patient_name) AS name_length
FROM Patients;


SELECT CURDATE() AS today_date;


SELECT YEAR(registration_date) AS registration_year
FROM Patients;


SELECT patient_name,
       YEAR(registration_date) AS registration_year
FROM Patients;


SELECT doctor_name,
       ROUND(consultation_fee) AS rounded_fee
FROM Doctors;


SELECT department_name,
       SUBSTRING(department_name, 1, 3) AS short_name
FROM Departments;


SELECT appointment_date,
       MONTH(appointment_date) AS appointment_month
FROM Appointments;


SELECT bill_id,
       consultation_amount + medicine_amount AS calculated_total
FROM Bills;

SHOW DATABASES;

USE HospitalManagement_ERD;

SHOW TABLES;

DESC Patients;
DESC Departments;
DESC Doctors;
DESC Appointments;
DESC Bills;

SELECT * FROM Patients;
SELECT * FROM Departments;
SELECT * FROM Doctors;
SELECT * FROM Appointments;
SELECT * FROM Bills;


