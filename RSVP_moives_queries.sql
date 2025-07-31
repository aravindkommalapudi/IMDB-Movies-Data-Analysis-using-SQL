USE imdb;
--  Find the data values in each table are.
select * from movie;
select * from genre;
select * from director_mapping;
select * from names;
select * from ratings;
select * from role_mapping;

/* To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movie' and 'genre' tables. */

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

with cte as
(
select count(*) as cnt from director_mapping
union all
select count(*) from genre
union all
select count(*) from movie
union all
select count(*) from names
union all
select count(*) from ratings
union all
select count(*) from role_mapping
)select sum(cnt) as Tot_num_of_rows from cte;

-- Q2. Which columns in the 'movie' table have null values?
-- Type your code below:

select * from movie;
  
 select (select count(*) from movie where country is null) as country_nulls,
(select count(*) from movie where worlwide_gross_income is null) as worldwide_gross_income_nulls,
(select count(*) from movie where languages is null) as languages_nulls,
(select count(*) from movie where production_company is null) as production_company_nulls;
        
-- Solution 1
select count(*)-count(country) as country_nulls,
count(*)-count(worlwide_gross_income) as wordwide_gross_income_nulls,
count(*)-count(languages) as laguages_nulls,
count(*)-count(production_company) as production_company_nulls from movie;

/* There are 20 nulls in country; 3724 nulls in worlwide_gross_income; 194 nulls in languages; 528 nulls in production_company.
   Notice that we do not need to check for null values in the 'id' column as it is a primary key.

-- As you can see, four columns of the 'movie' table have null values. Let's look at the movies released in each year. 

-- Q3. Find the total number of movies released in each year. How does the trend look month-wise? (Output expected)


/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	   2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	  1			|	    134			|
|	  2			|	    231			|
|	  .			|		 .			|
+---------------+-------------------+ */

-- Type your code below:
select * from movie;
-- First part
select year,count(title) number_of_movies from movie 
group by year;

-- Second part
select month(date_published) as month_num,
count(title) as number_of_movies from movie
group by month(date_published)
order by month(date_published) asc;
		
/* The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the
'movies' table. 
We know that USA and India produce a huge number of movies each year. Lets find the number of movies produced by USA
or India in the last year. */
  
-- Q4. How many movies were produced in the USA or India in the year 2019?
-- Type your code below:
select * from movie;
select * from genre;

with cte as
(
select title,year,country from movie
where country in ("usa","india")
and year=2019
order by country
)select count(*) as movie_cnt from cte;

with cte as
(
select m.title,m.year,m.country,g.genre 
from movie m join genre g
on m.id = g.movie_id
where country in ("usa","india")
and year =2019
order by country
)select count(*) as movie_cnt from cte;

/* The query given above is a better solution as it takes into account rows having values with incorrect casing, for
example 'usA' or 'INDIA'. */


/* USA and India produced more than a thousand movies (you know the exact number!) in the year 2019.
Exploring the table 'genre' will be fun, too.
Let’s find out the different genres in the dataset. */

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select * from genre;
select distinct genre from genre;

/* So, RSVP Movies plans to make a movie on one of these genres.
Now, don't you want to know in which genre were the highest number of movies produced?
Combining both the 'movie' and the 'genre' table can give us interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select * from movie;
select * from genre;

with cte as
(
select m.id,m.title,g.genre from movie m join genre g
on m.id = g.movie_id
) select genre,count(title) num_of_movies_produced from cte
group by genre
order by count(title) desc;

-- Alternate better solution
select g.genre,count(m.title) as num_of_mov_produced 
from movie m join genre g
on m.id=g.movie_id
group by genre
order by num_of_mov_produced desc;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with cte as
(
select m.id,m.title,g.genre 
from movie m join genre g
on m.id = g.movie_id
),cnt as
(
select distinct title,count(genre) as cnt_of_genre from cte
group by title
having cnt_of_genre=1
)select count(*) as single_genre_movies from cnt;

/* There are more than three thousand movies which have only one genre associated with them.
This is a significant number.
Now, let's find out the ideal duration for RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	Thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select * from movie;
select * from genre;

with cte as
(
select m.id,m.title,m.duration,g.genre
from movie m left join genre g 
on m.id=g.movie_id
)
select genre,round(avg(duration),2) as avg_duration from cte
group by genre;

/* Note that using an outer join is important as we are dealing with a large number of null values. Using
   an inner join will slow down query processing. */


