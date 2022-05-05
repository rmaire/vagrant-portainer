#!/bin/bash

cp /vagrant/keys/insecure_private_key ~/.ssh/
chmod 700 ~/.ssh/insecure_private_key

hashi-up consul install \
  --local \
  --skip-enable \
  --skip-start \
  --client-addr 0.0.0.0

sleep 5

hashi-up nomad install \
  --local \
  --skip-enable \
  --skip-start

sleep 5

export NOMAD_KEY=$(nomad operator keygen)
echo $NOMAD_KEY > nomad-gossip.key
export CONSUL_KEY=$(consul keygen)
echo $CONSUL_KEY > consul-gossip.key
export CONSUL_KEY=$(cat consul-gossip.key)
export NOMAD_KEY=$(cat nomad-gossip.key)

export TOOL_IP=10.3.5.80
export SERVER_1_IP=10.3.5.20
export SERVER_2_IP=10.3.5.30
export SERVER_3_IP=10.3.5.40
export AGENT_1_IP=10.3.5.50
export AGENT_2_IP=10.3.5.60

consul tls ca create
consul tls cert create -server -dc dc1 -additional-dnsname=first.mycloud.local -additional-ipaddress=10.3.5.20 -additional-dnsname=second.mycloud.local -additional-ipaddress=10.3.5.30 -additional-dnsname=third.mycloud.local -additional-ipaddress=10.3.5.40
consul tls cert create -client -dc dc1 -additional-dnsname=fouth.mycloud.local -additional-ipaddress=10.3.5.50 -additional-dnsname=fifth.mycloud.local -additional-ipaddress=10.3.5.60

consul tls ca create -domain=nomad
consul tls cert create -server -domain=nomad -dc=dc1 -additional-ipaddress=127.0.0.1 -additional-dnsname=first.mycloud.local -additional-ipaddress=10.3.5.20 -additional-dnsname=second.mycloud.local -additional-ipaddress=10.3.5.30 -additional-dnsname=third.mycloud.local -additional-ipaddress=10.3.5.40
consul tls cert create -client  -domain=nomad -dc=dc1 -additional-ipaddress=127.0.0.1 -additional-dnsname=fouth.mycloud.local -additional-ipaddress=10.3.5.50 -additional-dnsname=fifth.mycloud.local -additional-ipaddress=10.3.5.60

consul tls ca create -domain=vault
consul tls cert create -server -domain=vault -dc=dc1 -additional-ipaddress=127.0.0.1 -additional-dnsname=first.mycloud.local -additional-ipaddress=10.3.5.20 -additional-dnsname=second.mycloud.local -additional-ipaddress=10.3.5.30 -additional-dnsname=third.mycloud.local -additional-ipaddress=10.3.5.40

sleep 5

hashi-up consul install \
  --ssh-target-addr $SERVER_1_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --server \
  --connect \
  --encrypt $CONSUL_KEY \
  --ca-file consul-agent-ca.pem \
  --cert-file dc1-server-consul-0.pem \
  --key-file dc1-server-consul-0-key.pem \
  --client-addr $SERVER_1_IP \
  --bind-addr 0.0.0.0 \
  --advertise-addr $SERVER_1_IP \
  --https-addr $SERVER_1_IP \
  --http-addr 127.0.0.1 \
  --https-only=false \
  --bootstrap-expect 3 \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.10.2

sleep 10

hashi-up consul install \
  --ssh-target-addr $SERVER_2_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --server \
  --connect \
  --encrypt $CONSUL_KEY \
  --ca-file consul-agent-ca.pem \
  --cert-file dc1-server-consul-0.pem \
  --key-file dc1-server-consul-0-key.pem \
  --client-addr $SERVER_2_IP \
  --bind-addr 0.0.0.0 \
  --advertise-addr $SERVER_2_IP \
  --https-addr $SERVER_2_IP \
  --http-addr 127.0.0.1 \
  --https-only=false \
  --bootstrap-expect 3 \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.10.2

sleep 10

hashi-up consul install \
  --ssh-target-addr $SERVER_3_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --server \
  --connect \
  --encrypt $CONSUL_KEY \
  --ca-file consul-agent-ca.pem \
  --cert-file dc1-server-consul-0.pem \
  --key-file dc1-server-consul-0-key.pem \
  --client-addr $SERVER_3_IP \
  --bind-addr 0.0.0.0 \
  --advertise-addr $SERVER_3_IP \
  --https-addr $SERVER_3_IP \
  --http-addr 127.0.0.1 \
  --https-only=false \
  --bootstrap-expect 3 \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.10.2

