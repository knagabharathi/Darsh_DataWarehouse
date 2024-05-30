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

## [Spotify-End-To-End-Data-Engineering-Project-Using-Python](https://github.com/knagabharathi/Darsh_DataWarehouse/tree/main/02_End_to_end_Spotify_proj)

In this project we have taken raw data from spotify website using webscraping and inbuild python packages to convert that raw data into transformed data.
Then we have used AWS services to build our automated pipeline to store and process our data.

AWS S3: To store our data.


AWS Lambda: To extract and transformed our data using Python


AWS Trigger: To set the trigger when the pipeline should run.


AWS Glue: It contain metadata of our data.


Amazon Athena: Analytics platform (We can run SQL queries for some analysis purpose)

## [Real-Time Data Streaming using Apache Nifi, AWS, Snowpipe, Stream & Task](https://github.com/knagabharathi/Darsh_DataWarehouse/tree/main/03_Real-Time%20Data%20Streaming%20using%20Apache%20Nifi%2C%20AWS%2C%20Snowpipe%2C%20Stream%20%26%20Task)

## Components

- **Apache NiFi:** Handles data ingestion, routing, and transformation.
- **AWS Snowpipe:** Automates data loading from Amazon S3 into Snowflake.
- **AWS Stream & Task:** Orchestrates real-time processing tasks and workflows.

## Features

- **Real-Time Data Ingestion:** Apache NiFi facilitates real-time data ingestion from various sources.
- **Automated Data Loading:** AWS Snowpipe ensures automated and efficient loading of data into Snowflake.
- **Stream Processing:** AWS Stream & Task enables real-time processing and orchestration of data workflows.

## Installation

1. **Apache NiFi:**
   - Download and install Apache NiFi from [Apache NiFi Website](https://nifi.apache.org/download.html).

2. **AWS Snowpipe:**
   - Set up Snowpipe for Snowflake according to [AWS Snowpipe Documentation](https://docs.aws.amazon.com/snowflake/latest/user-guide/data-load-snowpipe.html).

3. **AWS Stream & Task:**
   - Configure AWS Stream & Task as per [AWS Stream & Task Documentation](https://aws.amazon.com/stream-task/).

## Usage

1. **Deploy Apache NiFi Flow:**
   - Import and deploy the Apache NiFi flow template provided in the `nifi_flow.xml`.

2. **Configure Snowpipe:**
   - Set up Snowpipe integration with your Snowflake account and S3 buckets.

3. **Implement Stream & Task Workflows:**
   - Create and deploy AWS Stream & Task workflows for real-time data processing.

## Contributing

Contributions are welcome! Please fork this repository, make your changes, and submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
