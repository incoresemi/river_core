# CHANGELOG

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
