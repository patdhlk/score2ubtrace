#!/usr/bin/env bash
# Tar the ubTrace build output and POST it to the ingest endpoint.
# All inputs are env vars so the workflow can vary them per matrix entry.
set -euo pipefail

: "${UBTRACE_INGEST_TOKEN:?required}"
: "${UBTRACE_URL:?required}"
: "${UBTRACE_ORG:?required}"
: "${UBTRACE_PROJECT:?required}"
: "${UBTRACE_VERSION:?required}"
: "${BUILD_DIR:?required}"

if [[ ! -d "${BUILD_DIR}" ]]; then
  echo "upload.sh: BUILD_DIR does not exist: ${BUILD_DIR}" >&2
  exit 2
fi

tar -czf /tmp/build.tar.gz -C "${BUILD_DIR}" .

curl --fail-with-body --show-error \
  -H "Authorization: Bearer ${UBTRACE_INGEST_TOKEN}" \
  -F "file=@/tmp/build.tar.gz" \
  "${UBTRACE_URL}/v1/ingest/${UBTRACE_ORG}/${UBTRACE_PROJECT}/${UBTRACE_VERSION}?overwrite=true"
