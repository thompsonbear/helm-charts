# bluesky-pds


A Helm chart to deploy a [Bluesky PDS](https://github.com/bluesky-social/pds) on Kubernetes.

![Version: 0.1.6](https://img.shields.io/badge/Version-0.1.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.4.74](https://img.shields.io/badge/AppVersion-0.4.74-informational?style=flat-square) 

## Installing the Chart

```bash
helm repo add bear https://charts.bear.fyi
helm repo update
helm install bluesky-pds bear/bluesky-pds -f values.yaml
```

## Bluesky PDS configuration and account creation

Regarding configuration and account creation, refer to the [official PDS docs](https://github.com/bluesky-social/pds/blob/main/README.md).

### Generate invite code via API POST request to your PDS

```bash
export ADMINPW=your-admin-pw
export PDS_HOSTNAME=pds.example.com
curl --request POST --header "Content-Type: application/json" \
    --user "admin:${ADMINPW}" \
    --data '{"useCount": 1}' \
    "https://${PDS_HOSTNAME}/xrpc/com.atproto.server.createInviteCode"
```

Create your account (if necessary) and login with https://bsky.app/ using your PDS and the Invite Code you generated.



## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/bluesky-social/pds"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"pds.example.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| pds.config.blobstoreLocation | string | `"/pds/blocks"` |  |
| pds.config.bskyAppViewDid | string | `"did:web:api.bsky.app"` |  |
| pds.config.bskyAppViewUrl | string | `"https://api.bsky.app"` |  |
| pds.config.crawlers | string | `"https://bsky.network"` |  |
| pds.config.dataDir | string | `"/pds"` |  |
| pds.config.didPlcUrl | string | `"https://plc.directory"` |  |
| pds.config.emailFromAddress | string | `"bsky@example.com"` |  |
| pds.config.hostname | string | `"pds.example.com"` |  |
| pds.config.reportSvcDid | string | `"did:plc:ar7c4by46qjdydhdevvrndac"` |  |
| pds.config.reportSvcUrl | string | `"https://mod.bsky.app"` |  |
| pds.config.secrets.adminPassword | string | `""` |  |
| pds.config.secrets.emailSmtpUrl | string | `""` |  |
| pds.config.secrets.jwtSecret | string | `""` |  |
| pds.config.secrets.plcRotationKey | string | `""` |  |
| pds.dataStorage.mountPath | string | `"/pds"` |  |
| pds.dataStorage.size | string | `"20Gi"` |  |
| pds.dataStorage.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | int | `1` |  |
| resources.limits.memory | string | `"1024Mi"` |  |
| resources.requests.cpu | int | `1` |  |
| resources.requests.memory | string | `"1024Mi"` |  |
| securityContext | object | `{}` |  |
| service.port | int | `3000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

