{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rudderstack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rudderstack.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rudderstack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "rudderstack.labels" -}}
helm.sh/chart: {{ include "rudderstack.chart" . }}
{{ include "rudderstack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "rudderstack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rudderstack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return secret name to be used based on provided values.
*/}}
{{- define "rudderstack.rudderWorkspaceTokenSecretName" -}}
{{- default (include "rudderstack.fullname" .) .Values.rudderWorkspaceTokenExistingSecret -}}
{{- end -}}

{{- define "transformer.name" -}}
{{- printf "%s-%s" (include "rudderstack.name" .) "transformer" -}}
{{- end -}}

{{- define "transformer.fullname" -}}
{{- printf "%s-%s" (include "rudderstack.fullname" .) "transformer" -}}
{{- end -}}

{{- define "backend.name" -}}
{{- printf "%s-%s" (include "rudderstack.name" .) "backend" -}}
{{- end -}}

{{- define "backend.fullname" -}}
{{- printf "%s-%s" (include "rudderstack.fullname" .) "backend" -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "statefulset.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apps/v1beta2" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

