locals {
  # get json 
  creds = jsondecode(file("credentials.json"))

  # get all users
  rds_username = local.creds.rds_username
  rds_password = local.creds.rds_password
  rds_dbname   = local.creds.rds_dbname
}