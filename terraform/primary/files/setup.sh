#!/bin/bash

apt-get update
apt-get -y upgrade

locale-gen de_CH.utf8
update-locale LANG=de_CH.UTF-8 LC_MESSAGES=POSIX
timedatectl set-timezone Europe/Zurich

apt-get -y install apt-transport-https ca-certificates curl gnupg-agent resolvconf snapd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get  --no-install-recommends -y install docker-ce docker-ce-cli containerd.io
usermod -a -G docker administrator
usermod -a -G docker vagrant

systemctl restart docker
