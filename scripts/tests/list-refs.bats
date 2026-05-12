#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  PATH="${BATS_TEST_DIRNAME}/stubs:${PATH}"
  export PATH
  export TAG_MIN="v0.5.5"
}

@test "dispatch ref is echoed as a single-element array" {
  run "${REPO_ROOT}/scripts/list-refs.sh" "v0.6.0"
  [ "$status" -eq 0 ]
  [ "$output" = '["v0.6.0"]' ]
}
