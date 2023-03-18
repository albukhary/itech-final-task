#!/bin/bash

# aws eks update-kubeconfig --name iTech-final-task-cluster --region us-east-1

# Follow this documentation
# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

# # Download an IAM policy for the AWS Load Balancer Controller 
# # that allows it to make calls to AWS APIs on your behalf.
# curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json

# # Create an IAM policy using the policy downloaded in the previous step.
# aws iam create-policy \
#     --policy-name AWSLoadBalancerControllerIAMPolicy \
#     --policy-document file://iam_policy.json

# # Retrieve your cluster's OIDC provider ID and store it in a variable.
# oidc_id=$(aws eks describe-cluster --name iTech-final-task-cluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

# # Determine whether an IAM OIDC provider with your cluster's ID is already in your account.
# aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
# # If output is returned, then you already have an IAM OIDC provider for your cluster and you can skip the next step. 
# # If no output is returned, then you must create an IAM OIDC provider for your cluster.

# Create an IAM OIDC identity provider for your cluster with the following command.
eksctl utils associate-iam-oidc-provider --cluster iTech-final-task-cluster --approve

# After creation store that into a variable
oidc_id=$(aws eks describe-cluster --name iTech-final-task-cluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

echo "1 Here is my $oidc_id"

# Input that OIDS provider iD in load-balancer-role-trust-policy.json
cat >load-balancer-role-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::906871231312:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/$oidc_id"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.us-east-1.amazonaws.com/id/$oidc_id:aud": "sts.amazonaws.com",
                    "oidc.eks.us-east-1.amazonaws.com/id/$oidc_id:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF

# Create Role using that policy
aws iam create-role \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --assume-role-policy-document file://"load-balancer-role-trust-policy.json" > /dev/null

# Attach the required Amazon EKS managed IAM policy to the IAM role.
# Replace 906871231312 with your account ID.
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::906871231312:policy/AWSLoadBalancerControllerIAMPolicy \
  --role-name AmazonEKSLoadBalancerControllerRole

# # Create AWS Load Balancer Controller service account yaml
# cat >aws-load-balancer-controller-service-account.yaml <<EOF
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   labels:
#     app.kubernetes.io/component: controller
#     app.kubernetes.io/name: aws-load-balancer-controller
#   name: aws-load-balancer-controller
#   namespace: kube-system
#   annotations:
#     eks.amazonaws.com/role-arn: arn:aws:iam::906871231312:role/AmazonEKSLoadBalancerControllerRole
# EOF

# Create the Kubernetes service account on your cluster.
kubectl apply -f ../aws-load-balancer-controller-service-account.yaml

# Add helm repository to install EKS charts
helm repo add eks https://aws.github.io/eks-charts

# Update your local repo to make sure that you have the most recent charts.
helm repo update

# Install AWS Load Balancer Controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=iTech-final-task-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 

# Now apply manifest files
kubectl apply -f ../1-express.yaml
kubectl apply -f ../2-ingress.yaml

# Wait for some time until DNS url is given to ingress

sleep 10

# Get the URL of ingress to access from browser
kubectl get ing -n staging | awk 'FNR == 2 {print $4}'

# How to make http request with a host
#curl -H 'Host: www.example.com' http://server-ip


