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

@test "no tags newer than cutoff: output is [main]" {
  export MOCK_TAGS="v0.5.5 v0.5.4 v0.5.3"
  run "${REPO_ROOT}/scripts/list-refs.sh"
  [ "$status" -eq 0 ]
  [ "$output" = '["main"]' ]
}

@test "newer tags appear after main" {
  export MOCK_TAGS="v0.6.0 v0.5.5 v0.5.4"
  run "${REPO_ROOT}/scripts/list-refs.sh"
  [ "$status" -eq 0 ]
  [ "$output" = '["main","v0.6.0"]' ]
}

@test "cutoff itself is excluded even when sort coalesces duplicates" {
  export MOCK_TAGS="v0.5.5"
  run "${REPO_ROOT}/scripts/list-refs.sh"
  [ "$status" -eq 0 ]
  [ "$output" = '["main"]' ]
}

@test "version-sort handles pre-release and rc suffixes" {
  export MOCK_TAGS="v0.7.0-rc.1 v0.6.0 v0.5.5 v0.5.5-alpha.1"
  run "${REPO_ROOT}/scripts/list-refs.sh"
  [ "$status" -eq 0 ]
  [ "$output" = '["main","v0.6.0","v0.7.0-rc.1"]' ]
}
