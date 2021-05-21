.. _aapg:

AAPG
====
`Automated Assembly Program Generator [AAPG] <https://gitlab.com/shaktiproject/tools/aapg>`_ plugin is based on the tool developed by Team Shakti to generate random RISC-V programs to test RISC-V cores.

Ensure you have AAPG installed in your path.

Installation
------------
1. Install `AAPG`

    The easiest way to  install `aapg` is to use `pip`.

    .. code-block:: bash
        
        pip install aapg

    To stay up-to date with the latest developments and fixes you can use the development version.

    .. code-block:: bash
        
        git clone https://gitlab.com/shaktiproject/tools/aapg
        cd aapg
        python3 setup.py install

    This will install aapg on your path.

2. Clone the `aapg_plugin` from `river_core_plugins`

   The `aapg_plugin` can be found in the Generator plugins repo in the `river_core_plugins` repository.


    .. code-block:: bash
        
        git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core_plugins 
        git checkout dev
        cd generator_plugins/aapg_plugin/

Config.yaml options
-------------------
A YAML file is placed in the aapg plugin folder with the name `aapg_gen_config.yaml`.

- **global_config_path** ->  Path to the plugin directory, TBD
- **global_command** -> Command to generate files. i.e. `aapg gen`

- **templates** -> Ideally the test yamls for AAPG can be stored in a folder which can be then filtered via the filter option in the `config.ini` file.

.. code-block:: yaml

   # Preferred name scheme is given as an example
   templates:
      rv64imafdc:
         path: templates/chromite

Output
------

This plugin will generate a `test-list` containing all necessary information for the framework to compile and test code. 

This can be useful to share test cases across machines. In order to share the tests, one only needs to share the original finals and test-list which contains all necessary infomation about the tests run.

