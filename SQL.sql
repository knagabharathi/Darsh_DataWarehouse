// Database to manage stage objects, file formats, etc//

-- creating database 
create or replace database manage_db;

-- creating schema
create or replace schema external_stages;

-- creating external stage 
create or replace stage manage_db.external_stages.aws_stage
    url ='s3://dw-snowflake-course-darshil';

--desc 
desc stage manage_db.external_stages.aws_stage;

-- listing stage 
list stage manage_db.external_stages.aws_stage;

--alter the external stage 
alter stage aws_stage
set credentials =(aws_key ='xyz_dummy_id' aws_secret_key ='987xyz');

--public accessible staging area
create or replace stage manage_db.external_stages.aws_stage
url ='s3://bucketsnowflakes3';

list @aws_stage;

// Creating ORDERS table
CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

SELECT * FROM MANAGE_DB.PUBLIC.ORDERS;

--copying data 
copy into manage_db.public.orders
from @aws_stage
file_format = (type = csv field_delimiter ="," skip_header = 1)
files = ('OrderDetails.csv');

-- creating transforming table 
create or replace table manage_db.public.orders_ex (
    order_id varchar(30),
    amount int
);

--copying into transformed table 
copy into select * from manage_db.public.orders_ex;
from (select s.$1 ,s.$2 from @manage_db.external_stages.aws_stage s )
file_format = (type = csv field_delimiter ="," skip_header = 1)
files = ('OrderDetails.csv');

select * from manage_db.public.orders_ex;

--transformed table with logic
create or replace table manage_db.public.orders_ex1 (
    order_id varchar(30),
    amount int,
    profit int,
    category_substring varchar(30)
);


--copying data 
copy into manage_db.public.orders_ex1
from (select 
        s.$1,
        s.$2,
        s.$3,
        case when cast(s.$3 as int) < 0 then 'not profitable' else 'profitable' end 
    from @manage_db.external_stages.aws_stage s)
file_format = (type = csv field_delimiter =',' skip_header = 1)
files =('OrderDetails.csv');


select * from manage_db.public.orders_ex1;