/* Now you know that movies of genre 'Drama' (produced highest in number in 2019) have an average duration of
106.77 mins.
Let's find where the movies of genre 'thriller' lie on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the rank function)


/* Output format:
+---------------+-------------------+---------------------+
|   genre		|	 movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|   drama		|	   2312			|			2		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
with cte as
(
select m.id,m.title,g.genre 
from movie m join genre g 
on m.id=g.movie_id
),cte1 as
(
select genre,count(title) as movie_count from cte 
group by genre
)select genre,movie_count,rank() over(order by movie_count desc) as genre_rank from cte1;

-- Thriller movies are in the top 3 among all genres in terms of the number of movies.

-- --------------------------------------------------------------------------------------------------------------
/* In the previous segment, you analysed the 'movie' and the 'genre' tables. 
   In this segment, you will analyse the 'ratings' table as well.
   To start with, let's get the minimum and maximum values of different columns in the table */

-- Segment 2:

-- Q10.  Find the minimum and maximum values for each column of the 'ratings' table except the movie_id column.

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

-- Type your code below:
select * from ratings;
select min(avg_rating) min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_ratings,
max(median_rating) as max_median_rating 
from ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating. */

-- Q11. What are the top 10 movies based on average rating?

/* Output format:
+---------------+-------------------+---------------------+
|     title		|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
|     Fan		|		9.6			|			5	  	  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
select * from movie;
select * from ratings;

with cte as
(
select m.id,m.title,r.avg_rating 
from movie m join ratings r 
on m.id = r.movie_id
)select title,avg_rating,dense_rank() over(order by avg_rating desc) as movie_rank
from cte limit 10;
    
-- It's okay to use RANK() or DENSE_RANK() as well.

/* Do you find the movie 'Fan' in the top 10 movies with an average rating of 9.6? If not, please check your code
again.
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight. */

-- Q12. Summarise the ratings table based on the movie counts by median ratings.

/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
with cte as
(
select m.id,m.title,r.median_rating
from movie m join ratings r 
on m.id = r.movie_id
) select median_rating,count(title) as movie_count
from cte 
group by median_rating
order by median_rating;

-- It is a good practice to use the 'ORDER BY' clause.

/* Movies with a median rating of 7 are the highest in number. 
Now, let's find out the production house with which RSVP Movies should look to partner with for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)?

/* Output format:
+------------------+-------------------+----------------------+
|production_company|    movie_count	   |    prod_company_rank |
+------------------+-------------------+----------------------+
| The Archers	   |		1		   |			1	  	  |
+------------------+-------------------+----------------------+*/

-- Type your code below:
select * from movie;
select * from ratings;

with cte as
(
select m.production_company,count(*) movie_count
from movie m join ratings r 
on m.id = r.movie_id
where r.avg_rating > 8
and m.production_company is not null
group by m.production_company
order by movie_count desc
)select *,rank() over(order by movie_count desc) as prod_company_rank from cte;

-- It's okay to use RANK() or DENSE_RANK() as well.
-- The answer can be either Dream Warrior Pictures or National Theatre Live or both.

-- Q14. How many movies released in each genre in March 2017 in the USA had more than 1,000 votes?

/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select * from movie;
select * from genre;
select * from ratings;

select g.genre,count(m.title) as movie_count
from movie m join genre g 
on m.id = g.movie_id
join ratings r 
on m.id = r.movie_id
where m.country = 'USA'
and m.date_published between '2017-03-01' and '2017-03-31'
and r.total_votes > 1000
group by g.genre
order by movie_count desc;

-- Lets try analysing the 'imdb' database using a unique problem statement.

-- Q15. Find the movies in each genre that start with the characters ‘The’ and have an average rating > 8.

/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
select * from movie;
select * from genre;
select * from ratings;

with cte as
(
select m.id,m.title,g.genre from 
movie m left join genre g
on m.id=g.movie_id
where title like "the%"
) select c.title,r.avg_rating,c.genre
from cte c left join ratings r 
on c.id=r.movie_id
where avg_rating > 8;

