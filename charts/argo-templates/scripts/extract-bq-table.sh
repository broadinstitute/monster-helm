set -euo pipefail

# Extract the table's contents into part-files in GCS.
declare -ra BQ_EXTRACT=(
  bq
  --location=${REGION}
  --project_id=${PROJECT}
  --synchronous_mode=true
  --headless=true
  --format=none
  extract
  --destination_format=${OUTPUT_FORMAT}
  --print_header=false
)
declare -r OUTPUT_PATTERN=gs://${GCS_BUCKET}/${GCS_PREFIX}/*

# Wipe out any files already present at the output location.
# If there are no files the `rm` command will fail, so we tack `|| true`
# on the end to keep running.
1>&2 gsutil -m rm ${OUTPUT_PATTERN} || true

# Extract to GCS.
1>&2 ${BQ_EXTRACT[@]} ${PROJECT}:${DATASET}.${TABLE} ${OUTPUT_PATTERN}

# Echo the GCS prefix back to Argo, to make plumbing it through as an output easier.
echo ${GCS_PREFIX}
