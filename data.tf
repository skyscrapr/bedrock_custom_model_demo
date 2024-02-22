resource "aws_s3_object" "training" {
  bucket = aws_s3_bucket.training.id
  key    = "data/training.jsonl"
  source = "data/training.jsonl"
}

resource "aws_s3_object" "validation" {
  bucket = aws_s3_bucket.validation.id
  key    = "data/validate.jsonl"
  source = "data/validate.jsonl"
}