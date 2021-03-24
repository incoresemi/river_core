**RiVer Core** : RISC-V Core Verification Framework 
###################################################################################


Latest documentation of river_core :

  * `river_core.pdf  <https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/jobs/artifacts/master/raw/river_core.pdf?job=doc>`_


Installation
------------

Ideally install the package using pip editable install::

    cd river_core/
    pip install --editable .

Clone plugins from `river_core_plugins` directory

Usage
-----

To generate test programs use::

  river_core generate -c <path to config> -v <level>
  // Sample config is provided in the examples/config.ini
  river_core --help // For more info

This generates a test list which can then be used for compliations

To compile and compare programs use::

  river_core compile -c <path to config> -t <path to test_list> -v debug   // Please ensure that the paths end with a slash.

Will generate an HTML report showing the status and linking other reports, and short summary of the log comparison 

Config
------

`[default]` node contains the global variables common to all plugins.
`[name]` node will contain variables pertaining to the `name` plugin.

Check the examples/sample-config.ini to understand more:

Things to change 
^^^^^^^^^^^^^^^^

* [river_core]
    1.  *path_to_target* -> Update to the path containing your target plugins 
    2.  *path_to_ref* -> Update to the path containing your reference plugins 
    3.  *path_to_suite* -> Update to the path containing your generator plugins 
    4.  *open_browser* -> To open final report directly in browser
    5.  *space_saver* -> Remove excess files if the test has passed
* [coverage]
    [WIP]
    1.  *code* -> Boolean value determines if enabled or not
    2.  *functional* -> Boolean value determines if enabled or not

* [plugins]
    [WIP]
    1.  *jobs* -> Number of jobs to run the plugin with. (Use $(nproc))
    2.  *filter* -> Filter based on pytest's test filter
        More info here https://docs.pytest.org/en/latest/example/markers.html#using-k-expr-to-select-tests-based-on-their-name
    3.  *seed* -> Seed to use for test
    4.  *count* -> Number of times to run the test
