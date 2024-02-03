# resource "aws_vpc" "myvpc" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"
#   tags = {
#     Name = "myvpc"
#   }
# }



# resource "aws_internet_gateway" "myigw" {
#   vpc_id = aws_vpc.myvpc.id

#   tags = {
#     Name = "myigw"
#   }
# }

# resource "aws_subnet" "myps" {
#   vpc_id                  = aws_vpc.myvpc.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1a"
#   tags = {
#     Name = "mypublicsubnet"
#   }
# }

# resource "aws_route_table" "myrt" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myigw.id
#   }

#   tags = {
#     Name = "myroutetable"
#   }
# }

# resource "aws_route_table_association" "myrta" {
#   subnet_id      = aws_subnet.myps.id
#   route_table_id = aws_route_table.myrt.id
# }

