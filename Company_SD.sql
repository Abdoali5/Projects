/*Q1- Get the Employees Names , B_Date , Address , Department Name  and the Manger ID  , 
 only the employees who their salaries  is higher than ( the overall salaries AVG )
 – we need the answer to be sorted for a better view*/

 Select E.Fname+' '+E.Lname as full_name, E.Bdate, E.Address, E.Salary, D.Dname, D.MGRSSN
 FROM Employee as E inner join Departments as D on E.SSN = D.MGRSSN
 WHERE E.Salary > (SELECT AVG(E.Salary) FROM Employee E);

 /*Q2-Get the count of the dependents for each employee  */

 select E.Fname+' '+E.Lname as full_name, E.SSN, COUNT(D.Dependent_name) as dependent_count
 from Employee as E FULL OUTER join Dependent as D on E.SSN=D.ESSN
 group by E.Fname+' '+E.Lname , E.SSN

 /*Q3- Get the count of the employee for each supervisor with full details for the supervisors*/ 
  
  select E.SSN as supervisor_ssn,E.Fname+' '+E.Lname as full_name ,E.Bdate, E.Address, E.Sex ,E.Salary,E.Dno , COUNT(T.Superssn) as count_of_employe
  from Employee as E inner join Employee as T on E.SSN=T.Superssn
  group by E.SSN ,E.Fname+' '+E.Lname  ,E.Bdate, E.Address, E.Sex ,E.Salary,E.Dno
  

   /*Q4- Get the Total worked Hours for Each project and how many Employees worked for each project ,
   with full project details (name , location ,city )*/

   select P.Pname, P.Plocation , P.City, COUNT(W.ESSn) as employee_count, Sum(W.Hours) as total_hours
   from Project as P inner join Works_for as W on P.Pnumber = W.Pno
   group by P.Pname, P.Plocation , P.City

   /*Q5 - Get the top 1 Project based on the working hours  with full , 
   with full project details like the location , city and project name*/

   select top 1 P.Pname, P.Plocation , P.City, Sum(W.Hours) as total_hours
   from Project as P inner join Works_for as W on P.Pnumber = W.Pno
   group by P.Pname, P.Plocation , P.City
   order by total_hours DESC


  /*Q6- How Many Employees in each Department and How much the amount of salaries for each department*/

   Select D.Dname, E.Dno ,COUNT(E.SSN) as Employees , SUM(E.Salary) as total  
   from  Departments as D inner join Employee as E on D.Dnum = E.Dno 
   group by D.Dname, Dno


   /*Q7- Get the department with full Details which it’s total salaries higher than the Average salary based on the departments*/
   
   
   Select D.Dname, D.MGRSSN, D.[MGRStart Date],E.Dno ,COUNT(E.SSN) as Employees , SUM(E.Salary) as total  
   from  Departments as D inner join Employee as E on D.Dnum = E.Dno 
   where (SELECT Sum(E.Salary) FROM Employee E)> (SELECT AVG(E.Salary) FROM Employee E)  
   group by D.Dname, Dno, D.MGRSSN, D.[MGRStart Date]
   
   
   /*Q8-Get the full details for the departments Mangers and what is the oldest Department in the company*/
   
   Select D.Dname, D.MGRSSN, D.[MGRStart Date], E.Fname+' '+E.Lname as full_name ,E.Bdate, E.Address, E.Sex ,E.Salary,E.Dno
   from  Departments as D inner join Employee as E on D.MGRSSN = E.SSN
   group by D.Dname, D.MGRSSN, D.[MGRStart Date], E.Fname+' '+E.Lname ,E.Bdate, E.Address, E.Sex ,E.Salary,E.Dno
   order by d.[MGRStart Date] ASC
   
   /*Q9-How many Males and females in the company for only the Employees*/

   SELECT Sex,COUNT(Sex) as count_of_sex 
   from Employee
   group by Sex
   
  
  /*10 – Get the Employees details who is working as Supers or Mangers in one insight*/ 
  
	  select MGRSSN from Departments
	  union
	  select superssn from Employee as E
	  where E.superssn is not null
  
  /*Q11- Get the full Employee details with the new salary after the annual increase by 25 %*/
  
  select Fname+' '+Lname as full_name ,SSN ,Salary , salary*0.25 as P_of_increase , Salary +salary*0.25 as New_salary
  from Employee 

  /*Q12- Insert a new Employee to Dp 40 with ID  101029, his name is Adel Ibrahim and ,Bdate 10-1-1990 , 
  his Address is 75 Fifth settlement , Cairo , his salary is 2k and his supervisor’s ID is (321654)*/
	
	INSERT INTO Employee (Fname, Lname, SSN, Bdate, Address, Sex, Salary, Superssn, Dno)
	VALUES ('Adel', 'Ibrahim', 101029, '1990-01-10', '75 Fifth Settlement, Cairo', 'M', 2000, 321654, 40);
  
  /*Q13- Update the new Dnum 40 with the next data : 
    Dname is DP4 , MGRSSN IS  101029 and insert the date that will be considered as the start of the Department (6-30-2024)*/
	
	INSERT INTO Departments(Dname,Dnum,MGRSSN,[MGRStart Date])
    VALUES('DP4', 40,101029,'6-30-2024')
 
 
 /*Q14- Create a view  (Top 3 Employees) based on the working hours ) with the next details , we need to the count for the projects for each employee ,
  total worked hours , Department Name , MGRSSN , Full name and how many dependents */
  use Company_SD
  create view Top3 as
  select top 3 E.Fname+' '+E.Lname AS FULL_NAME ,E.SSN ,E.Dno , COUNT(distinct W.Pno) as count_project ,SUM(W.Hours) as total_worked_hours , D.MGRSSN ,
  (select COUNT(*) from Dependent where E.SSN=Dependent.ESSN) as All_dependents
  from Employee as E join Works_for as W on E.SSN=W.ESSn join Departments as D on E.Dno = D.Dnum 
  group by E.Fname+' '+E.Lname ,E.SSN ,E.Dno , D.MGRSSN 
  order by total_worked_hours DESC


  /*Q15- Get the Employees Full Names who their Supervisor’s name is Kamel Mohamed */
  select * from Employee 
  where Superssn =223344

  /*Q16 – Create a view (Completed Projects ) with Project no, name and Location  which their total worked hours is higher than 40 hour*/
  
  select P.Pname ,P.Pnumber ,P.Plocation , sum(w.Hours) as total_worked_houres
  from Project as P join Works_for as W on p.Pnumber=w.Pno
  group by P.Pname ,P.Pnumber ,P.Plocation
  having sum(w.Hours) > 40

