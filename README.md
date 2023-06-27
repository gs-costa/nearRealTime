# nearRealTime
Project with pipeline on AWS in near real-time update, with architecture with IAM, VPC, RDS, DMS, Kinesis, S3 and Redshift services.
The services were provided by Infra As Code (Terraform).

The proposal was to add random data via Python script in a relational database, in this case RDS with PostgreSQL engine was used. 
AWS DMS has the role of performing CDC and only sending new records or updates from the relational database to AWS Kinesis. 
The latter receives the data through Kinesis Data Stream, accumulates it over a period of time and then loads it into AWS Redshift, the data warehouse, using Kinesis Firehose. S3 serves as an intermediary in loading Kinesis for Redshift.
