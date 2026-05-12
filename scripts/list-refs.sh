#!/usr/bin/env bash
# Emit a JSON array of refs to publish: main + tags strictly newer than TAG_MIN.
# Usage:
#   list-refs.sh              # full matrix
#   list-refs.sh <ref>        # single-ref override (workflow_dispatch input)
set -euo pipefail

DISPATCH_REF="${1:-}"
if [[ -n "${DISPATCH_REF}" ]]; then
  jq -nc --arg r "${DISPATCH_REF}" '[$r]'
  exit 0
fi
