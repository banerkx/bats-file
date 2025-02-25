# shellcheck shell=bash

# NOTE: BATS_TEST_DIRNAME is defined elsewhere.
# shellcheck disable=SC2154
export TEST_MAIN_DIR="${BATS_TEST_DIRNAME}/../../.."
export TEST_DEPS_DIR="${TEST_DEPS_DIR-${TEST_MAIN_DIR}/..}"

# Load dependencies.
bats_load_library "bats-support"

# Load library.
load "${TEST_MAIN_DIR}/load.bash"
