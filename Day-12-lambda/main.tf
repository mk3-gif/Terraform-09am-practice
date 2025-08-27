
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          =  aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900 # 15 minutes
  memory_size   = 128

  filename         = "lambda_function.zip"  # Ensure this file exists
  source_code_hash = filebase64sha256("lambda_function.zip")


  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.
#This ensures Terraform redeploys the Lambda whenever the code changes.
#This hash is a checksum that triggers a deployment.
}

# 1️⃣ IAM Role
# resource "aws_iam_role" "lambda_role" {
#   name = "lambda_execution_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#     }]
#   })
# }


# Creates an IAM role that Lambda can assume.

# The assume_role_policy allows Lambda service to execute using this role.

# 2️⃣ IAM Role Policy Attachment
# resource "aws_iam_role_policy_attachment" "lambda_policy" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }


# Attaches the basic Lambda execution policy.

# This policy allows Lambda to write logs to CloudWatch.

# 3️⃣ Lambda Function
# resource "aws_lambda_function" "my_lambda" {
#   function_name = "my_lambda_function"
#   role          = aws_iam_role.lambda_role.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = "python3.12"
#   timeout       = 900
#   memory_size   = 128

#   filename = "lambda_function.zip"  
#   # source_code_hash = filebase64sha256("lambda_function.zip")
# }


# handler: "lambda_function.lambda_handler" means your ZIP should have a lambda_function.py file with a function lambda_handler.

# runtime: Python 3.12.

# timeout & memory_size: You set custom values.

# filename: Terraform uploads this ZIP to Lambda.

# ✅ Important note:

# Without source_code_hash, Terraform won’t detect changes if you update the ZIP.

# Best practice:

# source_code_hash = filebase64sha256("lambda_function.zip")


# This ensures Terraform redeploys the Lambda whenever the code changes.