#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  touch "${TEST_FIXTURE_ROOT}"/dir/execfile "${TEST_FIXTURE_ROOT}"/dir/file
  chmod +x "${TEST_FIXTURE_ROOT}"/dir/execfile

}
teardown () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
    rm -f "${TEST_FIXTURE_ROOT}"/dir/execfile "${TEST_FIXTURE_ROOT}"/dir/file
}

# Correctness
@test 'assert_file_executable() <file>: returns 0 if <file> is executable' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/execfile"
  run assert_file_executable "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_file_executable() <file>: returns 1 and displays path if <file> is not executable' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_file_executable "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is not executable --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_file_executable() <file>: replace prefix of displayed path' {
  run assert_file_executable "${TEST_FIXTURE_ROOT}/nodir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is not executable --' ]
  [ "${lines[1]}" == "path : ../nodir" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_executable() <file>: replace suffix of displayed path' {
  run assert_file_executable "${TEST_FIXTURE_ROOT}/nodir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is not executable --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/nodir" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_file_executable() <file>: replace infix of displayed path' {
  run assert_file_executable "${TEST_FIXTURE_ROOT}/nodir"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- file is not executable --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/.." ]
  [ "${lines[2]}" == '--' ]
}
