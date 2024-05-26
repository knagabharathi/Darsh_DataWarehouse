create database demo_db;

use demo_db;
use role accountadmin;


-- prepare table -- 

create or replace table customers (
 id number,
  full_name varchar, 
  email varchar,
  phone varchar,
  spent number,
  create_date DATE DEFAULT CURRENT_DATE);

-- insert values into table 
insert into customers (id,full_name,email,phone,spent )
values 
  (1,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
  (2,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
  (3,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
  (4,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
  (5,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
  (6,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);


select * from customers;
drop database demo_db;
drop table customers;
drop role analyst_full;
drop role analyst_masked;

-- create 2 diff roles 
create or replace role analyst_full;
create or replace role analyst_masked;

-- grant select on tables to roles 
grant select on table demo_db.public.customers to role analyst_full;
grant select on table demo_db.public.customers to role analyst_masked;

grant usage on database demo_db  to role analyst_full;
grant usage on database demo_db  to role analyst_masked;

grant usage on schema demo_db.public to role analyst_full;
grant usage on schema demo_db.public to role analyst_masked;

grant usage on warehouse compute_wh to role analyst_full;
grant usage on warehouse compute_wh to role analyst_masked;

-- assign roles to user 
grant role analyst_masked to user NAGUBHARU;
grant role analyst_full to user NAGUBHARU;


-- set up masking policy 

create or replace masking policy p_phone 
    as (val varchar) returns varchar ->
            case        
            when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
            else '##-###-##'
            end;

-- apply policy to a specific column 
alter table if exists customers modify column phone 
set masking policy p_phone;

alter table if exists customers modify column phone 
unset masking policy;

describe masking policy p_phone;
show masking policies;
drop masking policy P_PHONE;

use role analyst_full;
select * from customers;

use role analyst_masked;
select * from customers;


-- 2 

create or replace masking policy p_name 
as (val varchar) returns varchar ->
    case 
    when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val 
    else concat(left(val,2),'*******')
    end;

-- apply policy 
alter table if exists customers modify column full_name 
set masking policy p_name;


SHOW MASKING POLICIES;
drop masking policy P_NAME;

-- validating policies 
use role analyst_full;
select * from customers;

use role analyst_masked;
select * from customers;



--- More examples - 3 - ###

create or replace masking policy dates as (val date) returns date ->
case
  when current_role() in ('ANALYST_FULL') then val
  else date_from_parts(0001, 01, 01)::date -- returns 0001-01-01 00:00:00.000
end;


-- Apply policy on a specific column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN create_date 
SET MASKING POLICY dates;


-- Validating policies

USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;
