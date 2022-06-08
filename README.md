# Docker Build & Deployment of a Go App

##### Note: The application in this repository gets deployed on the infra created using https://github.com/sarath-pillai/tf-infra

### Description
The main purpose of this repository is to demonstrate the Docker build & deployment of a go app. Some of the things that was kept in mind while implementing this. 

- Extremely light weight docker image (its the philosophy of docker image building process to keep just the bare minimum that is required in the image. This keeps the attack vector low, as well as from an image pull down standpoint it will be much faster.). We use Docker multi stage build process in this repository to achieve this https://docs.docker.com/develop/develop-images/multistage-build/
- Docker build and push to dockerhub. 
- Helm chart packaging and deployment.
- Automatic SSL certificate issue process. 

### Prerequisite
- This project assumes you have access to an existing k8s cluster. And requires the kubeconfig to access it. `KUBECONFIG_FILE` secret in github settings is by default used by the workflow.
- The github workflow in this repository assumes that you have access to a docker hub registry that is publical (well i have kept it publical for simplicity, but can be private as well, in which case `imagePullSecret` will have to be added inside helm chart). The github workflow requires the dockerhub secret named `DOCKERHUB_PASSWORD` & `DOCKERHUB_USERNAME`.

### Helm Chart
The chart for the application is located inside `helm` directory. Its a pretty basic chart with just the below resources in k8s. 
- An ingress. 
- A service. 
- A deployment object. 

The main variables needed by helm is mentioned below.. An example values file is below. The cert manager automatically provisions the lets encrypt certificate for the `Domain` below. This is because of the cert-manager deployment done here: https://github.com/sarath-pillai/tf-infra/blob/main/eks.tf#L39

```
Domain: go-k8s-helm.demo.slashroot.in
replicaCount: 1
namespace: default

image:
  repository: go-k8s-helm
  tag: latest
  registry: sarathp88

service:
  port: 8080
```

The docker image tag gets replaced during helm deployment see this https://github.com/sarath-pillai/go-k8s-helm/blob/main/.github/workflows/actions.yaml#L40

### How does this get deployed
This repository uses Github workflow as its deployment method. I have selected github workflow for illustration purpose only. This can be adapted to use Jenkins by committing a Jenkinsfile to the root of the repository as well.  Or any other CI tool for that matter. Any commits to the main branch creates a docker image with a new tag and gets pushed to docker hub. 

The helm deploy replaces the deployment object in the k8s cluster with the new image that was created. 

You can access this deployed over here: https://go-k8s-helm.demo.slashroot.in/counter