sleep 10

hashi-up consul install \
  --ssh-target-addr $AGENT_1_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --connect \
  --encrypt $CONSUL_KEY \
  --ca-file consul-agent-ca.pem \
  --cert-file dc1-client-consul-0.pem \
  --key-file dc1-client-consul-0-key.pem \
  --bind-addr 0.0.0.0 \
  --advertise-addr $AGENT_1_IP \
  --https-addr $AGENT_1_IP \
  --http-addr 127.0.0.1 \
  --https-only=false \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.10.2

sleep 10

hashi-up consul install \
  --ssh-target-addr $AGENT_2_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --connect \
  --encrypt $CONSUL_KEY \
  --ca-file consul-agent-ca.pem \
  --cert-file dc1-client-consul-0.pem \
  --key-file dc1-client-consul-0-key.pem \
  --bind-addr 0.0.0.0 \
  --advertise-addr $AGENT_2_IP \
  --https-addr $AGENT_2_IP \
  --http-addr 127.0.0.1 \
  --https-only=false \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.10.2

sleep 10

hashi-up nomad install \
  --ssh-target-addr $SERVER_1_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --server \
  --address $SERVER_1_IP \
  --advertise $SERVER_1_IP \
  --encrypt $NOMAD_KEY \
  --ca-file nomad-agent-ca.pem \
  --cert-file dc1-server-nomad-0.pem \
  --key-file dc1-server-nomad-0-key.pem \
  --bootstrap-expect 3 \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.1.4

sleep 10
  
hashi-up nomad install \
  --ssh-target-addr $SERVER_2_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --server \
  --bootstrap-expect 3 \
  --address $SERVER_2_IP \
  --advertise $SERVER_2_IP \
  --encrypt $NOMAD_KEY \
  --ca-file nomad-agent-ca.pem \
  --cert-file dc1-server-nomad-0.pem \
  --key-file dc1-server-nomad-0-key.pem \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.1.4

sleep 10
  
hashi-up nomad install \
  --ssh-target-addr $SERVER_3_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --server \
  --bootstrap-expect 3 \
  --address $SERVER_3_IP \
  --advertise $SERVER_3_IP \
  --encrypt $NOMAD_KEY \
  --ca-file nomad-agent-ca.pem \
  --cert-file dc1-server-nomad-0.pem \
  --key-file dc1-server-nomad-0-key.pem \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.1.4

sleep 10

hashi-up nomad install \
  --ssh-target-addr $AGENT_1_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --client \
  --encrypt $NOMAD_KEY \
  --ca-file nomad-agent-ca.pem \
  --cert-file dc1-server-nomad-0.pem \
  --key-file dc1-server-nomad-0-key.pem \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.1.4

sleep 10
  
hashi-up nomad install \
  --ssh-target-addr $AGENT_2_IP \
  --ssh-target-user vagrant \
  --ssh-target-key ~/.ssh/insecure_private_key \
  --client \
  --encrypt $NOMAD_KEY \
  --ca-file nomad-agent-ca.pem \
  --cert-file dc1-server-nomad-0.pem \
  --key-file dc1-server-nomad-0-key.pem \
  --retry-join $SERVER_1_IP --retry-join $SERVER_2_IP --retry-join $SERVER_3_IP \
  -- version 1.1.4

sleep 10

hashi-up vault install \
    --ssh-target-addr $SERVER_1_IP \
    --ssh-target-user vagrant \
    --ssh-target-key ~/.ssh/insecure_private_key \
    --cert-file dc1-server-vault-0.pem \
    --key-file dc1-server-vault-0-key.pem \
    --storage consul \
    --api-addr http://$SERVER_1_IP:8200 \
    -- version 1.8.2

sleep 10

hashi-up vault install \
    --ssh-target-addr $SERVER_2_IP \
    --ssh-target-user vagrant \
    --ssh-target-key ~/.ssh/insecure_private_key \
    --cert-file dc1-server-vault-0.pem \
    --key-file dc1-server-vault-0-key.pem \
    --storage consul \
    --api-addr http://$SERVER_2_IP:8200 \
    -- version 1.8.2