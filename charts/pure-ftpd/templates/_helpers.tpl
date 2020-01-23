{{/* vim: set filetype=mustache: */}}

{{/* Common labels */}}
{{- define "pure-ftpd.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels used to bind service<->deployment<->pod */}}
{{- define "pure-ftpd.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end -}}

{{/* Create the name of the service account to use */}}
{{- define "pure-ftpd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{ default (printf "%s-account" .Release.Name) .Values.serviceAccount.name }}
{{- else -}}
  {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
