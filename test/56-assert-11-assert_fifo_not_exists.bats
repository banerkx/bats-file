#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  mkfifo "${TEST_FIXTURE_ROOT}"/dir/testpipe
}
teardown () {
    rm -f "${TEST_FIXTURE_ROOT}"/dir/testpipe
}


# Correctness
@test 'assert_fifo_not_exists() <file>: returns 0 if <file> fifo does not exists' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_fifo_not_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_fifo_not_exists() <file>: returns 1 and displays path if <file> fifo exists, but it was expected to be absent' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/testpipe"
  run assert_fifo_not_exists "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- fifo exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_fifo_not_exists() <file>: replace prefix of displayed path' {
  run assert_fifo_not_exists "${TEST_FIXTURE_ROOT}/dir/testpipe"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- fifo exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ../dir/testpipe" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_fifo_not_exists() <file>: replace suffix of displayed path' {
  run assert_fifo_not_exists "${TEST_FIXTURE_ROOT}/dir/testpipe"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- fifo exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/dir/.." ]
  [ "${lines[2]}" == '--' ]

}

@test 'assert_fifo_not_exists() <file>: replace infix of displayed path' {
  run assert_fifo_not_exists "${TEST_FIXTURE_ROOT}/dir/testpipe"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- fifo exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/../testpipe" ]
  [ "${lines[2]}" == '--' ]
}

