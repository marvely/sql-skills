/* stanford sql course */

select title
from Movie
where director = "Steven Spielberg";

select distinct year
from Movie
where mID In ( select mID
						  from Rating
						  where stars =4 or stars = 5)
Order by year;

select *
from Movie left outer join Rating using (mID) ;

select title 
from Movie left outer join Rating using (mID)
where stars is NULL;

select name
from Reviewer
where rID in ( select distinct rID
						from Rating
						where ratingDate is NULL ) ;
select name
from Reviewer natural join Rating
where ratingDate is NULL;

/*Write a query to return the ratings data in a more readable format: 
reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
first by reviewer name, then by movie title, and lastly by number of stars. */

select name, title, stars, ratingDate
from (Reviewer inner join Rating using (rID)) inner join Movie using (mID)
order by name, title, stars;

/* For all cases where the same reviewer rated the same movie twice and gave 
it a higher rating the second time, return the reviewer's name and the title of the movie.*/

select name, title
from Reviewer join (
									select R1.rID, R1.mID
									from Rating R1 join Rating R2 using (rID)
									where R1.mID = R2.mID
									and R1.ratingDate < R2.ratingDate
									and  R1.stars < R2.stars) using (rID)
						join Movie using (mID);
						
/* For each movie that has at least one rating, find the highest number of stars that 
movie received. Return the movie title and number of stars. Sort by movie title. */

select title, Max_star
from Movie join (
								select max(stars) as Max_star, mID
								from Rating 
								group by mID) as Max_rate
					using (mID)
order by title ;

/* For each movie, return the title and the 'rating spread', that is, the difference between 
highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, 
then by movie title. */

select title, Rate_spread
from Movie join (
		select mID, Max_star - Min_star as Rate_spread
		from ( select max(stars) as Max_star, mID
								from Rating 
								group by mID) as Max_Rate
				join 
				(select min(stars) as Min_star, mID
								from Rating 
								group by mID) as Min_Rate
				using (mID) )
		using (mID)
		order by Rate_spread desc, mID;

/* Find the difference between the average rating of movies released before 
1980 and the average rating of movies released after 1980. (Make sure to calculate t
he average rating for each movie, then the average of those averages for movies 
before 1980 and movies after. Don't just calculate the overall average rating before 
and after 1980.)  */

select Max(Ave_rate) - Min(Ave_rate) 
from (
			select avg(Ave_stars) as Ave_rate, Period
			from (
						select title, Ave_stars, case 
												when year < 1980 then "Before 1980"
												else "After 1980"
												end as Period
						from Movie join (
													select avg(stars) as Ave_stars, mID
													from Rating
											group by mID)
						using (mID)
						)
			group by Period
) ;

/*Find the names of all reviewers who rated Gone with the Wind. */

select name 
from Reviewer 
where rID in (
						select distinct rID
						from Rating where mID = ( select mID
																	from Movie
																	where title = "Gone with the Wind")
						)
;


/**************************************************************************************************/
select * from (Movie join Rating using (mID) ) join Reviewer using (rID)
where director = name ;

/**************************************************************************************************/

select name from Reviewer
union
select title from Movie
order by name;

/**************************************************************************************************/
select title
from Movie
where mID not in (
							select mID
							from Rating
							where rID in ( select rID from Reviewer where name = 'Chris Jackson' )
						) ;
						
/* this one is tricky, if I switch the in and not in I will have a different result.
so what should I do each time? put the not in in the out most query????*/

/**************************************************************************************************/
select distinct name1, name2 
from (
			select  R1.rID, R2.rID, R3.name as name1, R4.name as name2, R1.mID
			from  Rating R1, Rating R2, Reviewer R3, Reviewer R4
			where R1.mID = R2.mID and R1.rID < R2.rID
						and R1.rID = R3.rID and R2.rID = R4.rID
		  ) ;
		  
/* For each rating that is the lowest (fewest stars) currently in the database, return the 
reviewer name, movie title, and number of stars. */

select name, title, stars 
from Reviewer R, ( select rID, mID, stars
							from Rating
							where stars = ( select min(stars) from Rating group by mID)
							) Rv, Movie M
where R.rID = Rv.rID and Rv.mID = M.mID
order by name;

/*List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order. */

select title, Avg_rate
from Movie join (
							select mID, avg(stars) as Avg_rate
							from Rating
							group by mID ) 
					using (mID)
order by Avg_rate desc, title;

/*Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */

select name 
from Reviewer join (
									select count(*), rID from Rating 
									group by rID
									having count(*) >=3)
						using (rID) ;

/*Some directors directed more than one movie. For all such directors, return the 
titles of all movies directed by them, along with the director name. Sort by director 
name, then movie title. (As an extra challenge, try writing the query both with and 
without COUNT.) */

select title, M1.director
from Movie M1, ( select count(*), director 
						from Movie 
						group by director 
						having count(*) >1) M2
where M1.director = M2.director
order by M1.director, title
;

/*Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.
 (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as 
 finding the highest average rating and then choosing the movie(s) with that average rating.) */

 select mID, Ave_rating, title
 from ( select mID, avg(stars) as Ave_rating
												from Rating
												group by mID) join Movie using (mID)
where Ave_rating >= ( select Max(Ave_rating) from (select avg(stars) as Ave_rating
												from Rating
												group by mID));
 
 /* same thing for the lowest ave rating movie*/
select mID, Ave_rating, title
 from ( select mID, avg(stars) as Ave_rating
												from Rating
												group by mID) join Movie using (mID)
where Ave_rating <= ( select Min(Ave_rating) from (select avg(stars) as Ave_rating
												from Rating
												group by mID));
 
 /*For each director, return the director's name together with the title(s) of the movie(s) 
 they directed that received the highest rating among all of their movies, and the value 
 of that rating. Ignore movies whose director is NULL. */
 
 select  title, director, Max(stars)
 from Movie M join Rating R using (mID)
 where director is not null
 group by director;
 
 /* a little uncertain here. is the result randomly selected for the title? cus there could 
 be more than 1 movie for each director that has the max rating... or not?*/

/* END */