-- You should also try out the same for median rating and check whether the ‘median rating’ column gives any
-- significant insights.
with cte as
(
select m.id,m.title,g.genre from 
movie m left join genre g
on m.id=g.movie_id
where title like "the%"
) select c.title,r.median_rating,c.genre
from cte c left join ratings r 
on c.id=r.movie_id
where median_rating > 8;

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

-- Type your code below:
select * from movie;
select * from ratings;

with cte as
(
select m.title,m.date_published,r.median_rating
from movie m join ratings r
on m.id=r.movie_id
where date_published between "2018-04-01" and "2019-04-01"
) select * from cte
where median_rating = 8;

-- Now, let's see the popularity of movies in different languages.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select * from ratings;
select * from movie;

with cte as 
(
select m.title,m.languages,r.total_votes
from movie m left join ratings r
on m.id=r.movie_id
where languages in ("german","italian")
)select languages,sum(total_votes) from cte
group by languages; 

-- Answer is Yes

-- ----------------------------------------------------------------------------------------------------------------

/* Now that you have analysed the 'movie', 'genre' and 'ratings' tables, let us analyse another table - the 'names'
table. 
Let’s begin by searching for null values in the table. */

-- Segment 3:

-- Q18. Find the number of null values in each column of the 'names' table, except for the 'id' column.

/* Hint: You can find the number of null values for individual columns or follow below output format

+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

-- Type your code below:

-- Solution 1
select * from names;
select count(*)-count(name) as name_nulls,
count(*)-count(height) as height_nulls,
count(*)-count(date_of_birth) as date_of_birth_nulls,
count(*)-count(known_for_movies) as known_for_movies_nulls from names;

-- Solution 2
select sum(case when name is null then 1 else 0 end) as name_nulls,
sum(case when height is null then 1 else 0 end) as height_nulls,
sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;

/* Answer: 0 nulls in name; 17335 nulls in height; 13413 nulls in date_of_birth; 15226 nulls in known_for_movies.
   There are no null values in the 'name' column. */ 


/* The director is the most important person in a movie crew. 
   Let’s find out the top three directors each in the top three genres who can be hired by RSVP Movies. */

-- Q19. Who are the top three directors in each of the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

/* Output format:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select * from director_mapping;
select * from genre;
select * from names;
select * from movie;
select * from ratings;

with high_rated_movies as (
    select m.id, m.title, r.avg_rating
    from movie m join ratings r 
    on m.id = r.movie_id
    where r.avg_rating > 8
),genre_counts AS (
    select g.genre,count(*) AS genre_movie_count
    from high_rated_movies hr join genre g 
    on hr.id = g.movie_id
    group by g.genre
    order by genre_movie_count desc
    limit 3
),top_genre_movies as (
    select hr.id, hr.title, g.genre
    from high_rated_movies hr join genre g 
    on hr.id = g.movie_id
    where g.genre in (select genre from genre_counts)
),director_names as (
	select tgm.id, d.name_id, tgm.title, tgm.genre
    from top_genre_movies tgm join director_mapping d 
    on tgm.id = d.movie_id
),director_genre_counts as (
    select dn.genre, n.name, count(*) AS movie_count
    from director_names dn join names n 
    on dn.name_id = n.id
    group by dn.genre, n.name
),ranked_directors as (
    select *,row_number() OVER (partition by genre order by movie_count desc) as rnk
    from director_genre_counts
)select genre,name, movie_count from ranked_directors
where rnk <= 3
order by genre, rnk;

/* James Mangold can be hired as the director for RSVP's next project. You may recall some of his movies like 'Logan'
and 'The Wolverine'.
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?

/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christian Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select * from movie;
select * from names;
select * from role_mapping;
select * from ratings;

select n.name as actor_name,count(distinct m.title) as movie_count
from ratings r join movie m 
on r.movie_id = m.id
join role_mapping ro on r.movie_id = ro.movie_id
join names n on ro.name_id = n.id
where r.median_rating >= 8
and ro.category = 'actor'
group by n.name
order by movie_count desc
limit 2;

/* Did you find the actor 'Mohanlal' in the list? If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/
select * from movie;

select count(title) as movie_count,production_company
from movie
group by production_company 
order by movie_count desc 
limit 3 offset 1;




