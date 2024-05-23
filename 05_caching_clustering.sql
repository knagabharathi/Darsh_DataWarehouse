-- to access the staging area 
create or replace stage manage_db.external_stages.aws_stage
    url = 's3://bucketsnowflakes3';

list @manage_db.external_stages.aws_stage;

create or replace table our_first_db.public.orders
(
order_id varchar(30),
amount int,
profit int,
quantity int,
category varchar(30),
subcategory varchar(30)
);

-- load the data into orders table 

copy into our_first_db.public.orders
from @manage_db.external_stages.aws_stage
file_format = (type = csv field_delimiter = ',' skip_header =1 )
pattern = '.*OrderDetails.*';

// Create table
CREATE OR REPLACE TABLE ORDERS_CACHING (
ORDER_ID	VARCHAR(30)
,AMOUNT	NUMBER(38,0)
,PROFIT	NUMBER(38,0)
,QUANTITY	NUMBER(38,0)
,CATEGORY	VARCHAR(30)
,SUBCATEGORY	VARCHAR(30)
,DATE DATE)  ;  

-- insert the large amount of data 
insert into orders_caching
select 
t1.order_id,
t1.amount,
t1.profit,
t1.QUANTITY,
t1.category,
t1.subcategory,
date(uniform(1500000000,1700000000,(RANDOM())))
from orders t1
cross join (select * from orders) t2
cross join (select top 100 * from orders) t3;


-- Query performance before cluster key 
select * from orders_caching;-- 25s

select * from orders_caching where date = '2020-06-10'; -- 654 ms
select * from orders_caching where date = '2020-06-10'; -- 49 ms (from cache- reuse the result)


-- adding cluster keys & compare the result 
alter table orders_caching cluster by (date) ;


select * from orders_caching where date = '2020-07-06'; -- 588ms (so costly)
-- it takes around 40- 45 mins to reflect in entire table

-- cluster by month 
select * from orders_caching where month(date) = 11;

alter table orders_caching cluster by (month(date));


// use exact same colum used in where condition
