-- QA
select t.id, t.title, t.production_year, pb.birth_year, n.name, n.id, (t.production_year - pb.birth_year) as age
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1 and ci.role_id in (1,2)
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
where t.production_year is not null
and t.production_year > pb.birth_year
order by age desc
limit 10;

select t.id, t.title, t.production_year, pb.birth_year, n.name, n.id, (t.production_year - pb.birth_year) as age
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1 and ci.role_id in (1,2)
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
where t.production_year is not null
and t.production_year > pb.birth_year
order by age asc
limit 10;

-- Lessons (Need to focus on actors + actresses)

-- Age
select n.gender, t.production_year, avg(t.production_year - pb.birth_year) as avg_age, count(1) as cnt, count(distinct(t.id)) as num_movies
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1 and ci.role_id in (1,2)
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
where t.production_year > pb.birth_year
and t.production_year < 2016
and t.production_year >= 1920
group by n.gender, t.production_year;

select n.gender, t.production_year, avg(t.production_year - pb.birth_year) as avg_age, count(1) as cnt, count(distinct(t.id)) as num_movies
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1 and ci.role_id in (1,2)
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
where ci.person_id in (
  select person_id
  from cast_info
  group by person_id
  having count(1) > 200
)
and t.production_year > pb.birth_year
and t.production_year < 2016
and t.production_year >= 1920
group by n.gender, t.production_year;

select n.gender, (t.production_year - pb.birth_year) as age, count(1) as cnt, count(distinct(t.id)) as num_movies
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1 and ci.role_id in (1,2)
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
where t.production_year > pb.birth_year
and t.production_year < 2016
and t.production_year >= 1920
group by n.gender, age;

select t.production_year/10 * 10 as decade, n.gender, (t.production_year - pb.birth_year) as age, count(1) as cnt, count(distinct(t.id)) as num_movies
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1 and ci.role_id in (1,2)
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
where t.production_year > pb.birth_year
and t.production_year < 2016
and t.production_year >= 1920
group by decade, n.gender, age;

-- Number of movies distribution

-- Height
select n.gender, t.production_year, avg(ph.height_inches) as avg_height, count(1) as cnt, count(distinct(t.id)) as num_movies
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1
join name n on n.id = ci.person_id
join person_height ph on n.id = ph.person_id
group by n.gender, t.production_year;
