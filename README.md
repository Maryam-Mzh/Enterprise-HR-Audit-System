# Enterprise HR Management & Audit System

An enterprise-grade Human Resources and Audit tracking system built with Microsoft SQL Server, leveraging advanced T-SQL features, system-versioned temporal tables, automated JSON auditing, and transactional safety.

---

## 🚀 Project Overview
This project is designed to manage organizational hierarchies, employee lifecycles, and structural positions while maintaining a strict, tamper-evident historical audit trail. It showcases production-ready database design patterns, robust error handling, and automated logging for compliance and governance.

---

## 🛠️ Tech Stack & Features
- **Database Engine:** Microsoft SQL Server
- **Temporal Tables:** System-Versioned Temporal Tables (`Employees`) for automated historical tracking and point-in-time analysis.
- **Auditing Mechanism:** Automated AFTER triggers capturing DML operations into a structured JSON log format (`EmployeeAudits`).
- **Programmability:** 
  - Scalar-valued functions for automated tenure and years-of-service calculations.
  - Stored procedures with explicit transaction management (`TRY...CATCH`) for safe employee department transfers and promotions.
- **Constraints & Integrity:** Advanced `CHECK`, `UNIQUE`, and `FOREIGN KEY` constraints enforcing business rules at the database level.

---

## 📂 Project Structure
```text
Enterprise-HR-Audit-System/
│
├── 01_Schema_Setup.sql        # Database creation, tables, temporal setup, and constraints
├── 02_Seed_Data.sql           # Initial dummy data using MERGE statements and safe inserts
├── 03_Audit_and_Logic.sql     # Audit triggers (JSON), functions, and transactional procedures
├── 04_Verification_Tests.sql  # Test scripts and verification queries
├── erd.png                    # Database Entity-Relationship Diagram
├── audit-result.png           # Sample JSON Audit Log output
└── stored-procedure.png       # Execution output of the transfer procedure
```
---

## 📊 Visual Documentation & Screenshots
### Database Diagram
![Database Schema](erd.png)
### Audit Output
![Sample Audit Log](audit-result.png)
### Stored Procedure & Audit Logic
![Stored Procedure Execution](stored-procedure.png)

---

## ⚙️ How to Run
Open SQL Server Management Studio (SSMS).
Execute scripts in numerical order (01 through 04) to set up the schema, seed initial data, deploy business logic, and run verification tests.
Ensure the database owner is properly configured if generating visual database diagrams in SSMS (sp_changedbowner 'sa').

---

## 👤 Author
- **Maryam Mohammadzadeh**
- GitHub: [@Maryam-Mzh](https://github.com/Maryam-Mzh)
- LinkedIn: [Maryam Mohammadzadeh](https://www.linkedin.com/in/maryam-mz)