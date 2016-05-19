-- Summarize avg age by decade, and role (actor vs actress)
select floor(m.year/10)*10 as movie_decade,
    a.role,
    avg(m.year - year(a.birth_date)) as avg_age
from actors a
join movie_actors ma on a.id = ma.actor_id
join movies m on m.id = ma.movie_id
where a.role in ('Actor', 'Actress')
and a.birth_date is not null and a.birth_date <> '000-00-00'
group by movie_decade, a.role
order by movie_decade, a.role;