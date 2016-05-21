create index pi_person_id_idx on person_info (person_id);

create index ci_movie_id_idx on cast_info (movie_id);

create index ci_person_id_idx on cast_info (person_id);

create index pi_info_type_id_idx on person_info (info_type_id);

create index t_kind_type_id_idx on title (kind_id);

create table person_birth (
  `person_id` int(11) NOT NULL UNIQUE KEY,
  `birth_year` int(11) NOT NULL
);

-- Birthdate is a year
insert into person_birth
    SELECT person_id, cast(info as UNSIGNED)
    FROM person_info
    WHERE info_type_id = 21
    AND length(info) = 4;

-- Birthdate is full date so just take the year
insert into person_birth
    SELECT person_id, cast(substring(info, locate(' ', info, 4) + 1, 4) as unsigned)
    FROM person_info
    WHERE info_type_id = 21
    AND length(info) > 4;

create table person_height (
    `person_id` int(11) NOT NULL UNIQUE KEY,
    `height_inches` float NOT NULL
);

-- Centimeters
insert into person_height
    SELECT person_id, cast(replace(info, ' cm','') as unsigned) * 0.393701
    FROM person_info
    WHERE info_type_id = 22
    AND info like '%cm';

-- No inches
SELECT person_id, substring(info, 1, locate('\'', info) - 1) * 12
    FROM person_info
    WHERE info_type_id = 22
    AND info not like '%cm'
    AND info not like '%/%'
    AND info not like '%"%';

-- No fractional inches (would also work for no inches but playing it safe)
insert into person_height
SELECT person_id, substring(info, 1, locate('\'', info) - 1) * 12 + substring(info, locate('\'', info) + 1, locate('"', info) - locate('\'', info) - 1)
    FROM person_info
    WHERE info_type_id = 22
    AND info not like '%cm'
    AND info not like '%/%'
    AND info like '%"%';

-- Fractional inches
