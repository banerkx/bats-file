#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  readonly ZERO_FILE="${TEST_FIXTURE_ROOT}/dir/zerobyte"
  touch "${ZERO_FILE}"
  readonly NOTZERO_FILE="${TEST_FIXTURE_ROOT}/dir/notzerobyte"
  echo "not empty" > "${NOTZERO_FILE}"
}

teardown () {  
  rm -f "${ZERO_FILE}" "${NOTZERO_FILE}"
}


# Correctness
@test 'assert_size_not_zero() <file>: returns 0 if <file> file is greater than 0 byte' {
  run assert_size_not_zero "${NOTZERO_FILE}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_size_not_zero() <file>: returns 1 and displays path if <file> file is 0 byte, but it was expected not to be' {
  run assert_size_not_zero "${ZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is 0 byte, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ${ZERO_FILE}" ]
  [ "${lines[2]}" == '--' ]
}


# Transforming path
@test 'assert_size_not_zero() <file>: replace prefix of displayed path' {
  run assert_size_not_zero "${ZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is 0 byte, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ../dir/zerobyte" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_size_not_zero() <file>: replace suffix of displayed path' {
  run assert_size_not_zero "${ZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is 0 byte, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_size_not_zero() <file>: replace infix of displayed path' {
  run assert_size_not_zero "${ZERO_FILE}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is 0 byte, but it was expected not to be --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
