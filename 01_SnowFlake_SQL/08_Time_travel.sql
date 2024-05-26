create or replace file format manage_db.file_formats.csv_file_format
type = csv 
field_delimiter =','
skip_header = 1;

create or replace table our_first_db.public.test
(
id int,
first_name string,
last_name string,
email string,
gender string,
job string,
phone string
);

create or replace stage manage_db.external_stages.time_travel_stage 
url ='s3://data-snowflake-fundamentals/time-travel/'
file_format =  manage_db.file_formats.csv_file_format;


list @manage_db.external_stages.time_travel_stage;

copy into our_first_db.public.test
from @manage_db.external_stages.time_travel_stage
files = ('customers.csv');

select * from our_first_db.public.test;

// Method 1 : offset method 
update our_first_db.public.test
set first_name  ='Joyen';

-- using time travel 1-2 mins back 
select * from our_first_db.public.test at (offset => -60*2);

truncate our_first_db.public.test;


// Method 2 : timestamp 
select * from our_first_db.public.test;

alter session set timezone ='UTC';
select current_timestamp; -- 2024-05-23 07:19:25.974 -0700

update our_first_db.public.test 
set job ='data scientist';

select * from our_first_db.public.test;

select * from our_first_db.public.test before 
(timestamp => '2024-05-23 14:19:17.676'::timestamp);



// Method 3 -- Using query id 
update our_first_db.public.test 
set   email = null;

select * from our_first_db.public.test before (statement => '01b485a0-3201-175a-0008-d1760001d27e');
