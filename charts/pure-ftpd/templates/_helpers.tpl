{{/* vim: set filetype=mustache: */}}

{{/* Create the name of the service account to use */}}
{{- define "pure-ftpd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{ default (printf "%s-account" .Release.Name) .Values.serviceAccount.name }}
{{- else -}}
  {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
