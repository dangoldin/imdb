-- MonetDB
CREATE USER "imdb" WITH PASSWORD "imdb" NAME "IMDB Explorer" SCHEMA "sys";

CREATE SCHEMA "imdb" AUTHORIZATION "imdb";

ALTER USER "imdb" SET SCHEMA "imdb";

CREATE TABLE "title" (
  "id" int NOT NULL,
  "title" text NOT NULL,
  "imdb_index" varchar(12) DEFAULT NULL,
  "kind_id" int NOT NULL,
  "production_year" int DEFAULT NULL,
  "imdb_id" int DEFAULT NULL,
  "phonetic_code" varchar(5) DEFAULT NULL,
  "episode_of_id" int DEFAULT NULL,
  "season_nr" int DEFAULT NULL,
  "episode_nr" int DEFAULT NULL,
  "series_years" varchar(49) DEFAULT NULL,
  "md5sum" varchar(32) DEFAULT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "name" (
  "id" int NOT NULL,
  "name" text NOT NULL,
  "imdb_index" varchar(12) DEFAULT NULL,
  "imdb_id" int DEFAULT NULL,
  "gender" varchar(1) DEFAULT NULL,
  "name_pcode_cf" varchar(5) DEFAULT NULL,
  "name_pcode_nf" varchar(5) DEFAULT NULL,
  "surname_pcode" varchar(5) DEFAULT NULL,
  "md5sum" varchar(32) DEFAULT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "cast_info" (
  "id" int NOT NULL,
  "person_id" int NOT NULL,
  "movie_id" int NOT NULL,
  "person_role_id" int DEFAULT NULL,
  "note" text,
  "nr_order" int DEFAULT NULL,
  "role_id" int NOT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "person_birth" (
  "person_id" int NOT NULL,
  "birth_year" int NOT NULL,
  PRIMARY KEY ("person_id")
);

CREATE TABLE "person_height" (
  "person_id" int NOT NULL,
  "height_inches" float(24) NOT NULL,
  PRIMARY KEY ("person_id")
);
