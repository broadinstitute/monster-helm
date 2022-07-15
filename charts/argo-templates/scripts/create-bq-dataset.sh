set -euo pipefail

declare -ra BQ_CREATE=(
  bq
  --location=${REGION}
  mk
  --dataset
  --force
  "--description=${DESCRIPTION}"
  --default_table_expiration=${EXPIRATION}
  ${PROJECT}:${DATASET}
)
1>&2 "${BQ_CREATE[@]}"

# Print the dataset name so it can be slurped as an
# output parameter when needed.
echo ${DATASET}
