-- 1. Create Database
CREATE DATABASE HRAuditDB;
GO

USE HRAuditDB;
GO

-- 2. Departments Table
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL UNIQUE,
    Budget DECIMAL(15,2) NOT NULL CHECK (Budget >= 0)
);
GO

-- 3. Employees Table
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(100,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    NationalCode CHAR(10) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    HireDate DATE NOT NULL,
    DepartmentID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID)
);
GO

-- 4. Temporal Table for Employee Positions
CREATE TABLE EmployeePositions (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL,
    BaseSalary DECIMAL(12,2) NOT NULL CHECK (BaseSalary > 0),
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime),
    CONSTRAINT FK_EmployeePositions_Employees FOREIGN KEY (EmployeeID) 
        REFERENCES Employees(EmployeeID)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeePositionsHistory));
GO

-- 5. Audit Logs Table
CREATE TABLE AuditLogs (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50) NOT NULL,
    ActionType NVARCHAR(20) NOT NULL,
    RecordID INT NOT NULL,
    PerformedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),
    ActionDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    OldValues NVARCHAR(MAX) NULL,
    NewValues NVARCHAR(MAX) NULL
);
GO
