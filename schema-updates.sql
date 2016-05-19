create index pi_person_id_idx on person_info (person_id);

create index ci_movie_id_idx on cast_info (movie_id);

create index ci_person_id_idx on cast_info (person_id);

create index pi_info_type_id_idx on person_info (info_type_id);

create index t_kind_type_id_idx on title (kind_id);

create table person_birth (
  `person_id` int(11) NOT NULL UNIQUE KEY,
  `birth_year` int(11) NOT NULL
);

insert into person_birth
    SELECT person_id, cast(info as UNSIGNED)
    FROM person_info
    WHERE info_type_id = 21
    AND length(info) = 4;

insert into person_birth
    SELECT person_id, cast(substring(info, locate(' ', info, 4) + 1, 4) as unsigned)
    FROM person_info
    WHERE info_type_id = 21
    AND length(info) > 4;
