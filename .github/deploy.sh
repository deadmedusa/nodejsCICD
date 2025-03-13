#!/bin/bash

# Stop any existing node server
sudo systemctl stop node-server

# Remove previous build
rm -rf /home/ubuntu/nodejs-app

# Create directory for new build
mkdir -p /home/ubuntu/nodejs-app

# Copy new build files
cp -r /tmp/nodejs-app/* /home/ubuntu/nodejs-app/

# Install dependencies
cd /home/ubuntu/nodejs-app
npm install

# Start node server
sudo systemctl start node-server
