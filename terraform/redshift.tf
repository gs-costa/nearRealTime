resource "aws_redshift_subnet_group" "pocnrt_sg" {
  name       = "pocnrt-sg"
  subnet_ids = [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id, aws_subnet.subnet[2].id]
}

resource "aws_redshift_cluster" "pocnrt_rc" {
  cluster_identifier                   = "tf-redshift-cluster"
  database_name                        = local.rds_dbname
  master_username                      = local.rds_username
  master_password                      = local.rds_password
  node_type                            = "dc2.large"
  cluster_type                         = "single-node"
  skip_final_snapshot                  = true
  cluster_subnet_group_name            = aws_redshift_subnet_group.pocnrt_sg.name
  vpc_security_group_ids               = [aws_security_group.sc_poc_nrt.id]
  availability_zone                    = var.location[0]
  publicly_accessible                  = true
}