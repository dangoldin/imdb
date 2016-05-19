DROP TABLE movies;
DROP TABLE actors;
DROP TABLE movie_actors;

CREATE TABLE movies (
    id   int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(400),
    url  varchar(400),
    year int,
    UNIQUE (url)
);

CREATE TABLE actors (
    id   int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(400),
    url  varchar(400),
    role varchar(200),
    birth_date date,
    death_date date,
    UNIQUE (url)
);

CREATE TABLE movie_actors (
    id   int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    actor_id int NOT NULL,
    movie_id int NOT NULL,
    unique (actor_id, movie_id)
);