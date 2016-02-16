create table Employees
	( Name Varchar(30),
		Gender Varchar);
		
insert into Employees values
	( "A", "M"),
	( "BB", "F"),
	("B", "F"),
	("CC", "F"),
	("CD", "M"),
	("DD", "M"),
	("DE", "F") ;
	
select * from Employees;

Select * from 
 (select  E1.Numbers as M from 
			( select count(*) as Numbers, Gender from Employees
			  group by Gender
			  having Gender = "M") as E1) ,
 (select  E2.Numbers as F from 
			( select count(*) as Numbers, Gender from Employees
			  group by Gender
			  having Gender = "F") as E2) ;



select count(*) as Numbers, Gender from Employees
group by Gender;