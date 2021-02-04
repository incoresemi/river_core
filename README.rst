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

  river_core generate -o <output_dir for programs> -c <path to config>
  // Sample config is provided in the config/config.ini
  river_core --help // For more info

Config
------
*In the process of being determined*

`[default]` node contains the global variables common to all plugins.
`[name]` node will contain variables pertaining to the `name` plugin.
