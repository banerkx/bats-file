#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  touch "${TEST_FIXTURE_ROOT}"/dir/stickybit "${TEST_FIXTURE_ROOT}"/dir/notstickybit
  chmod +t "${TEST_FIXTURE_ROOT}"/dir/stickybit
  
}
teardown () {
  
  rm -f "${TEST_FIXTURE_ROOT}"/dir/stickybit "${TEST_FIXTURE_ROOT}"/dir/notstickybit
  }


# Correctness
@test 'assert_sticky_bit() <file>: returns 0 if <file> stickybit is set' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/stickybit"
  run assert_sticky_bit "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_sticky_bit() <file>: returns 1 and displays path if <file> stickybit is not set' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/notstickybit"
  run assert_sticky_bit "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- stickybit is not set --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}



# Transforming path
@test 'assert_sticky_bit() <file>: replace prefix of displayed path' {
  run assert_sticky_bit "${TEST_FIXTURE_ROOT}/dir/notstickybit"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- stickybit is not set --' ]
  [ "${lines[1]}" == "path : ../dir/notstickybit" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_sticky_bit() <file>: replace suffix of displayed path' {
  run assert_sticky_bit "${TEST_FIXTURE_ROOT}/dir/notstickybit"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- stickybit is not set --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_sticky_bit() <file>: replace infix of displayed path' {
  run assert_sticky_bit "${TEST_FIXTURE_ROOT}/dir/notstickybit"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- stickybit is not set --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
