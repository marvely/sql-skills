/******************************************************************************************************************/
/* Adcanced SQL interview questions */

select * from salesperson;
select * from Orders;

/* We want to retrieve the names of all salespeople that have more than 1 order from the 
tables above. You can assume that each salesperson only has one ID.
*/

select s.Name
from Salesperson s join Orders o on s.ID = o.salesperson_id
group by salesperson_id, s.Name
having count( salesperson_id) > 1 ;

/* although in the answers the Name column must be in the group by clause, but
I ran the code without it and still got the right answer...  why??????
*/

/* starbucks example */
create table Starbucks_Employees
	( ID integer primary key,
	Name varchar(30),
	Age integer,
	HourlyRate  float,
	StoreID integer)
	
Insert into Starbucks_Employees values
	( 1, "Abe", 61, 14, 10),
	(2, "Bob", 34, 10, 30),
	(5, "Chris", 34, 9, 40),
	(7, "Dan", 41, 11, 50),
	(8, "Ken", 57, 11, 60),
	(11, "Joe", 38, 13, 70)
	
select * from Starbucks_Employees;

create table Starbucks_Stores
	( store_id integer primary key,
	city varchar(30));
	
insert into Starbucks_Stores values
	(10, "San Francisco"),
	(20, "Los Angeles"),
	(30, "San Francisco"),
	(40, "Los Angeles"),
	(50, "San Francisco"),
	(60, "New York"),
	(70, "San Francisco") ;
	
select * from Starbucks_Stores;

/* try the query*/
select count(*) as num_employees, HourlyRate, city
from Starbucks_Employees se join Starbucks_Stores ss
on se.StoreID = ss.store_id
group by city, HourlyRate;

/* the problem is the HourlyRate returned is not a reflection of the avg 
of all the employees in the city
*/


/* end */