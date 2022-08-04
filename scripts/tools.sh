#!/bin/bash

apt-get update
apt-get -y upgrade
apt remove -y ansible
apt --purge -y autoremove
apt-get -y install software-properties-common apt-transport-https ca-certificates curl gnupg-agent resolvconf snapd python3 pip python-is-python3
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible
# apt install -y --no-install-recommends python3-netaddr
pip3 install netaddr
