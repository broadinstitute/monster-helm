{{/*
   * Inject references to all the Argo variables needed to
   * render a full timestamp, in the required order.
   *
   * NOTE: This timestamp does not include any special
   * characters, to ensure it is compatible with external
   * storage systems.
   */}}
{{- define "argo.timestamp" -}}
{{- $YYYY := "{{workflow.creationTimestamp.Y}}" -}}
{{- $mm := "{{workflow.creationTimestamp.m}}" -}}
{{- $dd := "{{workflow.creationTimestamp.d}}" -}}
{{- $HH := "{{workflow.creationTimestamp.H}}" -}}
{{- $MM := "{{workflow.creationTimestamp.M}}" -}}
{{- $SS := "{{workflow.creationTimestamp.S}}" -}}
{{ printf "%s%s%sT%s%s%s" $YYYY $mm $dd $HH $MM $SS }}
{{- end -}}

{{/* Common retry settings to apply to flaky steps. */}}
{{- define "argo.retry" }}
retryStrategy:
  retryPolicy: Always
  backoff:
    duration: 1s
    factor: 2
    maxDuration: 5m
{{- end -}}

{{/* Render an array of strings line-by-line. Boilerplate for injecting script contents. */}}
{{- define "argo.render-lines" }}
{{- range . }}
{{ . }}
{{- end }}
{{- end }}

{{/* Collect metrics about execution results, including duration and result statuses. */}}
{{- define "argo.collect-execution-metrics" }}
- name: result_counter
  help: "Count step executions by result status"
  labels:
    - key: status
      value: "{{status}}"
  counter: 
    value: "1"
- name: realtime_duration_gauge
  help: "Realtime measure of step duration"
  gauge: 
    realtime: true
    value: value: "{{duration}}"
{{- end -}}
