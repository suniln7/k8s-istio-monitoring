# CI/CD Pipeline for Istio and Prometheus Monitoring

This repository contains a GitLab CI/CD pipeline for deploying Istio and Prometheus monitoring stack to a Kubernetes cluster. The pipeline automates the deployment process for different environments, such as `dev`, using Kubernetes and Helm.


## Pipeline Stages

The pipeline consists of two stages:
- **test**: This stage is used for testing purposes (currently not defined in the pipeline).
- **deploy**: This stage deploys Istio and Prometheus to the Kubernetes cluster.

## Jobs

### 1. **Deploy Istio (`deploy-istio-dev`)**

This job deploys or upgrades Istio in the `dev` environment.

- **Image**: A custom Docker image (`istioctl-kubectl`) from the GitLab registry is used for this 
- Upgrade Istio with the profile `default` using an environment-specific overlay file (`ingress-overlay-$ENV.yaml`).
- Apply the necessary resources such as gateways and Prometheus using `kubectl`.

### 2. **Deploy Prometheus (`deploy-kps-dev`)**

This job deploys or upgrades the Prometheus monitoring stack in the `dev` environment.

- **Configuration**:
  - Deploys the `kube-prometheus-stack` Helm chart from the `prometheus-community` repository.
  - Uses environment-specific override files (`chart-override.$ENV.yaml`).
  - Applies custom VirtualService manifests in the `./virtualservices` directory.

## Pipeline Flow

1. The `deploy-istio-dev` job is executed to deploy Istio.
2. Once Istio is successfully deployed, the `deploy-kps-dev` job deploys the Prometheus monitoring stack.
3. The `deploy-kps-dev` job has a dependency (`needs`) on `deploy-istio-dev`, ensuring that Istio is deployed first.

## Environment Variables

- `KUBE_CONTEXT`: The Kubernetes context to use for deployments. Set automatically from the GitLab namespace and connection.
- `ENV`: The environment to deploy to (e.g., `dev`).

## Customization

To deploy to other environments (e.g., `staging` or `production`), modify the `ENV` variable and create corresponding configuration files (`ingress-overlay-staging.yaml`, `chart-override.staging.yaml`, etc.).
