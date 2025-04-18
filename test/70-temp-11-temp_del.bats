#!/usr/bin/env bats

load 'test_helper'
fixtures 'temp'


# Correctness
@test 'temp_del() <path>: returns 0 and deletes <path>' {
  TEST_TEMP_DIR="$(temp_make)"
  run temp_del "${TEST_TEMP_DIR}"

  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
  [ ! -e "${TEST_TEMP_DIR}" ]
}

@test 'temp_del() <path>: works even if wrote-protected file/directory exists within' {
  TEST_TEMP_DIR="$(temp_make)"
  touch "${TEST_TEMP_DIR}"/nowritefile
  chmod -w "${TEST_TEMP_DIR}"/nowritefile
  mkdir -p "${TEST_TEMP_DIR}"/nowritefolder
  chmod -w "${TEST_TEMP_DIR}"/nowritefolder

  run temp_del "${TEST_TEMP_DIR}"

  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
  [ ! -e "${TEST_TEMP_DIR}" ]
}

@test 'temp_del() <path>: returns 1 and displays an error message if <path> can not be deleted' {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  local -r path="${TEST_FIXTURE_ROOT}/does/not/exist"
  run temp_del "${path}"

  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- ERROR: temp_del --' ]
  # Travis CI's Ubuntu 12.04, quotes the path with a backtick and an
  # apostrophe, instead of just apostrophes.
  [[ ${lines[1]} == 'rm:'*"${path}"*': No such file or directory' ]] || false
  [ "${lines[2]}" == '--' ]
}

@test "temp_del() <path>: works if <path> starts with a \`-'" {
# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make --prefix -)"
  run temp_del "${TEST_TEMP_DIR}"

  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
  [ ! -e "${TEST_TEMP_DIR}" ]
}

# Environment variables
# shellcheck disable=SC2317
@test "temp_del() <path>: returns 0 and does not delete <path> if \`BATSLIB_TEMP_PRESERVE' is set to \`1'" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  run temp_del "${TEST_TEMP_DIR}"

  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
  [ -e "${TEST_TEMP_DIR}" ]
}

# shellcheck disable=SC2317
@test "temp_del() <path>: returns 0 and does not delete <path> if \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' is set to \`1' and the test have failed" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-fail.bats"

  [ "${status}" -eq 1 ]
  [ -e "${TEST_TEMP_DIR}" ]
}

@test "temp_del() <path>: returns 0 and deletes <path> if \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' is set to \`1' and the test have passed" {
  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-pass.bats"

  [ "${status}" -eq 0 ]
  [ ! -e "${TEST_TEMP_DIR}" ]
}

@test "temp_del() <path>: returns 0 and deletes <path> if \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' is set to \`1' and the test have been skipped" {
# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-skip.bats"

  [ "${status}" -eq 0 ]
  [ ! -e "${TEST_TEMP_DIR}" ]
}

# shellcheck disable=SC2317
@test "temp_del() <path>: \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' works when called from \`teardown'" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-teardown.bats"

  [ "${status}" -eq 1 ]
  [ -e "${TEST_TEMP_DIR}" ]
}

# shellcheck disable=SC2317
@test "temp_del() <path>: \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' works when called from \`teardown_file'" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-teardown_file.bats"

  [ "${status}" -eq 1 ]
  [ -e "${TEST_TEMP_DIR}" ]
}

# shellcheck disable=SC2317
@test "temp_del() <path>: \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' does not work when called from \`main'" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-main.bats"

  [ "${status}" -eq 1 ]
  [[ "${output}" == *'-- ERROR: temp_del --'* ]] || false
  [[ "${output}" == *"Must be called from \`teardown' or \`teardown_file' when using \`BATSLIB_TEMP_PRESERVE_ON_FAILURE'"* ]] || false
}

# shellcheck disable=SC2317
@test "temp_del() <path>: \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' does not work when called from \`setup'" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-setup.bats"

  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 10 ]
  [[ ${lines[6]} == *'-- ERROR: temp_del --' ]] || false
  [[ ${lines[7]} == *"Must be called from \`teardown' or \`teardown_file' when using \`BATSLIB_TEMP_PRESERVE_ON_FAILURE'" ]] || false
  [[ ${lines[8]} == *'--' ]] || false
}

# shellcheck disable=SC2317
@test "temp_del() <path>: \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' does not work when called from \`setup_file'" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

# shellcheck disable=SC2030
  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-setup_file.bats"

  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 10 ]
  [[ ${lines[6]} == *'-- ERROR: temp_del --' ]] || false
  [[ ${lines[7]} == *"Must be called from \`teardown' or \`teardown_file' when using \`BATSLIB_TEMP_PRESERVE_ON_FAILURE'" ]] || false
  [[ ${lines[8]} == *'--' ]] || false
}

@test "temp_del() <path>: \`BATSLIB_TEMP_PRESERVE_ON_FAILURE' does not work when called from \`@test'" {
# shellcheck disable=SC2031
  teardown() { rm -r -- "${TEST_TEMP_DIR}"; }

  TEST_TEMP_DIR="$(temp_make)"
  export TEST_TEMP_DIR
  run bats "${TEST_FIXTURE_ROOT}/temp_del-test.bats"

  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 10 ]
  [[ ${lines[6]} == *'-- ERROR: temp_del --' ]] || false
  [[ ${lines[7]} == *"Must be called from \`teardown' or \`teardown_file' when using \`BATSLIB_TEMP_PRESERVE_ON_FAILURE'" ]] || false
  [[ ${lines[8]} == *'--' ]] || false
}
