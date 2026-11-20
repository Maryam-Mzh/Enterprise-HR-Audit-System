USE HRAuditDB;
GO

-- 1. Audit Trigger to capture changes in JSON format
CREATE OR ALTER TRIGGER trg_Employees_Audit
ON Employees
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO AuditLogs (TableName, ActionType, RecordID, OldValues, NewValues)
        SELECT 
            'Employees',
            'UPDATE',
            i.EmployeeID,
            (SELECT d.FirstName, d.LastName, d.DepartmentID, d.IsActive FOR JSON PATH, WITHOUT_ARRAY_WRAPPER),
            (SELECT i.FirstName, i.LastName, i.DepartmentID, i.IsActive FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i
        JOIN deleted d ON i.EmployeeID = d.EmployeeID;
    END
END;
GO

-- 2. Scalar Function to calculate years of service
CREATE OR ALTER FUNCTION dbo.fn_CalculateYearsOfService (@HireDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @HireDate, GETDATE()) - 
           CASE 
               WHEN (MONTH(@HireDate) > MONTH(GETDATE())) OR 
                    (MONTH(@HireDate) = MONTH(GETDATE()) AND DAY(@HireDate) > DAY(GETDATE())) 
               THEN 1 
               ELSE 0 
           END;
END;
GO

-- 3. Stored Procedure for atomic transfer and promotion
CREATE OR ALTER PROCEDURE dbo.usp_TransferAndPromoteEmployee
    @EmployeeID INT,
    @NewDepartmentID INT,
    @NewJobTitle NVARCHAR(50),
    @NewSalary DECIMAL(12,2)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate Employee existence
        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID AND IsActive = 1)
        BEGIN
            THROW 50001, 'Active employee not found.', 1;
        END

        -- Validate Department existence
        IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @NewDepartmentID)
        BEGIN
            THROW 50002, 'Target department does not exist.', 1;
        END

        -- Update Department
        UPDATE Employees
        SET DepartmentID = @NewDepartmentID
        WHERE EmployeeID = @EmployeeID;

        -- Update Position (History is automatically recorded by Temporal Table)
        UPDATE EmployeePositions
        SET JobTitle = @NewJobTitle,
            BaseSalary = @NewSalary
        WHERE EmployeeID = @EmployeeID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
