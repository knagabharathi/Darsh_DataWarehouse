// steps to Load spotify data on snowflake

// 1. create 3 tables on snowflakeDB - tblalbum, tblartist, tblsongs 
// 2. create storage stage to test connection with aws
// 3. Test copy command and load the data
// 4. Create 3 snowpipe for indivudual folders 
// 5. Run and complete the pipeline to test it 


-- creating 3 tables in spotify database
create or replace table album
(
album_id string,
album_name ,
album_realse_date date,
album_total_tracks int,
album_url string
);

create or replace table artist 
(
artist_id string,
artist_name string,
artist_type string,
artist_link string
);

create or replace table songs 
(
song_id string,
song_name string,
song_duration int,
song_url string,
song_popularity int ,
song_added date,
album_id string,
artist_id string
);

-- creating external stage 
create or replace schema external_stage;

create or replace schema file_format;

--creating file format 
create or replace file format spotify_db.file_format.csv_file_format 
type = csv 
field_delimiter = ','
FIELD_OPTIONALLY_ENCLOSED_BY = '"' 
ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
skip_header = 1
null_if = ('NULL','null')
empty_field_as_null = TRUE;


-- create storage integeration 
-- inside the role arn avail -- IAM-> s3access -> arn (Copy)
-- inside s3 - transformed data folder -> copy URI
create or replace storage integration s3_init
    type = external_stage
    storage_provider = s3
    storage_aws_role_arn = '--- arn --- '
    enabled = true
    storage_allowed_locations = ( '---transformed_data -- url -- location --' )
    comment = 'creating storage integeration';

desc storage integration s3_init;
    
-- creating stage 
CREATE OR REPLACE stage spotify_db.external_stage.aws_stage 
    URL = 's3://spotify-etl-project-naga/transformed_data/'
    STORAGE_INTEGRATION = s3_init
    FILE_FORMAT =spotify_db.file_format.csv_file_format;

-- list of files in the stage
LIST @spotify_db.external_stage.aws_stage;

-- copy into respected tables 
-- album 
COPY INTO spotify_db.public.tblalbum
    FROM @spotify_db.external_stage.aws_stage
    file_format = spotify_db.file_format.csv_file_format 
    pattern='.*album_transformed.*';



-- artist 
COPY INTO spotify_db.public.tblartist
    FROM @spotify_db.external_stage.aws_stage
    FILE_FORMAT = spotify_db.file_format.csv_file_format
    pattern='.*artist_transformed.*';

-- songs 
copy into spotify_db.public.tblsongs
from @spotify_db.external_stage.aws_stage 
file_format = spotify_db.file_format.csv_file_format 
pattern ='.*songs_transformed.*';

select * from spotify_db.public.tblalbum;
select * from spotify_db.public.tblsongs;
select * from spotify_db.public.tblartist;

-- renamed the tables
alter table album rename to tblAlbum;
alter table artist rename to tblartist;
alter table songs rename to tblSongs; 


-- create schema for pipes 
create or replace schema spotify_db.pipes;

-- create pipes for indivudual tables 
create or replace pipe spotify_db.pipes.album_pipe 
auto_ingest = TRUE 
as 
COPY INTO spotify_db.public.tblalbum
    FROM @spotify_db.external_stage.aws_stage
    file_format = spotify_db.file_format.csv_file_format 
    pattern='.*album_transformed.*';

desc pipe spotify_db.pipes.album_pipe;

-- artist

create or replace pipe spotify_db.pipes.artist_pipe 
auto_ingest = TRUE 
as 
copy into spotify_db.public.tblartist
from @spotify_db.external_stage.aws_stage
file_format = spotify_db.file_format.csv_file_format 
pattern ='.*artist_transformed.*';

desc pipe spotify_db.pipes.artist_pipe;

-- songs 

create or replace pipe spotify_db.pipes.songs_pipe 
auto_ingest = TRUE 
as 
copy into spotify_db.public.tblsongs
from @spotify_db.external_stage.aws_stage 
file_format = spotify_db.file_format.csv_file_format 
pattern ='.*songs_transformed.*';

desc pipe spotify_db.pipes.songs_pipe;


select * from spotify_db.public.tblalbum;
select * from spotify_db.public.tblsongs;
select * from spotify_db.public.tblartist;
