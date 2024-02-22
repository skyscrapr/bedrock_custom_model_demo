data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

resource "random_id" "custom_model" {
  # keepers = {
    # Generate a new id each time we switch to a new AMI id
  #   ami_id = var.ami_id
  # }

  byte_length = 8
}

data "aws_bedrock_foundation_model" "foundation_model" {
  model_id = "amazon.titan-text-express-v1"
}

resource "aws_bedrock_custom_model" "custom_model" {
  custom_model_name     = "tf_test_custom_model"
  job_name              = "tf-test-${random_id.custom_model.id}"
  base_model_identifier = data.aws_bedrock_foundation_model.foundation_model.model_arn
  role_arn              = aws_iam_role.bedrock.arn

  hyperparameters = {
    "epochCount"              = "1"
    "batchSize"               = "1"
    "learningRate"            = "0.005"
    "learningRateWarmupSteps" = "0"
  }

  output_data_config {
    s3_uri = "s3://${aws_s3_bucket.output.id}/data/"
  }

  training_data_config {
    s3_uri = "s3://${aws_s3_bucket.training.id}/data/training.jsonl"
  }
}

#resource "time_sleep" "subnets" {
#  create_duration = "5000s"
#
#  depends_on = [aws_bedrock_custom_model.custom_model.job_status = "Completed"]
#}