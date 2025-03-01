#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  readonly ZERO_FILE=${TEST_FIXTURE_ROOT}/dir/zerobyte  
  touch "${ZERO_FILE}"

  readonly NOTZERO_FILE="${TEST_FIXTURE_ROOT}/dir/notzerobyte"
  echo "not empty" > "${NOTZERO_FILE}"
} 

teardown () {  
  rm -f "${TEST_FIXTURE_ROOT}"/dir/zerobyte "${TEST_FIXTURE_ROOT}"/dir/notzerobyte
}


# Correctness
@test 'assert_size_zero() <file>: returns 0 if <file> file is 0 byte' {
  run assert_size_zero "${ZERO_FILE}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_size_zero() <file>: returns 1 and displays path if <file> file is greater than 0 byte' {
  run assert_size_zero "${NOTZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is greater than 0 byte --' ]
  [ "${lines[1]}" == "path : ${NOTZERO_FILE}" ]
  [ "${lines[2]}" == '--' ]
}



# Transforming path
@test 'assert_size_zero() <file>: replace prefix of displayed path' {
  run assert_size_zero "${NOTZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is greater than 0 byte --' ]
  [ "${lines[1]}" == "path : ../dir/notzerobyte" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_size_zero() <file>: replace suffix of displayed path' {
  run assert_size_zero "${NOTZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is greater than 0 byte --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_size_zero() <file>: replace infix of displayed path' {
  run assert_size_zero "${NOTZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is greater than 0 byte --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
