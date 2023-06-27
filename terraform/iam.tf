resource "aws_iam_role" "poc_nrt_role" {
  name               = "poc-nrt-role"
  assume_role_policy = file("./permissions/assume_role.json")
}

resource "aws_iam_policy" "policy" {
  name = "nrt_poc_policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("./permissions/policy_nrt.json")
}

resource "aws_iam_role_policy_attachment" "poc_nrt_policy" {
  role       = aws_iam_role.poc_nrt_role.name
  policy_arn = aws_iam_policy.policy.arn
}