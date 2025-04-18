#!/usr/bin/env bats

load 'test_helper'

@test "temp_del() <path>: returns 0 and does not delete <path> if \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' is set to \`1' and the test have failed" {
  false
}

teardown() {
# NOTE: TEST_TEMP_DIR is assigned by BATS.
# shellcheck disable=SC2154
  temp_del "${TEST_TEMP_DIR}"
}
