// Create table first
create or replace table our_first_db.public.employees (
id int,
first_name string,
last_name string,
email string,
location string,
department string
);

-- create file format
create or replace file format manage_db.file_formats.csv_file_format
type = csv
field_delimiter =','
skip_header = 1
null_if = ('NULL','null')
empty_field_as_null = TRUE;

-- create stage object with integeration object & file format object 
create or replace stage manage_db.external_stages.csv_folder 
url = 's3://snowflake3bucket123/csv/snowpipe'
storage_integeration = s3_init
file_format = manage_db.file_format.csv_fileformat;


-- create stage object with integeration object & file format object 
list @manage_db.external_stage.csv_folder;

-- create schema to keep things organized 
create or replace schema manage_db.pipes;


-- define pipe 
create or replace pipe manage_db.pipes.employee_pipe
auto_ingest = TRUE
as
copy into our_first_db.public.employees
from @manage_db.external_stages.csv_folder;

--describe pipe notification channel and copy it for s3 event 
desc pipe employee_pipe;

--> s3 event -> all notification -->sql --> paste value of channel 

select * from our_first_db.public.employees;


--Manage pipes 
desc pipe mange_db.pipes.employees;

show pipes;
show pipes like '%employee%';
show pipes in database manage_db;
show pipes in schema manage_db.pipes;
show pipes like '%employee%' in database manage_db;
