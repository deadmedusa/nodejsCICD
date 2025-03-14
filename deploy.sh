#!/bin/bash

# Stop any existing node server if running
sudo systemctl stop node-server || true

# Remove previous build if it exists
rm -rf /home/ubuntu/nodejs-app || true

# Clone the latest code from GitHub
cd /home/ubuntu
git clone https://github.com/deadmedusa/nodejsCICD.git nodejs-app

# Navigate to app directory
cd /home/ubuntu/nodejs-app

# Install dependencies
npm install

# Create systemd service if it doesn't exist
echo "[Unit]
Description=Node.js Server
After=network.target

[Service]
ExecStart=/usr/bin/node /home/ubuntu/nodejs-app/app.js
Restart=always
User=ubuntu
Environment=PORT=3000
WorkingDirectory=/home/ubuntu/nodejs-app

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/node-server.service

# Reload systemd and start the service
sudo systemctl daemon-reexec
sudo systemctl enable node-server
sudo systemctl start node-server
