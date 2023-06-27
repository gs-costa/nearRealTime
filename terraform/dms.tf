resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_description = "subnet group para instancia de replicação no dms"
  replication_subnet_group_id          = "dms-subnet-group"

  subnet_ids = [aws_subnet.subnet[1].id, aws_subnet.subnet[2].id]

  # explicit depends_on is needed since this resource doesn't reference the role or policy attachment
  depends_on = [aws_iam_role_policy_attachment.poc_nrt_policy]
}

# Create a new replication instance
resource "aws_dms_replication_instance" "dms_repl_instance" {
  allocated_storage            = 5
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = var.location[1]
  multi_az                     = false
  preferred_maintenance_window = "sun:00:30-sun:03:30"
  publicly_accessible          = false
  replication_instance_class   = "dms.t2.micro"
  replication_instance_id      = "pocnrt-dms-repl-instance"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_subnet_group.id
  vpc_security_group_ids       = [aws_security_group.sc_poc_nrt.id]

  depends_on = [
    aws_iam_role_policy_attachment.poc_nrt_policy,
    aws_db_instance.db_instance_poc_nrt
  ]
}

resource "aws_dms_endpoint" "source_endpoint" {
  database_name = local.rds_dbname
  endpoint_id   = "endpoint-rds"
  endpoint_type = "source"
  engine_name   = aws_db_instance.db_instance_poc_nrt.engine
  username      = local.rds_username
  password      = local.rds_password
  server_name   = aws_db_instance.db_instance_poc_nrt.address
  port          = aws_db_instance.db_instance_poc_nrt.port

}

resource "aws_dms_endpoint" "target_endpoint" {
  endpoint_id   = "endpoint-kinesis"
  endpoint_type = "target"
  engine_name   = "kinesis"
  kinesis_settings {
    service_access_role_arn = aws_iam_role.poc_nrt_role.arn
    stream_arn              = aws_kinesis_stream.pocnrt_stream.arn
  }

}

resource "aws_dms_replication_task" "dms_repl_task" {
  migration_type           = "cdc"
  replication_instance_arn = aws_dms_replication_instance.dms_repl_instance.replication_instance_arn
  replication_task_id      = "pocnrt-dms-repl-task"
  source_endpoint_arn      = aws_dms_endpoint.source_endpoint.endpoint_arn
  table_mappings           = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
  target_endpoint_arn      = aws_dms_endpoint.target_endpoint.endpoint_arn
  lifecycle {
    ignore_changes = [
      replication_task_settings,
    ]
  }

  depends_on = [
    aws_kinesis_stream.pocnrt_stream
  ]
}