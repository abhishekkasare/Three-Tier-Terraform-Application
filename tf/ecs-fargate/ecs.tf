#LoadBalancer-SG
resource "aws_security_group" "lb" {
  name        = "alb-sg-hitika"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Loadbalancer and Target group
resource "aws_lb" "default" {
  name            = "tf-alb-hitika"
  subnets         = [data.terraform_remote_state.vpc.outputs.subnet01_id, data.terraform_remote_state.vpc.outputs.subnet02_id]
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "target_group" {
  name        = "tf-target-group-hitika"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}

#TaskDefinition
resource "aws_ecs_task_definition" "task_def" {
  family                   = "hadiya-project"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<DEFINITION
[
  {
    "image": "nginx:latest",               
    "cpu": 512,
    "memory": 1024,
    "name": "hadiya",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

#SG for ECS service
resource "aws_security_group" "sg_service" {
  name        = "hadiya-svc-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ECS Cluster and service
resource "aws_ecs_cluster" "main" {
  name = "tf-cluster-hitika"
}

resource "aws_ecs_service" "svc" {
  name            = "hadiya-backend-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.sg_service.id]
    subnets         = [data.terraform_remote_state.vpc.outputs.subnet03_id, data.terraform_remote_state.vpc.outputs.subnet04_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.id
    container_name   = "hadiya"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.lb_listener]
}
