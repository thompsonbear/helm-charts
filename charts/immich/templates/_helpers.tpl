{{- define "immich.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "immich.fullname" -}}
{{- if .Values.fullnameOverride }}{{ .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}{{- else }}{{- $name := include "immich.name" . }}{{- if contains $name .Release.Name }}{{ .Release.Name | trunc 63 | trimSuffix "-" }}{{- else }}{{ printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}{{- end }}{{- end }}
{{- end }}
{{- define "immich.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote }}
app.kubernetes.io/name: {{ include "immich.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- define "immich.selectorLabels" -}}
app.kubernetes.io/name: {{ include "immich.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- define "immich.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}{{ default (include "immich.fullname" .) .Values.serviceAccount.name }}{{- else }}{{ default "default" .Values.serviceAccount.name }}{{- end }}
{{- end }}
{{- define "immich.serverImage" -}}
{{- printf "%s:%s" .Values.server.image.repository (default .Chart.AppVersion .Values.server.image.tag) }}
{{- end }}
{{- define "immich.machineLearningImage" -}}
{{- printf "%s:%s" .Values.machineLearning.image.repository (default .Chart.AppVersion .Values.machineLearning.image.tag) }}
{{- end }}
{{- define "immich.mediaClaim" -}}
{{- default (printf "%s-media" (include "immich.fullname" .)) .Values.server.persistence.existingClaim }}
{{- end }}
{{- define "immich.serverEnv" -}}
- name: TZ
  value: {{ .Values.server.timezone | quote }}
- name: IMMICH_LOG_LEVEL
  value: {{ .Values.server.logLevel | quote }}
{{- with .Values.server.trustedProxies }}
- name: IMMICH_TRUSTED_PROXIES
  value: {{ join "," . | quote }}
{{- end }}
{{- if eq .Values.database.secretType "url" }}
- name: DB_URL
  valueFrom:
    secretKeyRef:
      name: {{ required "database.existingSecret is required when database.secretType is url" .Values.database.existingSecret }}
      key: {{ required "database.urlKey is required when database.secretType is url" .Values.database.urlKey }}
{{- else if eq .Values.database.secretType "basic" }}
- name: DB_HOSTNAME
  value: {{ required "database.host is required" .Values.database.host | quote }}
- name: DB_PORT
  value: {{ .Values.database.port | quote }}
- name: DB_DATABASE_NAME
  value: {{ required "database.name is required" .Values.database.name | quote }}
- name: DB_USERNAME
  value: {{ required "database.username is required" .Values.database.username | quote }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ required "database.existingSecret is required" .Values.database.existingSecret }}
      key: {{ .Values.database.passwordKey }}
{{- with .Values.database.sslMode }}
- name: DB_SSL_MODE
  value: {{ . | quote }}
{{- end }}
{{- else }}
{{- fail "database.secretType must be url or basic" }}
{{- end }}
{{- with .Values.database.vectorExtension }}
- name: DB_VECTOR_EXTENSION
  value: {{ . | quote }}
{{- end }}
- name: REDIS_HOSTNAME
  value: {{ required "redis.host is required" .Values.redis.host | quote }}
- name: REDIS_PORT
  value: {{ .Values.redis.port | quote }}
{{- with .Values.redis.username }}
- name: REDIS_USERNAME
  value: {{ . | quote }}
{{- end }}
- name: REDIS_DBINDEX
  value: {{ .Values.redis.database | quote }}
{{- if .Values.redis.existingSecret }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.redis.existingSecret }}
      key: {{ .Values.redis.passwordKey }}
{{- end }}
{{- with .Values.server.extraEnv }}
{{- toYaml . }}
{{- end }}
{{- end }}
