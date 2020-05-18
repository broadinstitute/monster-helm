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
- name: step_result_counter
  help: "Count step executions by result status"
  labels:
    - key: status
      value: '{{ "{{status}}" }}'
  counter:
    value: "1"
- name: realtime_duration
  help: "Realtime measure of step duration"
  gauge:
    realtime: true
    value: value: '{{ "{{duration}}" }}'
{{- end -}}

{{/* Define the poll ingest job task. */}}
{{- define "argo.poll-ingest-job" }}
- name: poll-ingest-job
  inputs:
    parameters:
      - name: api-url
      - name: job-id
      - name: timeout
      - name: sa-secret
      - name: sa-secret-key
  volumes:
    - name: sa-secret-volume
      secret:
        secretName: '{{ "{{inputs.parameters.sa-secret}}" }}'
  script:
    image: us.gcr.io/broad-dsp-gcr-public/monster-auth-req-py:1.0.1
    volumeMounts:
      - name: sa-secret-volume
        mountPath: '/secret'
    env:
      - name: API_URL
        value: '{{ "{{inputs.parameters.api-url}}" }}'
      - name: JOB_ID
        value: '{{ "{{inputs.parameters.job-id}}" }}'
      - name: TIMEOUT
        value: '{{ "{{inputs.parameters.timeout}}" }}'
      - name: GOOGLE_APPLICATION_CREDENTIALS
        value: '{{ "/secret/{{inputs.parameters.sa-secret-key}}" }}'
    command: [python]
    source: |
      {{- include "argo.render-lines" (.Files.Lines "scripts/poll-ingest-job.py") | indent 10 }}
{{- end -}}
