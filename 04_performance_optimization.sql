// Data scientist 
create or replace warehouse ds_wh
with  WAREHOUSE_TYPE = 'STANDARD'
WAREHOUSE_SIZE = 'SMALL'
MAX_CLUSTER_COUNT = 1
MIN_CLUSTER_COUNT = 1
SCALING_POLICY = 'STANDARD'
AUTO_SUSPEND =  300
AUTO_RESUME = TRUE ;

//DBA 
create or replace warehouse dba_wh 
with WAREHOUSE_TYPE = 'STANDARD'
WAREHOUSE_SIZE = 'XSMALL'
MAX_CLUSTER_COUNT = 1
MIN_CLUSTER_COUNT = 1
SCALING_POLICY = 'STANDARD'
AUTO_SUSPEND =  300
AUTO_RESUME = TRUE ;

// create roll for data scientist and DBA

create role data_scientist;
grant usage on warehouse ds_wh to role data_scientist;

create role dba;
grant usage on warehouse dba_wh to role dba;

// setting the users with roles 

create user ds1 password ='ds1' login_name = 'ds1' default_role ='data_scientist'
default_warehouse ='ds_wh' must_change_password = FALSE ;
create user ds2 password ='ds2' login_name = 'ds2' default_role ='data_scientist'
default_warehouse ='ds_wh' must_change_password = FALSE ;
create user ds3 password ='ds3' login_name = 'ds3' default_role ='data_scientist'
default_warehouse ='ds_wh' must_change_password = FALSE ;

grant role data_scientist to user ds1;
grant role data_scientist to user ds2;
grant role data_scientist to user ds3;

// DBAs
CREATE USER DBA1 PASSWORD = 'DBA1' LOGIN_NAME = 'DBA1' DEFAULT_ROLE='DBA' DEFAULT_WAREHOUSE = 'DBA_WH'  MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DBA2 PASSWORD = 'DBA2' LOGIN_NAME = 'DBA2' DEFAULT_ROLE='DBA' DEFAULT_WAREHOUSE = 'DBA_WH'  MUST_CHANGE_PASSWORD = FALSE;

GRANT ROLE DBA TO USER DBA1;
GRANT ROLE DBA TO USER DBA2;

// drop objects 
 drop user ds1;
 drop user ds2;
 drop user ds3;

 drop role data_scientist;
 drop role dba;

 drop warehouse ds_wh;
 drop warehouse dba_wh;


