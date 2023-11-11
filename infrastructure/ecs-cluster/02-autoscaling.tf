resource "aws_iam_role" "this" {
  name = "${local.resource_tag_prefix}-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "service_policy_attachment" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.resource_tag_prefix}-ecs-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_launch_configuration" "this" {
  name_prefix          = "${local.resource_tag_prefix}-ecs-launch-config"
  image_id             = local.ami_id
  instance_type        = local.instance_type
  iam_instance_profile = aws_iam_instance_profile.this.name
  security_groups      = [aws_security_group.ecs_task.id]
  user_data            = <<-EOF
    #!/bin/bash
    echo 'ECS_CLUSTER=${local.cluster_name}' >> /etc/ecs/ecs.config
    yum update -y
    yum install -y aws-cli
    EOF
}

resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier = aws_subnet.private.*.id
  min_size            = local.asg_min_size
  desired_capacity    = local.asg_desired_size
  max_size            = local.asg_max_size
  health_check_grace_period = 300
  health_check_type         = "EC2"
}