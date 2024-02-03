# # resource "aws_instance" "web" {
# #   ami                         = var.ami
# #   instance_type               = var.instance_type
# #   security_groups             = [aws_security_group.mysg.id]
# #   subnet_id                   = aws_subnet.myps.id
# #   user_data                   = file("start.sh")
# #   associate_public_ip_address = true
# #   tags = {
# #     Name = "myflaskapp"
# #   }
# # }

# # output "instance_ip_addr" {
# #   value = aws_instance.web.public_ip
# # }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web" {
# count = 5
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"

#   tags = {
#     Name = "HelloWorld-${count.index}"
#   }
# }


# # variable "instance_name" {
# #     type=set(string)
# #     default=["myinstance1","myinstance2","myinstance3"]
# # }

# variable "instance_name" {
#     default={
#         server1={instance_type="t2.micro"}
#         server2={instance_type="t3.micro"}
#     }
# }

# # resource "aws_instance" "web1" {
# # for_each = toset(var.instance_name)
# #   ami           = data.aws_ami.ubuntu.id
# #   instance_type = "t3.micro"

# #   tags = {
# #     Name = each.key
# #   }
# # }

# resource "aws_instance" "web3" {
#     for_each = var.instance_name

#     ami           = data.aws_ami.ubuntu.id
#     instance_type = each.value.instance_type
#     tags = {
#     Name = each.key
#   }

  
# }

