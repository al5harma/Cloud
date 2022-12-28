resource "aws_s3_bucket" "uswest_bucket" {
  provider = aws.uswest
  bucket   = "alessandromarinoac-uswest-bucket"
  acl      = "private"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "euwest_bucket" {
  bucket = "alessandromarinoac-euwest-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.s3_fullaccess_role.arn
    rules {
      id     = "testReplication"
      status = "Enabled"
      destination {
        bucket        = aws_s3_bucket.uswest_bucket.arn
        storage_class = "STANDARD"
      }
    }
  }
}

resource "aws_iam_role" "s3_fullaccess_role" {
  name               = "s3-fullaccess-role"
  assume_role_policy = data.aws_iam_policy_document.s3_fullaccess_role_assume_policy.json
}

resource "aws_iam_role_policy" "s3_fullaccess_policy" {
  name   = "s3_fullaccess_policy"
  role   = aws_iam_role.s3_fullaccess_role.id
  policy = data.aws_iam_policy_document.s3_fullaccess_role_policy.json
}

data "aws_iam_policy_document" "s3_fullaccess_role_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "s3_fullaccess_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::alessandromarinoac-euwest-bucket",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "arn:aws:s3:::alessandromarinoac-euwest-bucket/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = [
      "${aws_s3_bucket.uswest_bucket.arn}/*"
    ]
  }
}