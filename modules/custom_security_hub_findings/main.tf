resource "aws_cloudwatch_event_rule" "import_findings" {
  name = "Import-Security-Hub-findings"
  event_pattern = jsonencode({
    "detail-type" : ["AWS API Call via CloudTrail"],
    "source" : ["aws.iam"],
    "detail" : {
      "eventSource" : ["iam.amazonaws.com"],
      "eventName" : ["CreateUser"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.import_findings.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.custom_finding_lambda_function.arn
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_dir  = "${path.module}/custom_finding_lambda/src/findings/"
  output_path = "${path.module}/lambda.zip"
}

data "aws_iam_policy_document" "lambda_iam_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "custom_finding_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_iam_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_iam_cu_report_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "securityhub:BatchImportFindings"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "custom_finding_lambda_policy"
  policy = data.aws_iam_policy_document.lambda_iam_cu_report_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_and_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "custom_finding_lambda_function" {
  filename         = data.archive_file.lambda_archive.output_path
  function_name    = "custom_security_hub_finding_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "custom_security_hub_finding.lambda_handler"
  source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  runtime          = "python3.8"
  timeout          = 30
  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  function_name = aws_lambda_function.custom_finding_lambda_function.function_name
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.import_findings.arn
}