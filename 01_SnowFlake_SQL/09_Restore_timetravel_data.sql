-- restore time travel data 

update our_first_db.public.test 
set email = null;

select * from our_first_db.public.test before (statement => '01b485ac-3201-17e0-0008-d1760001f30a');

-- restore above result of data 

-- do not directly overwrite the data into same table 
-- it will remove all meta data already avail for that table 
-- so we cant time travel before this 

-- so better go with 2nd approach 


// second approach 

create or replace table our_first_db.public.test_1 as
select * from our_first_db.public.test before (statement => '01b485ac-3201-17e0-0008-d1760001f30a');

truncate table our_first_db.public.test;

insert into  our_first_db.public.test 
select * from our_first_db.public.test_1 ;

select * from our_first_db.public.test;
