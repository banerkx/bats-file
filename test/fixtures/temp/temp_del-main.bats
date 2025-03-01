#!/usr/bin/env bats

load 'test_helper'

# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
temp_del "${TEST_TEMP_DIR}"

@test empty {
    :
}
