#!/bin/bash

# Follow this documentation
# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

# Create Load Balancer Controller Service Account
kubectl apply -f aws-load-balancer-controller-service-account.yaml

# Add helm repository to install EKS charts
helm repo add eks https://aws.github.io/eks-charts

# Install AWS Load Balancer Controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=iTech-final-task-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 

# Get the URL of ingress to access from browser
kubectl get ing -n staging | awk 'FNR == 2 {print $4}'