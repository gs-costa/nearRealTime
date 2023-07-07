# Near Real-time
This project addresses a genuine problem by identifying the specific stage at which new clients abandon the onboarding process for creating their bank account. By analyzing where a significant number of clients encounter obstacles, we can pinpoint potential bugs or issues that may be hindering their progress.

Facing to solve it, developed an exciting AWS project that combines a streamlined pipeline for near real-time updates. The architecture is powered by essential AWS services like IAM, VPC, RDS, DMS, Kinesis, S3, and Redshift. To simplify deployment and management, we've used Infrastructure as Code (Terraform) to seamlessly provision these services.

![near_Real-time drawio](https://github.com/gs-costa/nearRealTime/assets/97529915/a1139103-2e27-4c83-a1d8-7e918ce80fd4)

The proposal involved utilizing a Python script to inject randomized data into a relational database, specifically an RDS instance powered by the PostgreSQL engine.To achieve this, AWS DMS takes on the responsibility of conducting Change Data Capture (CDC), selectively transmitting only new records and updates from the relational database to AWS Kinesis.
Kinesis Data Stream acts as the recipient, collecting and aggregating the data over a specific timeframe, which is then efficiently loaded into AWS Redshift, the designated data warehouse, with the aid of Kinesis Firehose. During this process, S3 plays a vital role as an intermediary for loading data from Kinesis into Redshift.

Before starting the pipeline, it is crucial to take into account certain important details. In order to enable DMS to execute CDC in the RDS instance, the following parameter group needs to be configured:

Parameter: session_replication_role
Value: replica

Parameter: rds.logical_replication
Value: 1

Parameter: wal_sender_timeout
Value: 0

To understand its application better, you can refer to the following link: https://github.com/gs-costa/nearRealTime/blob/main/terraform/rds.tf. Additionally, it's important to note that in order to connect Kinesis to the VPC used for RDS and DMS, it is necessary to create an endpoint exclusively in private subnets.

Now that you have all the necessary information, you can easily whip up your very own pipeline in no time! But if you need any help or have questions, feel free to reach out to me. Good luck!
