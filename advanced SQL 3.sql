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
	StoreID integer) ;
	
Insert into Starbucks_Employees values
	( 1, "Abe", 61, 14, 10),
	(2, "Bob", 34, 10, 30),
	(5, "Chris", 34, 9, 40),
	(7, "Dan", 41, 11, 50),
	(8, "Ken", 57, 11, 60),
	(11, "Joe", 38, 13, 70) ;
	
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
select count(*) as num_employees, max(HourlyRate), city
from Starbucks_Employees se join Starbucks_Stores ss
on se.StoreID = ss.store_id
group by city;

/* the problem is the HourlyRate returned is not a reflection of the avg 
of all the employees in the city
*/

/* part 2 of the advanced SQL practice */

/* find the largest order amount for each salesperson and the associated 
order number, along with the customer to whom that order belongs to. 
You can present your answer in any database’s SQL – MySQL, Microsoft 
SQL Server, Oracle, etc.
*/

select max(Amount) as Max_Order_Amount, salesperson_id, Number as Order_number, c.Name as Customer_name
from Orders o left outer join Customer_2 c on o.cust_id = c.ID
group by salesperson_id;
/* however, this order_number is randomly selected by SQL...*/
/* we need to make our query more specific!!!!! */

select salesperson_id, Max(Amount) as MaxOrder
from Orders
group by salesperson_id;

/* if we join the subquery result with the order table we will have the specific order number 
for the max(Amount) values
*/
select salesperson_id, Number as Order_Number, Amount
from Orders join 
	(select salesperson_id, Max(Amount) as MaxOrder
	 from Orders
	 group by salesperson_id) as TopOrderAmountsPerSalesperson
using (salesperson_id)
where Amount = MaxOrder;
/* the next step, add customer's name is easy. */

select salesperson_id, Number as Order_number, Amount, s.Name as Salesperson_name, c.Name as Cust_name
from Orders o join salesperson s on s.ID = o.salesperson_id
join Customer_2 c on c.ID = o.cust_id
join (select salesperson_id, Max(Amount) as MaxOrder
	 from Orders
	 group by salesperson_id) as TopOrderAmountsPerSalesperson
using (salesperson_id)
where Amount = MaxOrder;

/* corner case: if a salesperson has 2 or more orders that have the same value 
for the highest amount????
*/
insert into Orders values
	(80, "02/19/94", 7, 2, 2400) ;
	
/* and we run the query above one more time, have the result table with 2 rows of Bob's data.
But the question is, if we only want 1 Bob, how to elliminate the duplicate?? */

/* solution:
				we can add group by amount, salesperson_id at the end of the query,
				since the combination result is unique!!!!! */
				
select salesperson_id, Number as Order_number, Amount, s.Name as Salesperson_name, c.Name as Cust_name
from Orders o join salesperson s on s.ID = o.salesperson_id
join Customer_2 c on c.ID = o.cust_id
join (select salesperson_id, Max(Amount) as MaxOrder
	 from Orders
	 group by salesperson_id) as TopOrderAmountsPerSalesperson
using (salesperson_id)
where Amount = MaxOrder
group by Amount, salesperson_id;

/* however, the order number for Bob will be random now!!!! is it ok??? */



	
/* end */