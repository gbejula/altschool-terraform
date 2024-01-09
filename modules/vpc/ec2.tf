resource "aws_instance" "instance" {
  ami = var.ami
  instance_type = var.type
  key_name = var.key_pair
  security_groups = [aws_security_group.sec-group.id]
  subnet_id = aws_subnet.subnet-az1.id
  availability_zone = data.aws_availability_zones.available_zones.names[0]

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install docker.io -y
                sudo systemctl start docker
                sudo systemctl enable docker
                docker pull ansible/ansible:latest
                docker run -it --name ansible_docker -v ~/terraform:/ansible/
                playbooks ansible/ansible:latest
                EOF

    tags = {
        Name = "${var.env-prefix}-instance"
        source = "terraform"
    }    

}