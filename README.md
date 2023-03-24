# Sample `node.js` application deployment with `AWS EKS` and `Github Actions`
### The repository consists of 5 main components
- `.github/workflows` 
    - workflow dispatch to deploy and destroy the application on AWS EKS and get URL to access it from the internet. 
- `application/`
    - Dockerized node.js application which exposes `/` and `/metrics` endpoints on port 3000.
- `infrastructure/`
    - Terraform configuration files to deploy an EKS cluster on AWS arranged in modular structure.
- `k8s/`
    - Kubernetes manifest files to deploy the `application` with k8s `ingress` accessible from public endpoint.
- `resize/`
    - Bash script to add additional volume to the EBS volume attached to an EC2 instance in the cluster by its `Name` tag.   

## .github/workflows
[![Deploy | Destroy](https://github.com/albukhary/itech-final-task/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/albukhary/itech-final-task/actions/workflows/main.yaml)
Go to Actions section and select `Deploy` option in workflow dispatch. 
Select `Create K8s resources and run app` job, `Deploy app to EKS` step.
You will be provided with a URL to access the application deployed on the EKS cluster
![URL](https://i.paste.pics/9ab6c6577456585887c9eca76865d8f6.png "Access URL after deployment")
Append `/` and `/metrics` endpoints to the aboce URL to view Prometheus metrics for the Application by 
## application/
[![My Skills](https://skills.thijs.gg/icons?i=ts)](https://skills.thijs.gg) 

A simple node.js application that exposes `/` and `/metrics` endpoints to retrive `Prometheus` metrics for the application
You can find my `Dockerfile` that I used to build the image of the application.

You can also run the image on your computer
``` bash
# Run the image
docker run -d -p 3000:3000 lazizbekkahramonov/my-app:b281639e6b7554d9dff52fefc85c013c04adb2f2
# Open your browser and go to localhost:3000 and  localhost:3000/metrics
# OR
curl localhost:3000
curl localhost:3000/metrics
```
## infrastructure/
<img src="https://edent.github.io/SuperTinyIcons/images/svg/terraform.svg" width="100" title="Terraform" />

`infrastructure` folder consists of 2 subdirectories
- `cloud/`
- `modules/`

In the `modules` subdirectory you can find 2 modules, `vpc` for networking of the EKS cluster and `eks` for the resources to deploy the cluster.
``` bash
├── cloud
│   ├── eks
│   └── vpc
└── modules
    ├── eks
    └── vpc
```
Respectively, in the `cloud` subdirectory you can find implementations of these 2 modules.

## k8s/
<img src="https://upload.wikimedia.org/wikipedia/labs/thumb/b/ba/Kubernetes-icon-color.svg/247px-Kubernetes-icon-color.svg.png" width="100" title="Kubernetes" />
In the `k8s` folder, you can find the kubernetes manifests to create `Deployment`, `Service` and `Ingress` for you application to run on EKS cluster.

In the `scripts` subfolder I creates 2 bash scripts to install and delete `AWS Load Balancer Controller` for my `Ingress` on my Cluster.

```bash
── k8s
   ├── 1-express.yaml
   ├── 2-ingress.yaml
   └── scripts
       ├── destroy.sh
       └── setup.sh
```

## resize/
<img src="https://camo.githubusercontent.com/a7de91b915d8b286dda762e3683d9a1c961692d43f8349d020ecd54634a823cf/68747470733a2f2f63646e2e7261776769742e636f6d2f6f64622f6f6666696369616c2d626173682d6c6f676f2f6d61737465722f6173736574732f4c6f676f732f4964656e746974792f504e472f424153485f6c6f676f2d7472616e73706172656e742d62672d636f6c6f722e706e67" width="100" title="Bash" />
Here you can find a script `resize.sh` that prompts you to enter the `Name` tag of your EC2 instance and additional EBS volume to add.

Once you enter the `Name` tag, it searches the infrastructure and fetches the current volume. And, then prompts you to enter the additional space you want to add.
This way you can updated the volume of the EBS attached to your instance.

## Author
- [Lazizbek Kahramonov](https://github.com/albukhary)