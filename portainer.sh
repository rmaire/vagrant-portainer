#!/bin/bash

apt-get update
apt-get -y upgrade

#sudo ufw allow from any to any port 80 proto tcp
#sudo ufw allow from any to any port 443 proto tcp
#sudo ufw allow from any to any port 22 proto tcp
#sudo ufw deny from any to any port 5432 proto tcp
#sudo ufw deny from any to any port 7990 proto tcp
#sudo ufw deny from any to any port 7992 proto tcp
#sudo ufw deny from any to any port 7993 proto tcp
#sudo ufw enable

#adduser administrator
#usermod -aG sudo administrator
#ssh-copy-id -i ~/.ssh/id_zuara administrator@zuara.io
#apt install sudo
#visudo

#"
#%sudo   ALL=(ALL:ALL) NOPASSWD: ALL
#"

docker volume create portainer_data
#docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
docker run -d -p 127.0.0.1:9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer -H unix:///var/run/docker.sock
