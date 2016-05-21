select n.gender, t.production_year, avg(t.production_year - pb.birth_year) as avg_age, count(1) as cnt, count(distinct(t.id)) as num_movies
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
group by n.gender, t.production_year;

select n.gender, t.production_year, avg(t.production_year - pb.birth_year) as avg_age, count(1) as cnt, count(distinct(t.id)) as num_movies
from title t
join cast_info ci on t.id = ci.movie_id and t.kind_id = 1
join name n on n.id = ci.person_id
join person_birth pb on n.id = pb.person_id
where ci.person_id in (
  select person_id
  from cast_info
  group by person_id
  having count(1) > 200
)
group by n.gender, t.production_year;

