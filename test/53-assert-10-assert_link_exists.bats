#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  touch "${TEST_FIXTURE_ROOT}"/dir/file
  ln -s "${TEST_FIXTURE_ROOT}"/dir/file "${TEST_FIXTURE_ROOT}"/dir/link

}
teardown () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
    rm -f "${TEST_FIXTURE_ROOT}"/dir/link "${TEST_FIXTURE_ROOT}"/dir/file
}


# Correctness
@test 'assert_link_exists() <file>: returns 0 if <file> Link exists' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/link"
  run assert_link_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_link_exists() <file>: returns 1 and displays path if <file>symbolic link does not exist' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/ "
  run assert_link_exists "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- symbolic link does not exist --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_link_exists() <file>: replace prefix of displayed path' {
  run assert_link_exists "${TEST_FIXTURE_ROOT}/nodir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- symbolic link does not exist --' ]
  [ "${lines[1]}" == "path : ../nodir" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_link_exists() <file>: replace suffix of displayed path' {
  run assert_link_exists "${TEST_FIXTURE_ROOT}/nodir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- symbolic link does not exist --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/nodir" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_link_exists() <file>: replace infix of displayed path' {
  run assert_link_exists "${TEST_FIXTURE_ROOT}/nodir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- symbolic link does not exist --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
