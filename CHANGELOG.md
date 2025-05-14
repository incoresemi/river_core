# CHANGELOG

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.9.6] - 2025-05-14
- bumped python version for CI job

## [1.9.5] - 2025-05-14
- removed unwanted modules in requirements.txt

## [1.9.4] - 2024-10-29
- adding default value of status variable

## [1.9.3] - 2024-08-30
- removed errcode check for diff

## [1.9.2] - 2024-08-24
- fixed compare_dump to conditionally compare commit dump sections

## [1.9.1] - 2024-08-20
- fixed compare_dump functions to take care of missing entries in dumps

## [1.9.0] - 2024-07-10
- added --comparestartpc to river_core compile api
- added river_core comparison command to perform log comparisons without compilation
- added a table to report.html displaying the number of tests from each generator 

## [1.8.0] - 2024-06-06
- added river_core enquire command
- added --timeout to the river_core compile api
- update to requirements to allow timeout of tests
- changed default timeout value in utils.py to 1800

## [1.7.0] - 2024-05-28
- parallelization of the log comparisons
- added --nproc to river_core compile api

## [1.6.0] - 2024-05-27
- smart-diff integration with river_core

## [1.5.0] - 2024-04-16
- test generator filter for generate phase is added

## [1.4.3] - 2024-04-16
- bug fixes; instruction count functionality added to self-checks

## [1.4.2] - 2024-01-18
- bug fixes pertaining to self-checking

## [1.4.1] - 2023-12-12
- count num of instructions executed per test and cummulative number

## [1.4.0] - 2023-04-25
- use riscv-config isa validator for checking the isa string

## [1.3.0] - 2023-04-24
- print the total number of tests generated in the test-list.yaml
- adding support for self checking tests

## [1.2.0] - 2022-05-23
- use unix `diff` for commit log comparison.
- explicit mechanism to disable logging in `utils.sys_command`
- print the total number of failed tests in log

## [1.1.1] - 2022-03-19
- fix return code out and err in sys\_command and run functions in utils

## [1.1.0] - 2022-02-26
- testlist schema to include ignore_lines to help rtl plugins to remove so many lines from the dumps before comparison - default to 4
- treat all paths to suite and dut/reg plugins as absolute
- do not update test_list.yaml instead create result_list.yaml and failed_list.yaml
- clean up html reports and log file diff in the html

## [1.0.3] - 2021-10-28
- update click version.

## [1.0.2] - 2021-09-29
- Fix paths in setup to ensure templates directory is copied while installing via pip.

## [1.0.1] - 2021-06-02
- fixed dependencies issues reported by dependabot
- removed usage of program-output in docs. Using in-line text itself.

## [1.0.0] - 2021-06-02
- Initial release of RiVer Core.
