#!/usr/bin/env bats

load 'test_helper'
fixtures 'exist'

setup () {
# NOTE: TEST_FIXTURE_ROOT is assigned by BATS.
# shellcheck disable=SC2154
  python -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('${TEST_FIXTURE_ROOT}/dir/somesocket')"
}
teardown () {
    rm -f "${TEST_FIXTURE_ROOT}"/dir/somesocket
}

# Correctness
@test 'assert_socket_not_exists() <file>: returns 0 if <file> socket does not exists' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/file"
  run assert_socket_not_exists "${file}"
  [ "${status}" -eq 0 ]
  [ "${#lines[@]}" -eq 0 ]
}

@test 'assert_socket_not_exists() <file>: returns 1 and displays path if <file> socket exists, but it was expected to be absent' {
  local -r file="${TEST_FIXTURE_ROOT}/dir/somesocket"
  run assert_socket_not_exists "${file}"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- socket exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${file}" ]
  [ "${lines[2]}" == '--' ]
}

# Transforming path
@test 'assert_socket_not_exists() <file>: replace prefix of displayed path' {
  run assert_socket_not_exists "${TEST_FIXTURE_ROOT}/dir/somesocket"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- socket exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ../dir/somesocket" ]
  [ "${lines[2]}" == '--' ]
}

@test 'assert_socket_not_exists() <file>: replace suffix of displayed path' {
  run assert_socket_not_exists "${TEST_FIXTURE_ROOT}/dir/somesocket"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- socket exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/dir/.." ]
  [ "${lines[2]}" == '--' ]

}

@test 'assert_socket_not_exists() <file>: replace infix of displayed path' {
  run assert_socket_not_exists "${TEST_FIXTURE_ROOT}/dir/somesocket"
  [ "${status}" -eq 1 ]
  [ "${#lines[@]}" -eq 3 ]
  [ "${lines[0]}" == '-- socket exists, but it was expected to be absent --' ]
  [ "${lines[1]}" == "path : ${TEST_FIXTURE_ROOT}/../somesocket" ]
  [ "${lines[2]}" == '--' ]
}

