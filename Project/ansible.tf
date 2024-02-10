resource "aws_instance" "ansible" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = "batch12kp"
  vpc_security_group_ids      = [aws_security_group.ecs_security_group.id]
  subnet_id       = aws_subnet.subnet1.id
  associate_public_ip_address = true
  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("batch12kp.pem")
      host        = aws_instance.ansible.public_ip
    }
    source      = "node_exp.yml"
    destination = "/home/ubuntu/node_exp.yml"
  }
  user_data                   = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt-get update
              sudo apt-get -y upgrade
              sudo apt install software-properties-common
              sudo apt-add-repository -y ppa:ansible/ansible
              sudo apt update
              sudo apt install ansible -y
              EOF

  tags = {
    Name = "ansible-master-tf"
  }
}
