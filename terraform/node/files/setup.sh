#!/bin/bash

apt-get update
apt-get -y upgrade
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent resolvconf snapd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get  --no-install-recommends -y install docker-ce docker-ce-cli containerd.io
usermod -a -G docker administrator

cat > /etc/docker/daemon.json <<INSECREG
{
    "insecure-registries" : ["${primary_ip}:32000"] 
}
INSECREG
systemctl restart docker

snap install microk8s --classic --channel=1.21
microk8s.status --wait-ready
usermod -a -G microk8s administrator

echo "alias kubectl='microk8s.kubectl'" > /home/administrator/.bash_aliases
chown administrator:administrator /home/administrator/.bash_aliases
echo "alias kubectl='microk8s.kubectl'" > /root/.bash_aliases
chown root:root /root/.bash_aliases
systemctl enable iscsid

#timeout 300 bash -c 'while [[ "$$(curl -s -o /dev/null -w ''%%{http_code}'' ${primary_ip}:25000/${hash_node})" != "200" ]]; do sleep 5; done' || false

echo "Primary: ${primary_ip}, Hash: ${hash_node}"

sudo microk8s join --skip-verify ${primary_ip}:25000/${hash_node}