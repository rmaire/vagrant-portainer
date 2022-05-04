#!/bin/bash

# https://jonathangazeley.com/2020/09/16/exposing-the-kubernetes-dashboard-with-an-ingress/
# https://grafana.com/grafana/dashboards/315

microk8s.enable dns ingress
microk8s.enable dashboard openebs
microk8s.enable storage
microk8s.enable helm3 host-access multus prometheus
microk8s.enable registry

token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token

kubectl apply -f /vagrant/terraform/dashboard.yaml
kubectl get ingress -n kube-system



microk8s kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=interface=enp0s8
curl -o /usr/local/bin/calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.20.0/calicoctl" 
chmod +x /usr/local/bin/calicoctl

microk8s kubectl create namespace argocd
microk8s kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

cat > /etc/docker/daemon.json <<INSECREG
{
    "insecure-registries" : ["localhost:32000"] 
}
INSECREG
systemctl restart docker

File "/etc/docker/daemon.json" does not exist. 
You should create it and add the following lines: 
{
    "insecure-registries" : ["localhost:32000"] 
}
and then restart docker with: sudo systemctl restart docker


cat > /etc/docker/daemon.json <<INSECREG
{
    "insecure-registries" : ["10.3.5.20:32000"] 
}
INSECREG
systemctl restart docker


kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'


eyJhbGciOiJSUzI1NiIsImtpZCI6IkVHQ2JSUWw3dXg0NTUxTFE1UHpEOEtVOXlVaWpNNXFlcVBvTHBuWmlKQ2sifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkZWZhdWx0LXRva2VuLXZ4cmh0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImRlZmF1bHQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJmYWU0ZDdjMC04MDZjLTQxYzAtOTMzNy02YzM2ODZiYjJjMTAiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06ZGVmYXVsdCJ9.pnMIO7BcfW-pS_WcwEBc2ygYz73TVfJ9F1SgM_nxDGr_T6qDBfJnn7YKoxciWvEvNvP6TbgicT50_LJtFuLz9kL_RUKTq5TpPO6M9k37A27lwwtbhngv6ucTM1pDMwsLEYWnR2qKkn-5YTEl4xVFpquVEIFmMkmK6Zr1qBMfvhaWVN-yJkvlHfGm9q4yPP85ts0leB4k-_ri-DcH24r2JheaP40NW_iLwUpPovdiG5224-NOlt7Woq5Az8POiJ7zoeRwuKD92sWmi-VJtTi8wf0xIXZ_2MWcMefSN-q_fDvqNDwiVakOOvsY7Jxu-xiw5kkS-bgYg_LHe3HeNgA2aQ