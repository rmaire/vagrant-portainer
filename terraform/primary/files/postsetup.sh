#!/bin/bash

# https://jonathangazeley.com/2020/09/16/exposing-the-kubernetes-dashboard-with-an-ingress/

microk8s.enable dns ingress
microk8s.enable dashboard openebs
microk8s.enable storage
microk8s.enable helm3 host-access multus prometheus
microk8s.enable registry

token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token

kubectl apply -f /tmp/dashboard.yaml
kubectl get ingress -n kube-system

microk8s kubectl set env daemonset/calico-node -n kube-system IP_AUTODETECTION_METHOD=interface=enp0s8
curl -o /usr/local/bin/calicoctl -O -L  "https://github.com/projectcalico/calicoctl/releases/download/v3.20.0/calicoctl" 
chmod +x /usr/local/bin/calicoctl

# microk8s kubectl create namespace argocd
# microk8s kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
# chmod +x /usr/local/bin/argocd

# kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'


# eyJhbGciOiJSUzI1NiIsImtpZCI6IlBCRGZ0N0J6NEdCRVdZcmxJcUFyUVNZZ1FrQ1ZjWGZIVE5Wa2ZKOGpGam8ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkZWZhdWx0LXRva2VuLTVjdDI4Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImRlZmF1bHQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJiNDM2MDBmZC04MDFiLTQzZjYtODkxOC04NGNiYjBkNWMwYjUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06ZGVmYXVsdCJ9.gn5gWOJ_lkn--4rvdMqTA9HAFKeYjyjJ95R74JzmgHYj9wvjSJTrv02tjNSRA8nlppf1RiZzcN08Y8rg6xB9PTCIWaq73Hkztd5B_kF48b29VgwNkl2Yo3h55k30Hq7s1ynd5bmF1dG2orBnpvHIXv1JIP3RJPl_YqbuJDjmQT9xtWcWzijX4ib1BrzHqJq538yxZnVfL_l30ptRxx8qrnVbaqs3P-2tkbCF1QCAI37_irZ9Ock_gAszCBgjtcBXqrr62sLE3OxakJoXHnZ_mRK4xmP3LWnvkoRL4Uz1ZFPwT86qN5FcPjTHC40k5l8rggCeV3g7RKdXW-1dYJy_HQ