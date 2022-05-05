#!/bin/bash

apt-get update
apt-get -y upgrade
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent resolvconf snapd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -a -G docker administrator
usermod -a -G docker vagrant

systemctl restart docker

curl -sLS https://get.hashi-up.dev | sh
