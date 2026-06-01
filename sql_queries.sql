select * from netflix
DROP TABLE netflix;

CREATE TABLE netflix(
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT column_name,
       data_type,
       character_maximum_length
FROM information_schema.columns
WHERE table_name = 'netflix';


select COUNT(*) as Total_count from netflix;

select distinct type from netflix;

select * from netflix;

--15 problems of business 

--1.count the no.of Movie vs TV show
select type,count(*) as total_count from netflix group by type;

--2.find most common rating for movies and tvshows
select 
type,rating from 
(
select type,rating,count(*),
RANK() OVER(partition by type order by count(*) DESC) as ranking
from netflix 
group by type,rating 
--order by type,count DESC
)as table1
where ranking=1;

--3.list out all the movies released in a specific year (2022)
select title from netflix where 
type='Movie' and 
release_year=2020;

--4.find the top 5 countries with the most content on netflix
select country,count(*) as content from netflix group by country 

--5.identify the longest movie
select * from netflix 
where 
type='Movie' 

and 

CAST(NULLIF(SPLIT_PART(duration,' ',1),'') as INT)=

(select max(

CAST(NULLIF(SPLIT_PART(duration,' ',1),'') as INT)
)
from netflix
where type='Movie'
); 

select * from netflix
--6.find connect added in the last 5 years
select *
from netflix 
where to_date(date_added,'month dd, yyyy') >= current_date-interval '5 years'


select current_date-interval '5 years'

--7.find all the movies/TV shows by director 'Rajiv Chilaka'
select * from netflix where director like  '%Rajiv Chilaka%'
select * from netflix
select * from netflix where director ilike  '%Rajiv Chilaka%'

--8.list all tv shows with more than 5 seasons
select *,
split_part(duration,' ',1) as season_num 
from netflix where type='TV Show'  and split_part(duration,' ',1)::numeric > 5

--9.count the number of content items in each genre
select unnest(string_to_array(listed_in,',')) as genre,
count(show_id)
from netflix group by unnest(string_to_array(listed_in,','))

--10.find each year and the avg number of content release by india on netflix.return 
--top 5 year with highest avg content release
select 
extract(year from to_date(date_added,'month dd yyyy')) as year,
count(*) as yearly_content,
round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric *100
,2) as avg_content

from netflix   where country ='India' group by extract(year from to_date(date_added,'month dd yyyy'))


--11.list all movies that are doucumentaires
select * from netflix where listed_in ilike '%documentaries%'

--12.find all content without a director
select * from netflix where director ilike ''

--13.find how many movies actor salman khan appeared in last 10 years
select * from netflix 
where "casts" ilike '%Salman khan%' and release_year >extract(year from current_date)-10
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman%';

--14.find the top 10 actors who have appeared in the highest number of movies produced in  india 
select 
unnest(string_to_array("cast",',')) as actors,
count(*) as total_content 
from netflix where country ilike 'India'
group by 1
order by 2 DESC
limit 10

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'netflix';


--15.categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.label content containing 
--these keywords as 'Bad' and all other content as 'Good'.count how many items fall into each categorie\
with new_table 
as 
(
select *,
case
	when
	description ilike '%kill%' or 
    description ilike '%violence%' then 'Bad_content'
    else 'Good_content'
    end category
from netflix 
)
select category,
count(*) from new_table 
group by 1

--where description ilike '%kill%' or 
-- description ilike '%violence%'



