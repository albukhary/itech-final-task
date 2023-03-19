#################### How to undo everything

aws eks update-kubeconfig --name iTech-final-task-cluster --region us-east-1

# Now delete manifest files
kubectl delete -f ../2-ingress.yaml
kubectl delete -f ../1-express.yaml

# Uninstall AWS Load Balancer Controller
helm uninstall aws-load-balancer-controller -n kube-system

# Destroy the Kubernetes service account on your cluster.
kubectl delete -f ../aws-load-balancer-controller-service-account.yaml

# Detach policy from role
aws iam detach-role-policy \
--role-name AmazonEKSLoadBalancerControllerRole \
--policy-arn arn:aws:iam::906871231312:policy/AWSLoadBalancerControllerIAMPolicy

# Delete Role using that policy
aws iam delete-role \
  --role-name AmazonEKSLoadBalancerControllerRole 

# store that into a variable
oidc_id=$(aws eks describe-cluster --name iTech-final-task-cluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

# Get the ARN of the OIDC
# oidc_arn=$(aws iam list-open-id-connect-providers | grep $oidc_id |  cut -d '"' -f 4 | awk -F'/id' '{print $1}') 
oidc_arn=$(aws iam list-open-id-connect-providers | grep $oidc_id |  cut -d '"' -f 4)

# Delete the IAM OIDC identity provider for your cluster with the following command
aws iam delete-open-id-connect-provider \
--open-id-connect-provider-arn $oidc_arn