# data-warehouse-snowflake-for-data-engineering
data-warehouse-snowflake-for-data-engineering 
contents 
* Stage copy
* File formats of snowflake
* Unstructure data handling- JSON
* Performance optimization
* cache and clustering
* storage integeration with s3
* snowpipe
* Time travel
* Time travel restore
* Undrop objects
* table types
* zero copy cloning
* Data sharing
* Materialized views
* Dynamic data masking 

## Module: [Spotfiy Data Pipeline End-To-End Python Data Engineering Project](https://github.com/knagabharathi/Darsh_DataWarehouse/tree/main/02_End_to_end_Spotify_proj)
Implement Complete Data Pipeline Data Engineering Project using Spotify 
* Integrating with Spotify API and extracting Data
* Deploying code on AWS Lambda for Data Extraction
* Adding trigger to run the extraction automatically 
* Writing transformation function
* Building automated trigger on transformation function 
* Store files on S3 properly
* Building Analytics Tables on data files using Glue and Athena

## Spotify-End-To-End-Data-Engineering-Project-Using-Python

In this project we have taken raw data from spotify website using webscraping and inbuild python packages to convert that raw data into transformed data.
Then we have used AWS services to build our automated pipeline to store and process our data.

AWS S3: To store our data.
AWS Lambda: To extract and transformed our data using Python
AWS Trigger: To set the trigger when the pipeline should run.
AWS Glue: It contain metadata of our data.
Amazon Athena: Analytics platform (We can run SQL queries for some analysis purpose)

