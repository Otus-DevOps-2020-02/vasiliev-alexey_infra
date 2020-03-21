#!/bin/bash
set -e

# wait for cloud-init to complete (it updates the /etc/apt/sources.list file)
echo "Waiting for cloud-init to complete..."
    sleep 20
 
# Install ruby
apt update
apt install -y ruby-full ruby-bundler build-essential