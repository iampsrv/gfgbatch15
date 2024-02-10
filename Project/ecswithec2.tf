resource "aws_ecs_cluster" "cluster" {
  name = "ecs-ec2-cluster"
  tags = {
   name = "ecswithec2"
   }
  }

resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0bf5ac026c9b5eb88"
  subnet_id              = aws_subnet.subnet1.id
  instance_type          = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile   = "ecsInstanceRole"
  vpc_security_group_ids      = [aws_security_group.ecs_security_group.id]
  key_name                    = "batch12kp"
  user_data                   = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y ecs-init
              sudo service docker start
              sudo start ecs
              echo ECS_CLUSTER=ecs-ec2-cluster >> /etc/ecs/ecs.config
              cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"
              EOF

  tags = {
    Name                   = "ecs-ec2_instance"
}
}

resource "aws_instance" "ec2_instance1" {
  ami                    = "ami-0bf5ac026c9b5eb88"
  subnet_id              = aws_subnet.subnet2.id
  instance_type          = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile   = "ecsInstanceRole"
  vpc_security_group_ids      = [aws_security_group.ecs_security_group.id]
  key_name                    = "batch12kp"
  user_data                   = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y ecs-init
              sudo service docker start
              sudo start ecs
              echo ECS_CLUSTER=ecs-ec2-cluster >> /etc/ecs/ecs.config
              cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"
              EOF

  tags = {
    Name                   = "ecs-ec2_instance-new"
}
}

resource "aws_instance" "ec2_instance2" {
  ami                    = "ami-0bf5ac026c9b5eb88"
  subnet_id              = aws_subnet.subnet2.id
  instance_type          = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile   = "ecsInstanceRole"
  vpc_security_group_ids      = [aws_security_group.ecs_security_group.id]
  key_name                    = "batch12kp"
  user_data                   = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y ecs-init
              sudo service docker start
              sudo start ecs
              echo ECS_CLUSTER=ecs-ec2-cluster >> /etc/ecs/ecs.config
              cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"
              EOF

  tags = {
    Name                   = "ecs-ec2_instance-newnew"
}
}

resource "aws_ecs_service" "service" {
  cluster                = "${aws_ecs_cluster.cluster.id}"                             
  desired_count          = 1                                                        
  launch_type            = "EC2"                                                  
  name                   = "mysvcec2"                                        
  task_definition        = "${aws_ecs_task_definition.flaskapp_task_defec2.arn}"      
}



########################################
# resource "aws_lb" "ecs_lb" {
#   name               = "ecs-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.ecs_security_group.id]
#   subnets = [
#     aws_subnet.subnet1.id,
#     aws_subnet.subnet2.id
#   ]
#   }

# resource "aws_lb_listener" "ecs_lb_listener" {
#   load_balancer_arn = aws_lb.ecs_lb.arn
#   port              = 8080
#   protocol          = "HTTP"

#   default_action {
#     target_group_arn = aws_lb_target_group.ecs_target_group.arn
#     type             = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Hello from ECS!"
#       status_code  = "200"
#     }
#   }
# }

# resource "aws_lb_target_group" "ecs_target_group" {
#   name     = "ecs-target-group"
#   port     = 8080
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.my_vpc.id
# }

# # resource "aws_ecs_service" "service" {
# #   name            = "mysvcec2"
# #   cluster         = aws_ecs_cluster.cluster.id
# #   launch_type     = "EC2"
# #   task_definition = aws_ecs_task_definition.flaskapp_task_defec2.arn
# #   desired_count   = 1
# #   load_balancer {
# #     container_name       = "myflaskcontainer"                                  #"container_${var.component}_${var.environment}"
# #     container_port       = "8080"
# #     target_group_arn     = "${aws_lb_target_group.ecs_target_group.arn}"         # attaching load_balancer target group to ecs
# #  }
# #   network_configuration {
# #     subnets = [aws_subnet.subnet1.id]
# #   }
# #   depends_on = [aws_lb_target_group.ecs_target_group] 
# # }
