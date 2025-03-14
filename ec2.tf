# Terraform configuration for AWS EC2 instance to deploy Node.js web app

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "node_sg" {
  name        = "node-app-sg"
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
  ami           = "ami-08b5b3a93ed654d19" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "Bincom"

  vpc_security_group_ids = [aws_security_group.node_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nodejs npm git
              git clone https://github.com/deadmedusa/nodejsCICD.git /home/ubuntu/nodejsCICD
              cd /home/ubuntu/nodejsCICD
              npm install

              # Create a systemd service for the Node.js app
              echo "[Unit]
              Description=Node.js App
              After=network.target

              [Service]
              ExecStart=/usr/bin/node /home/ubuntu/nodejsCICD/app.js
              WorkingDirectory=/home/ubuntu/nodejsCICD
              User=ubuntu
              Restart=always

              [Install]
              WantedBy=multi-user.target" | sudo tee /etc/systemd/system/node-app.service

              # Enable and start the service
              sudo systemctl daemon-reload
              sudo systemctl enable node-app
              sudo systemctl start node-app
              EOF

  tags = {
    Name = "node.js"
  }
}

# Output the public IP of the EC2 instance
output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.node_app.public_ip
}
