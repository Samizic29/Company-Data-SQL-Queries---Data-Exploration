/*
Company Data Exploration
Skills used: Joins, Temporary Tables, Aggregate Functions, Creating Views
*/

-- Employee table
SELECT * FROM employee;

-- Department table
SELECT * FROM department;

-- Dependent table
SELECT * FROM dependent;

-- Dept_locations table
SELECT * FROM dept_locations;

-- Project table
SELECT * FROM project;

-- Works_on table
SELECT * FROM works_on;


-- Question Solved

-- What is the count of all employees?
SELECT COUNT(*) AS total_employees FROM employee;

-- What is the count of all departments?
SELECT COUNT(*) AS total_departments FROM department;

-- What is the count of all departments?
SELECT Fname, Minit, Lname, Dno 
FROM employee 
WHERE Dno = 4;

-- Name of projects in Sugarland
SELECT pname FROM project WHERE plocation = "Sugarland";

-- Employees name that don't work on Project ProductX
SELECT Fname, Lname, pname 
FROM employee 
INNER JOIN project
ON employee.Dno = project.dnum
WHERE project.pname != "ProductX";

/* Create Temp Table for later use */
CREATE TEMPORARY TABLE hours_table
SELECT Fname, Lname, MAX(hours) as worked_hours, Dno
FROM employee
INNER JOIN works_on
ON employee.SSN = works_on.essn
GROUP BY Fname
ORDER BY worked_hours DESC;

-- Who worked the most hours? The least hours?
SELECT Fname, Lname, worked_hours
FROM hours_table;

/* Using the temp table created for complex query */
-- Who worked the most hours in Research dept?
SELECT Fname, Lname, dname, worked_hours
FROM hours_table
INNER JOIN department
ON hours_table.Dno = department.dnumber
WHERE department.dname = 'Research'
GROUP BY Fname
ORDER by worked_hours DESC;

-- Provide the names of employees with either a son or wife dependent
SELECT Fname, Lname, dependent_name, relationship
FROM employee
INNER JOIN dependent
ON employee.SSN = dependent.essn
WHERE dependent.relationship IN ('Son', 'Spouse');

-- Provide the names of employees with salary between $5k and $30k
SELECT Fname, Lname, Salary
FROM employee
WHERE Salary BETWEEN 5000 AND 30000;

/* Using the temp table (hours_table) created for this query */
-- Provide the names of employees that worked between 20 and 30 hours
SELECT Fname, Lname, worked_hours
FROM hours_table
GROUP BY Fname
HAVING worked_hours BETWEEN 20 AND 30;

-- Provide the department name and project name for projects in Houston, Sugarland, or Stafford
SELECT dname, pname, plocation
FROM department
INNER JOIN project
ON department.dnumber = project.dnum
WHERE plocation IN ('Houston', 'Sugarland', 'Stafford');

-- Provide employees with Last Name that does not begin with W
SELECT Fname, Lname, Super_ssn, Salary FROM employee WHERE Lname NOT LIKE 'W%';

/* Creating a temp table (avg_hours) for later use */
CREATE TEMPORARY TABLE avg_hours AS
SELECT Fname, Lname, AVG(hours) AS avg_worked_hours, Dno
FROM employee
INNER JOIN works_on
ON employee.SSN = works_on.essn
GROUP BY Fname;

/* Using the temp table (avg_hours) created for this query */
-- What is the average hours worked for employees in the Research department?
SELECT Fname, Lname, dname, avg_worked_hours
FROM avg_hours
INNER JOIN department
ON avg_hours.Dno = department.dnumber
WHERE department.dname = 'Research'
GROUP BY Fname;

-- How many male and female employees are there?
SELECT sex, COUNT(sex) as total FROM employee GROUP BY sex

-- How many male and female dependents are there?
SELECT sex, COUNT(sex) as total FROM dependent GROUP BY sex

-- Identify the number of projects in each location and order by most to least projects
SELECT plocation, COUNT(pname) as total_project 
FROM project
GROUP BY plocation 
ORDER by total_project desc;

-- What is the total salary for employees by projects?
SELECT pname, SUM(Salary) AS total_salary
FROM employee
INNER JOIN project
ON employee.Dno = project.dnum
GROUP BY pname;

-- What is the total salary for employees by departments?
SELECT dname, SUM(Salary) AS total_salary
FROM employee
INNER JOIN department
ON employee.Dno = department.dnumber
GROUP BY dname;

-- Sort employee salaries by largest to smallest 
SELECT SSN, Fname, Lname, Salary
FROM employee
ORDER BY Salary DESC;


/* Creating Views to store data for later visualization */
CREATE VIEW emp_salary AS
SELECT SSN, Fname, Lname, Salary
FROM employee
ORDER BY Salary DESC;

CREATE VIEW project_salary AS
SELECT pname AS project_name, SUM(Salary) AS total_salary
FROM employee
INNER JOIN project
ON employee.Dno = project.dnum
GROUP BY project_name;

CREATE VIEW department_salary AS
SELECT dname AS department_name, SUM(Salary) AS total_salary
FROM employee
INNER JOIN department
ON employee.Dno = department.dnumber
GROUP BY department_name;
