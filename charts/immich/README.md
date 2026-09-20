# immich

A Helm chart for Immich with separate API and microservices worker deployments.
PostgreSQL and Redis are external dependencies and are not installed by this
chart. The API, microservices, and machine-learning workloads are deployed by
the chart; Ingress and HTTPRoute support is disabled by default.

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v3.1.0](https://img.shields.io/badge/AppVersion-v3.1.0-informational?style=flat-square)

## Installing

Add the Bear chart repository and install the chart with a values file that
points at the existing PostgreSQL and Redis services:

```bash
helm repo add bear https://charts.bear.fyi
helm repo update
helm upgrade --install immich bear/immich \
  --namespace immich \
  --create-namespace \
  --values values.yaml
```

## Configuration

Environment variables must be set on the server components to configure the PostgreSQL and Redis/Valkey connections per the [documentation](https://docs.immich.app/install/environment-variables#database) before installation will succeed.

`server.persistence` is mounted by both the API and microservices pods and
therefore must support the configured shared access mode (default:
`ReadWriteMany`). To use a pre-existing claim, set
`server.persistence.existingClaim`.

Horizontal Pod Autoscalers are disabled by default. Enable the relevant
`autoscaling.enabled` value and set CPU requests under that workload's
`resources` to use CPU utilization scaling. The machine-learning Service is
available at `<release>-immich-machine-learning:3003`; configure it in Immich's
machine-learning system settings when using this in-cluster workload.

External exposure is disabled by default. Set either `ingress.enabled` with at
least one `ingress.hosts` entry, or `httpRoute.enabled` with Gateway API
`httpRoute.parentRefs`. Both options route only to the API Service and cannot
be enabled together.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` |  |
| httpRoute.annotations | object | `{}` |  |
| httpRoute.enabled | bool | `false` |  |
| httpRoute.hostnames | list | `[]` |  |
| httpRoute.parentRefs | list | `[]` |  |
| httpRoute.rules[0].matches[0].path.type | string | `"PathPrefix"` |  |
| httpRoute.rules[0].matches[0].path.value | string | `"/"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| machineLearning.affinity | object | `{}` |  |
| machineLearning.autoscaling.behavior | object | `{}` |  |
| machineLearning.autoscaling.enabled | bool | `false` |  |
| machineLearning.autoscaling.maxReplicas | int | `3` |  |
| machineLearning.autoscaling.minReplicas | int | `1` |  |
| machineLearning.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| machineLearning.autoscaling.targetMemoryUtilizationPercentage | string | `""` |  |
| machineLearning.enabled | bool | `true` |  |
| machineLearning.env | list | `[]` |  |
| machineLearning.extraEnv | list | `[]` |  |
| machineLearning.image.pullPolicy | string | `"IfNotPresent"` |  |
| machineLearning.image.repository | string | `"ghcr.io/immich-app/immich-machine-learning"` |  |
| machineLearning.image.tag | string | `""` |  |
| machineLearning.modelCache.accessModes[0] | string | `"ReadWriteOnce"` |  |
| machineLearning.modelCache.existingClaim | string | `""` |  |
| machineLearning.modelCache.size | string | `"10Gi"` |  |
| machineLearning.modelCache.storageClass | string | `""` |  |
| machineLearning.modelCache.type | string | `"emptyDir"` |  |
| machineLearning.nodeSelector | object | `{}` |  |
| machineLearning.replicaCount | int | `1` |  |
| machineLearning.resources | object | `{}` |  |
| machineLearning.service.annotations | object | `{}` |  |
| machineLearning.service.port | int | `3003` |  |
| machineLearning.service.type | string | `"ClusterIP"` |  |
| machineLearning.tolerations | list | `[]` |  |
| nameOverride | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| server.api.affinity | object | `{}` |  |
| server.api.autoscaling.behavior | object | `{}` |  |
| server.api.autoscaling.enabled | bool | `false` |  |
| server.api.autoscaling.maxReplicas | int | `3` |  |
| server.api.autoscaling.minReplicas | int | `1` |  |
| server.api.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| server.api.autoscaling.targetMemoryUtilizationPercentage | string | `""` |  |
| server.api.nodeSelector | object | `{}` |  |
| server.api.replicaCount | int | `1` |  |
| server.api.resources | object | `{}` |  |
| server.api.service.annotations | object | `{}` |  |
| server.api.service.port | int | `2283` |  |
| server.api.service.type | string | `"ClusterIP"` |  |
| server.api.tolerations | list | `[]` |  |
| server.env | list | `[]` |  |
| server.image.pullPolicy | string | `"IfNotPresent"` |  |
| server.image.repository | string | `"ghcr.io/immich-app/immich-server"` |  |
| server.image.tag | string | `""` |  |
| server.microservices.affinity | object | `{}` |  |
| server.microservices.autoscaling.behavior | object | `{}` |  |
| server.microservices.autoscaling.enabled | bool | `false` |  |
| server.microservices.autoscaling.maxReplicas | int | `3` |  |
| server.microservices.autoscaling.minReplicas | int | `1` |  |
| server.microservices.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| server.microservices.autoscaling.targetMemoryUtilizationPercentage | string | `""` |  |
| server.microservices.nodeSelector | object | `{}` |  |
| server.microservices.replicaCount | int | `1` |  |
| server.microservices.resources | object | `{}` |  |
| server.microservices.tolerations | list | `[]` |  |
| server.persistence.enabled | bool | `true` |  |
| server.persistence.existingClaim | string | `""` |  |
| server.persistence.size | string | `"10Gi"` |  |
| server.persistence.storageClass | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
