#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  touch "${TEST_FIXTURE_ROOT}"/dir/groupidset "${TEST_FIXTURE_ROOT}"/dir/groupidnotset
  chmod g+s "${TEST_FIXTURE_ROOT}"/dir/groupidset
  
}
teardown () {
  
  rm -f "${TEST_FIXTURE_ROOT}"/dir/groupidset "${TEST_FIXTURE_ROOT}"/dir/groupidnotset
}

# Correctness
@test 'assert_file_not_group_id_set() <file>: returns 0 if <file> group id is not set' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/groupidnotset"
  run assert_file_not_group_id_set "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_file_not_group_id_set() <file>: returns 1 and displays path if <file> group id is set, but it was expected not to be' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/groupidset"
  run assert_file_not_group_id_set "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- group id is set, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}


# Transforming path
@test 'assert_file_not_group_id_set() <file>: replace prefix of displayed path' {
  run assert_file_not_group_id_set "${TEST_FIXTURE_ROOT}/dir/groupidset"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- group id is set, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ../dir/groupidset" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_not_group_id_set() <file>: replace suffix of displayed path' {
  run assert_file_not_group_id_set "${TEST_FIXTURE_ROOT}/dir/groupidset"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- group id is set, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_not_group_id_set() <file>: replace infix of displayed path' {
  run assert_file_not_group_id_set "${TEST_FIXTURE_ROOT}/dir/groupidset"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- group id is set, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
