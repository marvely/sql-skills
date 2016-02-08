
create table User_2
	( user_id integer.
	name varchar2(30),
	phone_num integer) ;
	
create table UserHistory
	( user_id integer,
	date date,
	action varchar(30));
	
/* Write a SQL query that returns the name, phone number and most recent date for 
any user that has logged in over the last 30 days (you can tell a user has logged in if 
the action field in UserHistory is set to "logged_on").
*/

select name, phone_num, max(date)
from User_2 u join UserHistory h on u.user_id = h.user_id
where h.date >= date_sub(current_date(), interval 30 days) and action = "logged_on"
group by u.user_id;
/* Because this is an aggregate function, we will have to provide the GROUP BY clause in
 order to specify what column we would like to use as a ‘container’ of the group of dates. 
 */
 

/* Write a SQL query to determine which user_ids in the User table are not contained in
 the UserHistory table (assume the UserHistory table has a subset of the user_ids in User 
 table). Do not use the SQL MINUS statement. Note: the UserHistory table can have multiple 
 entries for each user_id.
*/

select distinct u.user_id
from User_2 u left outer join UserHostory h on u.user_id = h.user_id
where h.user_id is null;

/*This means that any NULL entries are user_id values that exist in the User table
 but not in the UserHistory table.
 */
 




















/* end */
