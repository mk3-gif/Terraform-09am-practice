# 1️⃣ Create S3 bucket (optional if already exists)
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-bucket-ganesha-12345"  # must be globally unique
  acl    = "private"
}

# 2️⃣ Upload Lambda code to S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip" #object name
  source = "lambda_function.zip"  # local ZIP file path in current directory
  etag   = filemd5("lambda_function.zip")  # ensures updates are detected
}

# 3️⃣ IAM Role for Lambda
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

# 4️⃣ Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 5️⃣ Create Lambda function using S3 object
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128

  s3_bucket        = aws_s3_bucket.lambda_bucket.id # bucket name "my-lambda-bucket-12345"
  s3_key           = aws_s3_object.lambda_zip.key # use .key, not .id , object name inside the bucket (the ZIP file)
  source_code_hash = aws_s3_object.lambda_zip.etag  # triggers update on ZIP change
}
