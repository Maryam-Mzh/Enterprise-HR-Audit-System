USE HRAuditDB;
GO

-- درج دپارتمان‌ها
INSERT INTO Departments (DepartmentName, Budget)
VALUES 
('Human Resources', 150000.00),
('Information Technology', 500000.00),
('Finance', 300000.00),
('Sales & Marketing', 400000.00);
GO

-- درج کارمندان
INSERT INTO Employees (FirstName, LastName, NationalCode, Email, HireDate, DepartmentID)
VALUES 
('David', 'Miller', '1234567890', 'david.m@company.com', '2021-03-15', 2),
('Sarah', 'Connor', '2345678901', 'sarah.c@company.com', '2022-06-01', 1),
('Alex', 'Murphy', '3456789012', 'alex.m@company.com', '2023-01-10', 2);
GO

-- درج سمت و حقوق اولیه
INSERT INTO EmployeePositions (EmployeeID, JobTitle, BaseSalary)
VALUES 
(100, 'Database Administrator', 8500.00),
(101, 'HR Specialist', 5200.00),
(102, 'Junior Systems Analyst', 4800.00);
GO
