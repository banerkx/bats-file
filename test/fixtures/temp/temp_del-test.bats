#!/usr/bin/env bats

load 'test_helper'

@test "temp_del() <path>: \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' does not work when called from \`@test'" {
# NOTE: TEST_TEMP_DIR is assigned by BATS.
# shellcheck disable=SC2154
  temp_del "${TEST_TEMP_DIR}"
}
