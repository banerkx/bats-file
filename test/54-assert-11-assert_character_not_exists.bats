#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  bats_sudo mknod "${TEST_FIXTURE_ROOT}"/dir/test_device c 89 1
}
teardown () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
    rm -f "${TEST_FIXTURE_ROOT}"/dir/test_device
}

# Correctness
@test 'assert_character_not_exists() <file>: returns 0 if <file> character special file does not exist' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_character_not_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_character_not_exists() <file>: returns 1 and displays path if <file> character special file exists, but it was expected to be absent' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/test_device"
  run assert_character_not_exists "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- character special file exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_character_not_exists() <file>: replace prefix of displayed path' {
  run assert_character_not_exists "${TEST_FIXTURE_ROOT}/dir/test_device"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- character special file exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ../dir/test_device" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_character_not_exists() <file>: replace suffix of displayed path' {
  run assert_character_not_exists "${TEST_FIXTURE_ROOT}/dir/test_device"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- character special file exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/dir/test_device" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_character_not_exists() <file>: replace infix of displayed path' {
  run assert_character_not_exists "${TEST_FIXTURE_ROOT}/dir/test_device"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- character special file exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/../test_device" ]
  [ "${lines[2]}" == '--' ]
}
