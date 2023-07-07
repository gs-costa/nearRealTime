# nearRealTime
Project with pipeline on AWS in near real-time update, with architecture with IAM, VPC, RDS, DMS, Kinesis, S3 and Redshift services.
The services were provided by Infra As Code (Terraform).

![image](https://github.com/gs-costa/nearRealTime/assets/97529915/5f50f081-de97-4db2-99a6-cea44fae58ac)

The proposal was to add random data via Python script in a relational database, in this case RDS with PostgreSQL engine was used. 
AWS DMS has the role of performing CDC and only sending new records or updates from the relational database to AWS Kinesis. 
The latter receives the data through Kinesis Data Stream, accumulates it over a period of time and then loads it into AWS Redshift, the data warehouse, using Kinesis Firehose. S3 serves as an intermediary in loading Kinesis for Redshift.

There's some important details to consider before starting the pipeline. In the RDS instance to allow DMS execute CDC, have to set the following parameters group:

parameter {
    name  = "session_replication_role"
    value = "replica"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wal_sender_timeout"
    value        = 0
    apply_method = "pending-reboot"
  }

It's easier to see how to apply it on https://github.com/gs-costa/nearRealTime/blob/main/terraform/rds.tf.
Another detail is create an endpoint, with only private subnets, to connect Kinesis to the VPC used on RDS and DMS.

With this information in hand, you will be able to create your own pipeline in near real time. If not, I'm available for questions!
Good Luck!
