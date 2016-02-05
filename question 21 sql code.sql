select SAL from 
	(
		select distinct SAL from emp 
		Order by SAL desc limit 10
		) as employments 
		order by SAL limit 1;

create table users
	( user_id	numeric,
	   username varchar2(30) ) ;
create table training_details
	( user_training_id numeric,
	   user_id numeric,
	   training_id numeric,
	   training_date date ) ;

insert into users values
	(1, "John Doe"),
	(2, "Jane Don"),
	(3, "Alice Jones"),
	(4, "Lisa Romero") ;
	
Insert into training_details values
	(1, 1, 1, "2015-08-02"),
	(2, 2, 1, "2015-08-03"),
	(3, 3, 2, "2015-08-02"),
	(4, 4, 2, "2015-08-04"),
	(5, 2, 2, "2015-08-03"),
	(6, 1, 1, "2015-08-02"),
	(7, 3, 2, "2015-08-04"),
	(8, 4, 3, "2015-08-03"),
	(9, 1, 4, "2015-08-03"),
	(10, 3, 1, "2015-08-02"),
	(11, 4, 2, "2015-08-04"),
	(12, 3, 2, "2015-08-02"),
	(13, 1, 1, "2015-08-02"),
	(14, 4, 3, "2015-08-03") ;

/* this is a comment */

select 
	u.user_id,
	username,
	training_id,
	training_date,
	count ( user_training_id) as count
from
	users u join training_details t on t.user_id = u.user_id
group by 
	u.user_id,
	training_id,
	training_date
having count ( user_training_id ) >1
order by training_date desc;

/* sql interview practice excercises */

create table Salesperson
	( ID integer,
	   Name Varchar2(30),
	   Age numeric,
	   Salary numeric) ;
	 
create table Customer_2
	( ID integer,
	   Name Varchar2(30),
	   City Varchar2(30),
	   Industry_type Varchar) ;
	   
create table Orders
	( Number numeric,
	   order_date date,
	   cust_id integer,
	   salesperson_id integer,
	   Amount numeric);
	   
insert into Salesperson values
	(1, "Abe", 61, 140000),
	(2, "Bob", 34, 44000),
	(5, "Chris", 34, 40000),
	(7, "Dan", 41, 52000),
	(8, "Ken", 57, 115000),
	(11, "Joe", 38, 38000) ;
	
insert into Customer_2 values
	(4, "Samsonic", "pleasant", "J"),
	(6, "Panasung", "oaktown", "J"),
	(7, "Samony", "jackson", "B"),
	(9, "Orange", "Jackson", "B") ;
	
insert into Orders values
	(10, "8/2/96", 4, 2, 540),
	(20, "1/30/99", 4, 8, 1800),
	(30, "7/14/95", 9, 1, 460),
	(40, "1/29/98", 7, 2, 2400),
	(50, "2/3/98", 6, 7, 600),
	(60, "3/2/98", 6, 7, 720),
	(70, "5/6/98", 9, 7, 150) ;
	
/* the names of all salespeople that have an order with Samsonic. */

select s.ID, s.Name 
from Salesperson s , ( select salesperson_id
									from Orders, Customer_2 c
									where cust_id = c.ID and c.Name = "Samsonic" )
where s.ID = salesperson_id ;

/* the name of all salespeople that do not have any order with Samsonic. */

select s.ID, s.Name
from Salesperson s
except
select s.ID, s.Name 
from Salesperson s , ( select salesperson_id
									from Orders, Customer_2 c
									where cust_id = c.ID and c.Name = "Samsonic" )
where s.ID = salesperson_id ;

/*the names of salespeople that have 2 or more orders */

select Name
from Salesperson, 
	  (
		select count(salesperson_id) as count, salesperson_id
		from Orders
		group by salesperson_id
		having count(salesperson_id) >1)
where ID = salesperson_id;

/* write a SQL statement to insert rows into a table called highAchiever (Name, age), where a 
salesperson must have a salary of 100,00 or greater to be included in the table. */

create table highAchiever
	( Name Varchar(30),
	Age numeric);

insert into highAchiever (Name, Age)
	(select  s.Name, s.Age from salesperson s where s.Salary > 100000) ;
/* I cannot make this one work.... why???? */

	
			
	

