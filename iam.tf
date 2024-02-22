resource "aws_iam_role" "bedrock" {
  name = "tf_bedrock_access"

  # See https://docs.aws.amazon.com/bedrock/latest/userguide/model-customization-iam-role.html#model-customization-iam-role-trust.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": "bedrock.amazonaws.com"
    },
    "Action": "sts:AssumeRole",
    "Condition": {
      "StringEquals": {
        "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
      },
      "ArnEquals": {
        "aws:SourceArn": "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:model-customization-job/*"
      }
    }
  }]
}
EOF
}

# See https://docs.aws.amazon.com/bedrock/latest/userguide/model-customization-iam-role.html#model-customization-iam-role-s3.
resource "aws_iam_policy" "training_data" {
  name = "tf_bedrock_custom_model_training_data_access"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource" : [
        "${aws_s3_bucket.training.arn}",
        "${aws_s3_bucket.training.arn}/*",
        "${aws_s3_bucket.validation.arn}",
        "${aws_s3_bucket.validation.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_policy" "output_data" {
  name = "tf_bedrock_custom_model_output_data_access"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource" : [
        "${aws_s3_bucket.output.arn}",
        "${aws_s3_bucket.output.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "training" {
  role       = aws_iam_role.bedrock.name
  policy_arn = aws_iam_policy.training_data.arn
}

resource "aws_iam_role_policy_attachment" "output" {
  role       = aws_iam_role.bedrock.name
  policy_arn = aws_iam_policy.output_data.arn
}