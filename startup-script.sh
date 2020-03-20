#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential


sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xd68fa50fea312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt-get update
sudo apt install -y --allow-unauthenticated mongodb-org

sudo systemctl start mongod

sudo systemctl enable mongod

cd ~ 
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
