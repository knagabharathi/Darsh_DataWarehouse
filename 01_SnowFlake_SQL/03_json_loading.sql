create or replace stage manage_db.external_stages.jsonstage
    url ='s3://bucketsnowflake-jsondemo' ;

create or replace file format manage_db.file_formats.jsonformat
type = json ;

create  database our_first_db;

create or replace table our_first_db.public.json_raw (
raw_file variant
);

copy into our_first_db.public.json_raw 
    from @manage_db.external_stages.jsonstage
    file_format = manage_db.file_formats.jsonformat
    files = ('HR_data.json');

select * from our_first_db.public.json_raw;

-- dict 
-- key : dict  (dict in dict )
-- key : List 
-- key : list (dict :k :v)

--- dictionary
select  raw_file:city,raw_file:first_name from our_first_db.public.json_raw;

select  raw_file:city::string City  ,raw_file:first_name::string as FirstName from our_first_db.public.json_raw;

select  $1:city::string City, $1:first_name::string FirstName from our_first_db.public.json_raw s;

SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:last_name::STRING as last_name,
    RAW_FILE:gender::STRING as gender
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


--dict in dict 
select  raw_file:job.salary::int Salary, raw_file:job.title::string title from OUR_FIRST_DB.PUBLIC.JSON_RAW;

-- list in dict 
select raw_file:prev_company from OUR_FIRST_DB.PUBLIC.JSON_RAW;
select raw_file:prev_company[0]::string from OUR_FIRST_DB.PUBLIC.JSON_RAW; -- returns 1 st value 
select raw_file:prev_company[1]::string from OUR_FIRST_DB.PUBLIC.JSON_RAW; -- returns 2nd value

--multiple dict in list in dict 
create or replace table Languages as 
select 
    raw_file:first_name::string as FirstName,
    f.value:languages::string as languages,
    f.value:level::string as level
from 
    our_first_db.public.json_raw , table(flatten(raw_file:spoken_languages)) f;

select * from languages;
