USE HRAuditDB;
GO

-- Test 1: Promotion and Transfer
EXEC dbo.usp_TransferAndPromoteEmployee 
    @EmployeeID = 100, 
    @NewDepartmentID = 3, 
    @NewJobTitle = 'Senior Database Architect', 
    @NewSalary = 10500.00;
GO

-- Test 2: Verify Audit Logs
SELECT * FROM AuditLogs;

-- Test 3: Check Temporal Table History
SELECT * FROM EmployeePositions WHERE EmployeeID = 100;
SELECT * FROM dbo.EmployeePositionsHistory WHERE EmployeeID = 100;

-- Test 4: Historical point-in-time query
SELECT * 
FROM EmployeePositions 
FOR SYSTEM_TIME ALL
WHERE EmployeeID = 100;
