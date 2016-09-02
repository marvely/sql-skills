select name
from Highschooler 
where ID in (
						select ID1
						from Friend
						where ID2 in ( select ID from Highschooler where name = "Gabriel")
						) 
;
/* there are two Gabriels in the dataset!!!!!!!! */

select L1.ID1, L1.ID2, H1.ID, H1.name, H1.grade, H2.ID, H2.name, H2.grade
from Likes L1, Highschooler H1, Highschooler H2
where L1.ID1 = H1.ID and L1.ID2 = H2.ID
			and H1.grade >= H2.grade +2;

select H1.name, H1.grade, H2.name, H2.grade 
from Highschooler H1, Highschooler H2, (
																		select L1.ID1 as L_1, L1.ID2 as L_2,  L2.ID1, L2.ID2
																		from Likes L1, Likes L2
																		where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1
																		and L1.ID1 < L1.ID2
																		)
where L_1 = H1.ID and L_2 = H2.ID
;

select name, grade 
from Highschooler
where ID in (
						select ID
						from Highschooler
						where ID not in ( select ID1 from Likes)
						intersect
						select ID
						from Highschooler
						where ID not in ( select ID2 from Likes)
						)
order by grade, name;

/* another way to write it! and shorter!!!! */

select name, grade
from Highschooler
where ID not in ( select ID1 from Likes
								union
								select ID2 from Likes)
order by grade, name;

select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes
where ID2 not in ( select ID1 from Likes)
			and H1.ID = ID1 and H2.ID = ID2
order by H1.name;

select  ID1, H1.grade, H2.grade
from Highschooler H1, Highschooler H2, Friend
where H1.ID = ID1 and H2.ID = ID2 and H1.grade  = H2.grade and ID1<ID2
group by ID1
order by H1.grade;

/* but if I write it another way it will turn out to be another result */
/* well the question is asking who only have friends with same grades, so it is correct to eliminate
those who has friends not in the same grade then do the NOT IN selection!!!!!!! */

select distinct L.name1, L.grade1
from
			( select ID1, ID2, H1.name as name1, H2.name as name2, 
					H1.grade as grade1, H2.grade as grade2
			  from Friend, Highschooler H1, Highschooler H2
			  where ID1 = H1.ID and ID2 = H2.ID ) as L
where L.ID1 not in (   select ID1 
									from Friend, Highschooler H1, Highschooler H2
									where ID1 = H1.ID and ID2 = H2.ID and H1.grade <> H2.grade )
order by L.grade1, L.name1 ;

/* A likes B but A and B are not Friends, find out if they have a common friend C who 
can introduce them*/

select distinct H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from    Highschooler H1, Highschooler H2, Highschooler H3, 
			Likes,
			Friend F1, Friend F2
where H1.ID = Likes.ID1 and Likes.ID2 = H2.ID and
			H2.ID not in (select ID2 from Friend where ID1 = H1.ID) 
			and
			H1.ID = F1.ID1 and F1.ID2 = H3.ID and
			H3.ID = F2.ID1 and F2.ID2 = H2.ID ;
			
/* the difference between numbers of students in school and the unique first names of students*/
select count(*) - count( distinct name)
from Highschooler;
			
			
			
select ID2 , name, grade
from Highschooler, 
								( select count(*), ID2 from Likes
								  group by ID2
							      having count(*) >=2 ) 
where ID = ID2;

/*For every situation where student A likes student B, but student B 
likes a different student C, return the names and grades of A, B, and C. */

select H1.name as Name1, H1.grade as Grade1, 
			 H2.name as Name2, H2.grade as Grade2,
			 H3.name as Name3, H3.grade as Grade3
from Highschooler H1, Highschooler H2, Highschooler H3,
			Likes L1, Likes L2
where L1.ID2 = L2.ID1 and L1.ID1 not in ( select ID2 from LIkes
																	  where L1.ID2 = ID1)
			and H1.ID = L1.ID1
			and H2.ID = L1.ID2
			and H3.ID = L2.ID2;
			

select L1.ID1, L1.ID2, L2.ID1, L2.ID2
from Likes L1, Likes L2
where L1.ID2 = L2.ID1 and L1.ID1 not in ( select ID2 from LIkes
																	  where L1.ID2 = ID1);
								
								
/*Find those students for whom all of their friends are in different 
grades from themselves. Return the students' names and grades. */

select distinct  H1.name, H1.grade
from Friend F, Highschooler H1, Highschooler H2
where H1.ID = F.ID1 and H2.ID = F.ID2
			and F.ID1 not in (
											select distinct F.ID1
											from Friend F, Highschooler H1, Highschooler H2
											where H1.ID = F.ID1 and H2.ID = F.ID2
											and H1.grade = H2.grade) ;

/* What is the average number of friends per student? (Your result should be just one number.) */
select Avg(Number_of_friends) as Avg_friend_per_student
from ( select count(*) as Number_of_friends, ID1
			from Friend
			group by ID1) ;				

/* Find the number of students who are either friends with Cassandra or are friends of friends of 
Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. */			

select count(*) from (
select ID2 from Friend where ID1 = (
															select ID from Highschooler where name = "Cassandra")
union
select ID2 from friend where ID1 in (select ID2 from Friend where ID1 = (
															select ID from Highschooler where name = "Cassandra")
															)
												 and ID2 <> (
															select ID from Highschooler where name = "Cassandra")
														)	;


			
/* Find the name and grade of the student(s) with the greatest number of friends. */

select name, grade
from Highschooler, 
(select ID1,  count(*)
from Friend
group by ID1
having count(*) = (
								select Max(Number_of_friends) as Max_num_friends
								from ( select count(*) as Number_of_friends, ID1
											from Friend
											group by ID1) 
								)
)
where ID = ID1;

/* end*/