#!/usr/bin/env bats

load 'test_helper'
fixtures 'temp'


# Correctness
# shellcheck disable=SC2317
@test 'temp_make() <var>: returns 0, creates a temporary directory and displays its path' {
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  echo "${TEST_TEMP_DIR}"

# NOTE: BATS_TMPDIR and BATS_TEST_FILENAME are assigned by BATS.
# shellcheck disable=SC2154
  local -r literal="${BATS_TMPDIR}/${BATS_TEST_FILENAME##*/}-"
  local -r pattern='[1-9][0-9]*-.{6}'
  [[ ${TEST_TEMP_DIR} =~ ^"${literal}"${pattern}$ ]] || false
  [ -e "${TEST_TEMP_DIR}" ]
}

@test 'temp_make() <var>: returns 1 and displays an error message if the directory can not be created' {
  run temp_make

  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- ERROR: temp_make --' ]
  
  REGEX="mktemp:.*No such file or directory"
  [[ ${lines[1]} =~ ${REGEX} ]] || false
  [ "${lines[2]}" == '--' ]
}

@test "temp_make() <var>: works when called from \`setup'" {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  bats "${TEST_FIXTURE_ROOT}/temp_make-setup.bats"
}

@test "temp_make() <var>: works when called from \`setup_file'" {
  bats "${TEST_FIXTURE_ROOT}/temp_make-setup_file.bats"
}

@test "temp_make() <var>: works when called from \`@test'" {
  bats "${TEST_FIXTURE_ROOT}/temp_make-test.bats"
}

@test "temp_make() <var>: works when called from \`teardown'" {
  bats "${TEST_FIXTURE_ROOT}/temp_make-teardown.bats"
}

@test "temp_make() <var>: works when called from \`teardown_file'" {
  bats "${TEST_FIXTURE_ROOT}/temp_make-teardown_file.bats"
}

@test "temp_make() <var>: does not work when called from \`main'" {
  run bats "${TEST_FIXTURE_ROOT}/temp_make-main.bats"

  [ "${status}" -eq 1 ]
  [[ "${output}" == *'-- ERROR: temp_make --'* ]] || false
  [[ "${output}" == *"Must be called from \`setup', \`@test' or \`teardown'"* ]] || false
}

# Options
# shellcheck disable=SC2317
test_p_prefix() {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

  TEST_TEMP_DIR="$(temp_make "$@" 'test-')"

  local -r literal="${BATS_TMPDIR}/test-${BATS_TEST_FILENAME##*/}-"
  local -r pattern='[1-9][0-9]*-.{6}'
  [[ ${TEST_TEMP_DIR} =~ ^"${literal}"${pattern}$ ]] || false
  [ -e "${TEST_TEMP_DIR}" ]
}

@test 'temp_make() -p <prefix> <var>: returns 0 and creates a temporary directory with <prefix> prefix' {
  test_p_prefix -p
}

@test 'temp_make() --prefix <prefix> <var>: returns 0 and creates a temporary directory with <prefix> prefix' {
  test_p_prefix --prefix
}

@test "temp_make() --prefix <prefix> <var>: works if <prefix> starts with a \`-'" {
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

  TEST_TEMP_DIR="$(temp_make --prefix -)"

  [ -e "${TEST_TEMP_DIR}" ]
}
