<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**bats-file/CHANGELOG.md Table Of Contents**

- [Change Log](#change-log)
  - [\[0.4.0\] - 2023-08-23](#%5C040%5C---2023-08-23)
    - [Added](#added)
    - [Fixed](#fixed)
  - [0.3.0 - 2018-10-28](#030---2018-10-28)
    - [Added 0.3.0](#added-030)
  - [[0.2.0] - 2016-12-07](#020---2016-12-07)
    - [Added 0.2.0](#added-020)
    - [Fixed 0.2.0](#fixed-020)
  - [0.1.0 - 2016-03-22](#010---2016-03-22)
    - [Added 0.1.0](#added-010)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## \[0.4.0\] - 2023-08-23

### Added

- add aliases for `assert_*_exist`**s** (#34, #43)
- CI: run shellcheck, fixed found issues (#51)
- `assert_file_contains`: print regex on error (#57)
- add `assert_file_not_contains` (#61)

### Fixed

- various links and typos in README.md (#28, #26, #45)
- migrated CI scripts to Github Actions (#42)
- make `temp_*` functions compatible with `setup_file` (#36)
- don't require `sudo` anymore for `assert_file_owner`/`assert_not_file_owner` (#38, #50)
- fixed internal unset variable errors with `set -u` (#33)
- make `temp_del` work even when contents are write protected (#31)
- parameter documentation for `assert_file_permissions` (#47)
- tests use `bats_load_library bats-support` (#48)
- fix `temp_make` template to work with Alpine's `mktemp` (#52)
- removed `temp.bash`'s executable bit (#55)
- use new `bats_sudo` helper to avoid running `sudo` as root/when not available (#53, 54)
- fix `assert_symlink_to` for temp files in OSX (#56)

## 0.3.0 - 2018-10-28

### Added 0.3.0

- Added assert_files_equal assert_files_not_equal functions!
- Added 2 test scripts for assert_files_equal assert_files_not_equal

## [0.2.0] - 2016-12-07

### Added 0.2.0

- Handling temporary directories with `temp_make()` and `temp_del()`

### Fixed 0.2.0

- Function comments listing path transformation variables incorrectly

## 0.1.0 - 2016-03-22

### Added 0.1.0

- Testing file existence with `assert_file_exist` and
  `assert_file_not_exist`
- `npm` support

[0.2.0]: https://github.com/bats-core/bats-file/compare/v0.1.0...v0.2.0
