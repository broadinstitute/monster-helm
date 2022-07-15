set -euo pipefail

function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }

declare -r TARGET_TABLE=${TABLE}_rowids

# Point to BQ metadata we expect to be present on disk.
declare -r TABLE_DIR=/bq-metadata/${TABLE}
declare -r PK_COLS=$(cat ${TABLE_DIR}/primary-keys)

# Build the WHERE clause of the SQL query.
# If we're running an upsert, we only want to pull out the row IDs of data
# with a new version in the staging area.
# Otherwise we're running a full table reset, and we want to pull all existing row IDs.
declare -a COMPARISONS=("datarepo_row_id IS NOT NULL")
if [[ ${UPSERT} = 'true' ]]; then
  for c in ${PK_COLS//,/ }; do
    COMPARISONS+=("${c} IS NOT NULL")
  done
fi
declare -r FULL_DIFF=$(join_by ' AND ' "${COMPARISONS[@]}")

# Pull just the non-null row IDs out of a table. We need the results in
# a table because you can't directly export the results of a query to GCS.
declare -ra BQ_QUERY=(
  bq
  --location=${REGION}
  --project_id=${PROJECT}
  --synchronous_mode=true
  --headless=true
  --format=none
  query
  --use_legacy_sql=false
  --replace=true
  --destination_table=${PROJECT}:${DATASET}.${TARGET_TABLE}
)
1>&2 ${BQ_QUERY[@]} "SELECT datarepo_row_id
  FROM \`${PROJECT}.${DATASET}.${INPUT_TABLE}\`
  WHERE ${FULL_DIFF}"

# Echo the output table name so Argo can slurp it into a parameter.
echo ${TARGET_TABLE}
