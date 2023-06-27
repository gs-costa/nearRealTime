# resource "aws_s3_bucket" "gustavoaero_datasource" {
#   bucket = "gustavoaero-datasource"
# }

# resource "aws_s3_object" "hadoop_jar" {
#   bucket = aws_s3_bucket.gustavoaero_datasource.id
#   key    = "flink_jar/flink-s3-fs-hadoop-1.13.0.jar"
#   source = "flink-s3-fs-hadoop-1.13.0.jar"
# }
# resource "aws_s3_object" "bundle_jar" {
#   bucket = aws_s3_bucket.gustavoaero_datasource.id
#   key    = "flink_jar/hudi-flink-bundle_2.12-0.10.1.jar"
#   source = "hudi-flink-bundle_2.12-0.10.1.jar"
# }

# resource "aws_kinesisanalyticsv2_application" "nrtstudio" {
#   name                   = "pocnrt_studio"
#   runtime_environment    = "FLINK-1_13"
#   service_execution_role = aws_iam_role.poc_nrt_role.arn

#   application_configuration {
#     application_code_configuration {
#       code_content {
#         s3_content_location {
#           bucket_arn = aws_s3_bucket.gustavoaero_datasource.arn
#           file_key   = aws_s3_object.hadoop_jar.key
#         }
#       }

#       code_content_type = "ZIPFILE"
#     }


#     flink_application_configuration {
#       checkpoint_configuration {
#         configuration_type = "DEFAULT"
#       }

#       monitoring_configuration {
#         configuration_type = "CUSTOM"
#         log_level          = "DEBUG"
#         metrics_level      = "TASK"
#       }

#       parallelism_configuration {
#         auto_scaling_enabled = true
#         configuration_type   = "CUSTOM"
#         parallelism          = 4
#         parallelism_per_kpu  = 1
#       }
#     }
#   }
# }