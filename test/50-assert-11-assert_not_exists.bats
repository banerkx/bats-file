#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  touch "${TEST_FIXTURE_ROOT}"/dir/file
}
teardown () {
    rm -f "${TEST_FIXTURE_ROOT}"/dir/file
}

# Correctness
@test 'assert_not_exists() <file>: returns 0 if <file> does not exist' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file.does_not_exists"
  run assert_not_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_not_exists() <file>: returns 1 and displays path if <file> exists' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_not_exists "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_not_exists() <file>: replace prefix of displayed path' {
  run assert_not_exists "${TEST_FIXTURE_ROOT}/dir/file"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ../dir/file" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_not_exists() <file>: replace suffix of displayed path' {
  run assert_not_exists "${TEST_FIXTURE_ROOT}/dir/file"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/dir/.." ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_not_exists() <file>: replace infix of displayed path' {
  run assert_not_exists "${TEST_FIXTURE_ROOT}/dir/file"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/../file" ]
  [ "${lines[2]}" == '--' ]
}
