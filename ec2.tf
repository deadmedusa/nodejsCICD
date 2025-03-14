# Terraform configuration for AWS EC2 instance to deploy Node.js web app

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "node_sg" {
  name_prefix = "node-app-sg-" # Ensures unique name to avoid duplicates
  description = "Allow HTTP and SSH"
  vpc_id      = "vpc-026554c7bfd96ae09"

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

  tags = {
    Name = "node-app-sg"
  }
}

resource "aws_instance" "node_app" {
  ami           = "ami-08b5b3a93ed654d19"
  instance_type = "t2.micro"
  key_name      = "Bincom"

  security_groups = [aws_security_group.node_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              # Update system and install necessary packages
              apt update -y
              apt install -y nodejs npm git

              # Clone the repository
              git clone https://github.com/deadmedusa/nodejsCICD.git /home/ubuntu/nodejsCICD

              # Navigate to the app directory
              cd /home/ubuntu/nodejsCICD

              # Install Node.js dependencies
              npm install

              # Start the Node.js application
              nohup node app.js > app.log 2>&1 &
              EOF

  tags = {
    Name = "node.js"
  }
}

# Output the instance's public IP address
output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.node_app.public_ip
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.node_app.public_ip
}
