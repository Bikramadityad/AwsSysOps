#!/bin/bash
echo "Copying the SSH Key Of ansible-ubuntu to all instances"
cd /home/ubuntu/.ssh/
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9AUZ1b22eJyxgdA653VlFx2i9Hz0YkFp7I6zEt9EOszt6TuqLjGkUquM1fJ3DYeAo+bF3UrhO18/NyTWMADmne4YAIhsrvPa2Oa1JrHOGW0bLJHV6zHKg2x9cyivP+IishkMfY5LO8Nwe3QVtpkYkJ2P/rSqq8Jb/vK0wyvqZvr+sTgKah+zB4HCJqrNSvYVBeYASwtM/AIX+yx4pFluhK8xJ3r1Z6TNEJENkdR5r4oCgzX0dLQyLCQudWK/f5Vwa9WKsV3n6vb91ChffAH7OWbjdUk8gT6bbP957tVQbQAH2uRMP9nfDYjKrzPhsPsm344iFmU0UKScYZrvBNnMv ubuntu@ip-10-1-1-213" > authorized_keys
cd /home/ubuntu/
sudo apt-get update
sudo apt-get install unzip tree
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo apt-get install -y python