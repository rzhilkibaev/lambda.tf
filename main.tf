variable "function_name" {}

variable "filename" { default = "main.zip" }
variable "handler" { default = "main.handler" }
variable "runtime" { default = "python2.7" }
variable "timeout" { default = "3" }
variable "memory_size" { default = "128" }

resource "aws_lambda_function" "main" {
  function_name = "${var.function_name}"

  handler = "${var.handler}"
  filename = "${var.filename}"
  source_code_hash = "${base64sha256(file("${var.filename}"))}"
  runtime = "${var.runtime}"
  timeout = "${var.timeout}"
  memory_size = "${var.memory_size}"
  role = "${aws_iam_role.main.arn}"
  publish = true
}

resource "aws_iam_role" "main" {
  name = "${var.function_name}_lambda"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

output "lambda_arn" { value = "${aws_lambda_function.main.arn}" }
output "lambda_qualified_arn" { value = "${aws_lambda_function.main.qualified_arn}" }
output "lambda_version" { value = "${aws_lambda_function.main.version}" }
output "role_arn" { value = "${aws_iam_role.main.arn}" }
