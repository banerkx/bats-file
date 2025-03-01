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
@test 'assert_file_exists() <file>: returns 0 if <file> exists' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_file_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_file_exists() <file>: returns 1 and displays path if <file> does not exist' {
  local -r file="${TEST_FIXTURE_ROOT}/dir"
  run assert_file_exists "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file does not exist --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_file_exists() <file>: replace prefix of displayed path' {
  run assert_file_exists "${TEST_FIXTURE_ROOT}/dir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file does not exist --' ]
  [ "${lines[1]}" == "path : ../dir" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_exists() <file>: replace suffix of displayed path' {
  run assert_file_exists "${TEST_FIXTURE_ROOT}/dir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file does not exist --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/dir" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_exists() <file>: replace infix of displayed path' {
  run assert_file_exists "${TEST_FIXTURE_ROOT}/dir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file does not exist --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
