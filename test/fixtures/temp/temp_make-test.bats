#!/usr/bin/env bats

load 'test_helper'

@test "temp_make() <var>: works when called from \`@test'" {
# shellcheck disable=SC2030,SC2031
  TEST_TEMP_DIR="$(temp_make)"
}

teardown() {
# shellcheck disable=SC2030,SC2031
  rm -r -- "${TEST_TEMP_DIR}"
}
