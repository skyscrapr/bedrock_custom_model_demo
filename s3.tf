resource "aws_s3_bucket" "training" {
  bucket = "tf-bedrock-custom-model-training-data"
}

resource "aws_s3_bucket" "validation" {
  bucket = "tf-bedrock-custom-model-validation-data"
}

resource "aws_s3_bucket" "output" {
  bucket = "tf-bedrock-custom-model-output-data"
}
