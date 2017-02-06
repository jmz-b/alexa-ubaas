variable "name" {
	type = "string"
	default = "alexa-ubaas"
}

resource "aws_iam_role" "handler_role" {
	name = "${var.name}-handler"
	assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": [
				"sts:AssumeRole"
			],
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

data "archive_file" "handler_zip" {
	type = "zip"
	source_dir  = "${path.module}/src"
	output_path = "${path.module}/handler.zip"
}

resource "aws_lambda_function" "handler" {
	function_name = "${var.name}-handler"
	runtime = "nodejs4.3"
	handler = "index.handler"
	timeout = 60
	filename = "${path.module}/handler.zip"
	role = "${aws_iam_role.handler_role.arn}"
	source_code_hash = "${data.archive_file.handler_zip.output_base64sha256}"
}
