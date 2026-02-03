provider "aws" {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket         = "avi-pune-sre-tf-state" # जे नाव तू मघाशी दिलं होतंस तेच ठेव
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "avi-tf-state-locks"
    encrypt        = true
  }
}

# १. S3 Bucket - स्टेट फाईल सुरक्षित ठेवण्यासाठी
resource "aws_s3_bucket" "terraform_state" {
  bucket = "avi-pune-sre-tf-state" # हे नाव युनिक ठेव (उदा. तुझे-नाव-tf-state)

  lifecycle {
    prevent_destroy = true
  }
}

# २. Bucket Versioning - जुन्या फाईल्सचा बॅकअप राहण्यासाठी
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ३. DynamoDB Table - 'Locking' साठी (सर्वात महत्त्वाचे)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "avi-tf-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
