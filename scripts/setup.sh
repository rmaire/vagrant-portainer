#!/bin/bash

apt-get update
apt-get -y upgrade
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent resolvconf snapd
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#DEBIAN_FRONTEND=noninteractive apt-get -y update
#DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
#usermod -a -G docker administrator
#usermod -a -G docker vagrant

#systemctl restart docker

# curl -sLS https://get.hashi-up.dev | sh

#cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
#overlay
#br_netfilter
#EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
#cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
#net.bridge.bridge-nf-call-iptables  = 1
#net.bridge.bridge-nf-call-ip6tables = 1
#net.ipv4.ip_forward                 = 1
#EOF

# Apply sysctl params without reboot
#sudo sysctl --system
