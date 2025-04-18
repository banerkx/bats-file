#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# shellcheck disable=SC2154
  touch "${TEST_FIXTURE_ROOT}/dir/file"
}
teardown () {
    rm -f "${TEST_FIXTURE_ROOT}/dir/file"
}

# Correctness
@test 'assert_exists() <file>: returns 0 if <file> exists' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_exists() <file>: returns 0 if <directory> exists' {
  local -r file="${TEST_FIXTURE_ROOT}/dir"
  run assert_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_exists() <file>: returns 1 and displays path if <file> does not exist' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file.does_not_exists"
  run assert_exists "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory does not exist --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_exists() <file>: replace prefix of displayed path' {
  run assert_exists "${TEST_FIXTURE_ROOT}/dir/file.does_not_exist"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory does not exist --' ]
  [ "${lines[1]}" == "path : ../dir/file.does_not_exist" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_exists() <file>: replace suffix of displayed path' {
  run assert_exists "${TEST_FIXTURE_ROOT}/dir/file.does_not_exist"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory does not exist --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/dir/.." ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_exists() <file>: replace infix of displayed path' {
  run assert_exists "${TEST_FIXTURE_ROOT}/dir/file.does_not_exist"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file or directory does not exist --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/../file.does_not_exist" ]
  [ "${lines[2]}" == '--' ]
}
