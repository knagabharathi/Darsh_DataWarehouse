

-- remove caching just to have a fair test 
alter session set use_cached_result = FALSE;
alter warehouse compute_wh suspend;
alter warehouse compute_wh resume;

-- prepare the table 

create or replace transient database orders;

create or replace schema tpch_sf100;

create or replace table tpch_sf100.orders as 
select * from snowflake_sample_data.tpch_sf100.orders;


select * from orders limit 100;


-- example of statement view -- 
select 
year(o_orderdate) as year,
max(o_comment) as max_comment, 
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);  -- 7.5 sec


create or replace materialized view orders_mv 
as 
select 
year(o_orderdate) as year,
max(o_comment) as max_comment, 
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE); 

show materialized views; --  behind by 0s

-- query view 
select * from orders_mv order by year;  -- 419 sec 

-- update or delete values 
update orders set o_clerk = 'Clerk#99900000' 
WHERE O_ORDERDATE='1992-01-01';

--after update
show materialized views; --  behind by 05m47s

select * from orders_mv order by year;
show materialized views;

   -- Test updated data --
-- Example statement view -- 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);



-- Query view
SELECT * FROM ORDERS_MV
ORDER BY YEAR;


SHOW MATERIALIZED VIEWS;
