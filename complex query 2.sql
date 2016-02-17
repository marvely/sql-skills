select Table1.Emp_name, case
													when Table1.MNG_name is NULL
													then "No Manager"
													Else Table1.MNG_name
													End as Manager_name
From ( select E1.Name as Emp_name, E2.Name as MNG_name
			 from Emp  E1 left outer join Emp  E2
			 on E1.MGR_ID = E2.ID ) as Table1 ;
			 
			 
select E1.Name as Emp_name, E2.Name as MNG_name
			 from Emp  E1 left outer join Emp  E2
			 on E1.MGR_ID = E2.ID ;
			 
Select * from Employee;

select * 
from ( select *, Row_Number() Over (Partition by DEPT_ID order by SAL DESC) as Row_Number 
			from Emp ) as Emp1
where Row_Number < 3 ;

/* to find out the second highest salary in each department */
select Max(SAL) as Second_top_Sal, E1.DEPT_ID as Department_ID
from Emp E1, ( select Max(SAL) as Top_Sal, DEPT_ID
						  from Emp
						  group by DEPT_ID ) as E2
where E1.SAL < =E2.Top_Sal and E1.DEPT_ID = E2.DEPT_ID
group by E1.DEPT_ID ;

/* one problem is that it cannot handle ties. for department 1, two employees have 
the same salary and the result did not show either of them*/
