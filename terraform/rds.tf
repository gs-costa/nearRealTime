resource "aws_db_subnet_group" "dsg_poc_nrt" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id, aws_subnet.subnet[2].id]

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_db_parameter_group" "params_dms_postgresql" {
  name   = "params-postgresql-dms"
  family = "postgres12"

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
}

resource "aws_db_instance" "db_instance_poc_nrt" {
  allocated_storage      = 10
  identifier             = "db-instance-poc-nrt"
  db_name                = local.rds_dbname
  engine                 = "postgres"    #aurora-postgresql
  instance_class         = "db.t2.micro" #"db.serverless"
  engine_version         = "12.14"
  username               = local.rds_username
  password               = local.rds_password
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.dsg_poc_nrt.id
  vpc_security_group_ids = [aws_security_group.sc_poc_nrt.id]
  skip_final_snapshot    = true
  apply_immediately      = false
  parameter_group_name   = aws_db_parameter_group.params_dms_postgresql.name
  availability_zone      = var.location[0]
  # monitoring_role_arn    = aws_iam_role.poc_nrt_role.arn
}
