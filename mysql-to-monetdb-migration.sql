-- MySQL export
select * from title into outfile '/tmp/title.csv' fields terminated by ',' enclosed by '"' escaped by "\\" lines terminated by '\n';

select * from name into outfile '/tmp/name.csv' fields terminated by ',' enclosed by '"' escaped by "\\" lines terminated by '\n';

select * from cast_info into outfile '/tmp/cast_info.csv' fields terminated by ',' enclosed by '"' escaped by "\\" lines terminated by '\n';

select * from person_birth into outfile '/tmp/person_birth.csv' fields terminated by ',' enclosed by '"' escaped by "\\" lines terminated by '\n';

select * from person_height into outfile '/tmp/person_height.csv' fields terminated by ',' enclosed by '"' escaped by "\\" lines terminated by '\n';

-- MonetDB import
COPY INTO title from '/tmp/title.csv' USING DELIMITERS ',','\n','"' NULL AS '\\N';

COPY INTO name from '/tmp/name.csv' USING DELIMITERS ',','\n','"' NULL AS '\\N';

COPY INTO cast_info from '/tmp/cast_info.csv' USING DELIMITERS ',','\n','"' NULL AS '\\N';

COPY INTO person_birth from '/tmp/person_birth.csv' USING DELIMITERS ',','\n','"' NULL AS '\\N';

COPY INTO person_height from '/tmp/person_height.csv' USING DELIMITERS ',','\n','"' NULL AS '\\N';
