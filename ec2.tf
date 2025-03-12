# Terraform configuration for AWS EC2 instance to deploy Node.js web app

provider "aws" {
  region = "us-east-1" # Update as needed
}

resource "aws_instance" "node_app" {
  ami           = "ami-08b5b3a93ed654d19"
  instance_type = "t2.micro" # Choose as per requirements

  key_name = "Bincom"

  security_groups = [aws_security_group.node_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nodejs npm
              git clone https://github.com/deadmedusa/nodejsCICD.git
              cd nodejsCICD
              npm install
              node app.js &
              EOF

  tags = {
    Name = "node.js"
  }
}

resource "aws_security_group" "node_sg" {
  name        = "node-app-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.node_app.public_ip
}
