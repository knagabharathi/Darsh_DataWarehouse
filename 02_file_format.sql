--create schema 
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

--create a file format object 
create or replace file format manage_db..my_file_format;

-- desc 
desc file format manage_db.file_formats.my_file_format;

-- alter the file format feature 
alter file format manage_db.file_formats.my_file_format 
set skip_header = 1;

desc file format manage_db.file_formats.my_file_format;

// Defining properties on creation of file format object   
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format
    TYPE=JSON,
    TIME_FORMAT=AUTO;   

-- Altering the type of a file format is not possible
ALTER file format MANAGE_DB.file_formats.my_file_format
SET TYPE = CSV;
-- getting error 
-- cant change the type of file format 


CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file_format
TYPE = CSV,
FIELD_DELIMITER = ","
SKIP_HEADER = 1;

TRUNCATE  MANAGE_DB.PUBLIC.ORDERS;

--  used the created file format instead of giving all the details
COPY INTO MANAGE_DB.PUBLIC.ORDERS
    FROM  @MANAGE_DB.external_stages.aws_stage
    file_format = (FORMAT_NAME= MANAGE_DB.file_formats.csv_file_format )
    files = ('OrderDetails.csv');

SELECT * FROM  MANAGE_DB.PUBLIC.ORDERS;
