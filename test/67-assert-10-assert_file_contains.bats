#!/usr/bin/env bats
load 'test_helper'
fixtures 'empty'
# Correctness
@test 'assert_file_contains() <file>: returns 0 and displays content if <file> matches string' {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  local -r file="${TEST_FIXTURE_ROOT}/dir/non-empty-file"
  run assert_file_contains "${file}" "Not empty"
  [ "${status}" -eq 0 ]
}
@test 'assert_file_contains() <file>: returns 1 and displays content if <file> does not match string' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/non-empty-file"
  run assert_file_contains "${file}" "XXX"
  [ "${status}" -eq 1 ]
}
# Transforming path
@test 'assert_file_contains() <file>: replace prefix of displayed path' {
  run assert_file_contains "${TEST_FIXTURE_ROOT}/dir/non-empty-file" "XXX"
  [ "${status}" -eq 1 ]
}
@test 'assert_file_contains() <file>: replace suffix of displayed path' {
  run assert_file_contains "${TEST_FIXTURE_ROOT}/dir/non-empty-file" "XXX"
  [ "${status}" -eq 1 ]
}
@test 'assert_file_contains() <file>: replace infix of displayed path' {
  run assert_file_contains "${TEST_FIXTURE_ROOT}/dir/non-empty-file" "XXX"
  [ "${status}" -eq 1 ]
}
@test 'assert_file_contains() <file>: show missing regex in case of failure' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/non-empty-file"
  run assert_file_contains "${file}" "XXX"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 4 ]
  [ "${lines[0]}" == '-- file does not contain regex --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == "regex : XXX" ]
  [ "${lines[3]}" == '--' ]
}


  
