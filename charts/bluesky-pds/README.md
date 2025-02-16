# bluesky-pds


A Helm chart to deploy a [Bluesky PDS](https://github.com/bluesky-social/pds) on Kubernetes.

![Version: 0.1.7](https://img.shields.io/badge/Version-0.1.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.4.74](https://img.shields.io/badge/AppVersion-0.4.74-informational?style=flat-square) 

## Installing

```bash
helm repo add bear https://charts.bear.fyi
helm repo update
helm install bluesky-pds bear/bluesky-pds -f values.yaml
```

Alternatively specify necessary values inline:
```bash
helm install bluesky-pds bear/bluesky-pds \
--set pds.config.hostname=pds.example.com \
--set pds.config.emailFromAddress=pds@example.com \
--set pds.config.secrets.emailSmtpUrl=smtps://username:password@smtp.example.com:465/
```

## Bluesky PDS Account Creation (Post Install)

Also refer to the [official PDS docs](https://github.com/bluesky-social/pds/blob/main/README.md).

### Generate an invite code via API request to your PDS
```bash
export PDS_HOSTNAME=pds.example.com

curl --request POST --header "Content-Type: application/json" \
    --user "admin:<YOUR-ADMIN-PASSWORD>" \
    --data '{"useCount": 1}' \
    "https://${PDS_HOSTNAME}/xrpc/com.atproto.server.createInviteCode"
```

Note: If you didn't specify your admin password during install, you can print the generated one with the following command:
```bash
kubectl get secret bluesky-pds-secret --template={{.data.adminPassword}} | base64 --decode
```

### Create your account

A. Create you account in the Bluesky UI
1. Navigate to https://bsky.app/ > **Create Account**
2. On the first step, specify the PDS hostname (By default, this is set to "Bluesky Social")
3. Input your invite code generated along with the new account information
4. Follow any additional prompts

B. Alternatively, create an account via API request
```bash
export PDS_HOSTNAME=pds.example.com

curl --request POST --header "Content-Type: application/json" \
--data '{
    "email":"<YOUR-ACCOUNT-EMAIL-ADDRESS>",
    "handle":"<YOUR-HANDLE eg. handle.pds.example.com>",
    "password":"<YOUR-ACCOUNT-PASSWORD>",
    "inviteCode":"<INVITE-CODE>"
    }' \
"https://${PDS_HOSTNAME}/xrpc/com.atproto.server.createAccount"
```



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

