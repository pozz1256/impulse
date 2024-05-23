# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
# RDS
#resource "aws_db_instance" "default" {
#  allocated_storage    = 20
#  engine               = "mysql"
#  instance_class       = "db.t2.micro"
##  name                 = "warpdb"
#  username             = var.db_username
#  password             = random_password.db_password.result
#  parameter_group_name = "default.mysql5.7"
#  publicly_accessible  = true
#  vpc_security_group_ids = [aws_security_group.main.id]
#  db_subnet_group_name = aws_db_subnet_group.main.name
#}

resource "random_password" "db_password" {
  length           = 32  # Set the desired length of the password
  special          = false  # Include special characters in the password
  override_special = "_@%#"  # Optionally, provide a set of special characters to use
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.public.*.id
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "warp-cluster"
}

# IAM Roles and Policies
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "ecs_task_execution_policy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = "ecs-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "512"
  cpu                      = "256"

  container_definitions = jsonencode([{
    name      = "app"
    image     = "sebo-b/warp:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    environment = [
      {
        name  = "DB_HOST"
        value = module.db.db_instance_endpoint
      },
      {
        name  = "DB_USER"
        value = var.db_username
      },
      {
        name  = "DB_PASS"
        value = random_password.db_password.result
      }
    ]
  }])
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "warp-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = aws_subnet.public.*.id
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "app"
    container_port   = 80
  }
}

# ALB
resource "aws_lb" "main" {
  name               = "warp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = aws_subnet.public.*.id
}

resource "aws_lb_target_group" "main" {
  name     = "warp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
# will need in future
#module "ecs_instance_ssh_key" {
#  source  = "terraform-iaac/key-pair/aws"
#  version = "1.0.3"
#
#  key_name           = "${var.global_prefix}-ecs-ssh-key"
#  key_storage_bucket = data.terraform_remote_state.base.outputs.s3_bucket_ssh_key_storage
#}