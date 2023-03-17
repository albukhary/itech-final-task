#!/bin/bash

helm repo add ingress-nginx \
  https://kubernetes.github.io/ingress-nginx

helm repo update

helm search repo nginx
# ingress-nginx/ingress-nginx     4.5.2           1.6.4

# Generate yaml from helm charts
helm template my-ing ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version 4.5.2 \
  --values values.yaml \
  --output-dir my-ing

# Deploy Nginx ingress with Helm.
helm install my-ing ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version 4.5.2 \
  --values values.yaml \
  --create-namespace

# List Helm releases.
# helm list -n ingress-nginx

# # Get nginx pods.
# kubectl get pods -n ingress-nginx

# Apply - deploy your nginx ingress
kubernetes apply -f 2_ingress.yaml

# # Get Kubernetes services.
# Get DNS of that service
# kubectl get svc -n ingress-nginx
