data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role-test-web"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs-instance-role.name
}

resource "aws_iam_instance_profile" "ecs_service_role" {
  role = aws_iam_role.ecs-instance-role.name
}