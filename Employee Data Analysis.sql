# Analysis of the Employee Database
# Display the first first five rows from the employees table
SELECT 
    *
FROM
    employees
LIMIT 5;

# Display records for all male employees with name of Elvis
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis' AND gender = 'M';
    
# Display records for employees with name of Denis or Elvis
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis' OR first_name = 'Elvis';
    
# Display list of male or female employees with last name of Denis 
SELECT 
    *
FROM
    employees
WHERE
    last_name = 'Denis'
        AND (gender = 'F' OR gender = 'M'); #bracket due to logical operation precedence. AND before OR
    
# Display list of employees with first name of Cathie, Mark and Nathan 
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Cathie' , 'Mark', 'Nathan');   
    
# Display list of employees whose first name of starts with 'Mar' using wildcard 
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('Mar%');
    
# Display list of employess with hire date of '2000'
SELECT
    *
FROM
    employees
WHERE
    hire_date LIKE ('%2000%');    
    
# Display list of employess hired between 1999 and 2000
SELECT
    *
FROM
    employees
WHERE
    hire_date BETWEEN ('1999-01-01') AND ('2000-01-01');     
    
# Display all information from the “salaries” table regarding salary from 66,000 to 70,000 dollars per year 
SELECT
    *
FROM
    salaries
WHERE
    salary BETWEEN 66000 AND 70000;  
    
# Display all employees hired on or before February 1985
SELECT
    *
FROM
    employees
WHERE
    hire_date < '1985-02-01';     
    
# Retieve all female employees hired in the year 2000 or after
SELECT
    *
FROM
    employees
WHERE
    gender = 'F' AND hire_date >= '2000-01-01';    


# Display the number of employees    
SELECT 
    COUNT(DISTINCT emp_no) AS 'num_employee'
FROM
    employees;   
    

# Count number of employees with a salary value higher than or equal to $100,000
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000;  

# Retrieve the distribution of employee by gender    
select gender, count(gender) from employees group by gender;   

# Retrieve information for employees  wwith salary over $80,000 and number of employees on this salary scale
SELECT 
    salary, COUNT(emp_no) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;

  
# Retrive information for all employees whose average salary is higher than $120,000 per annum.    
SELECT 
    *, AVG(salary)
FROM
    salaries
WHERE
    salary > 120000
GROUP BY emp_no
ORDER BY emp_no;


##
SELECT 
    emp_no, ROUND(AVG(salary), 2)
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

# Retrieve list of employees with first name of less than 200 and employeed after 1999
SELECT
    first_name, count(first_name) AS names_count
    FROM employees
    WHERE hire_date > '1999-01-01'
    GROUP BY first_name
    HAVING count(first_name) < 200
    ORDER BY first_name DESC
    ;
    
# Retrieve the employee numbers of all individuals who have signed more than 1 contract after the 1st of January 2000.
 SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

# Retrieve information on the top 10 highest paid employee in the database
SELECT 
    *
FROM
    salaries
ORDER BY salary DESC
LIMIT 10;


# 
SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';


/* Extract a list containing information about all managers’ employee number, first and last name, department number, and hire date.*/
SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no;

/*Retieve all employees whose last name is Markovitch and see if the output contains a manager with that name.  */
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    dm.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY dm.dept_no DESC , e.emp_no;
   
/*Select the first and last name, the hire date, and the job title of all employees whose first name is “Margareta” and have the last name “Markovitch”.

*/
SELECT 
    e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    first_name = 'Margareta'
        AND last_name = 'Markovitch'
ORDER BY e.emp_no;   


/*Return first and last name of manager, the hire date and the date they were promoted to manager*/
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no;


/*Select all managers’ first and last name, hire date, job title, start date, and department name.*/
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;

/*How many male and how many female managers do we have in the ‘employees’ database?*/
SELECT 
    e.gender, COUNT(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;

/*Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.*/
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            
/*Select the entire information for all employees whose job title is “Assistant Engineer”*/           
SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND title = 'Assistant Engineer');
                
/*Assign employee number 110022 as a manager to all employees from 10001 to 100020 and employee 
number 110039 as a manager to all employees from 10020 to 10040*/                
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION 
SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;
    
    
/*Create a procedure that will provide the average salary of all employees. Then, call the procedure.*/
DELIMITER $$

CREATE PROCEDURE avg_salary()

BEGIN

                SELECT

                                AVG(salary)

                FROM

                                salaries;

END$$

DELIMITER ;

CALL avg_salary;

/*Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, 
and returns their employee number.*/

DELIMITER $$

CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)

BEGIN

                SELECT

                                e.emp_no

                INTO p_emp_no FROM

                                employees e

                WHERE

                                e.first_name = p_first_name

                                                AND e.last_name = p_last_name;

END$$

DELIMITER ;

/*Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.*/

/*Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.*/

/*select the obtained output.*/

SET @v_emp_no = 0;

CALL emp_info('Aruna', 'Journel', @v_emp_no);



/*Retrive the employee number, first name, and last name of all employees with a number higher than 109990. 
Create a fourth column in the query, indicating whether this employee is also a manager, according to the data 
provided in the dept_manager table, or a regular employee*/
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;
    
/*Extract a dataset containing the following information about the managers: employee number, first name, and 
last name. Add two columns at the end – one showing the difference between the maximum and minimum salary of 
that employee, and another one saying whether this salary raise was higher than $30,000 or NOT*/    

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more then $30,000'
        ELSE 'Salary was NOT raised by more then $30,000'
    END AS salary_raise
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;


/*Extract the employee number, first name, and last name of the first 100 employees, and add a fourth column, 
called “current_employee” saying “Is still employed” if the employee is still working in the company, 
or “Not an employee anymore” if they aren’t.*/   

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;