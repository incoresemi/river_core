AAPG
====

`Automated Assembly Program Generator [AAPG] <https://gitlab.com/shaktiproject/tools/aapg>`_ plugin 
is based on the tool developed by Team Shakti to generate random RISC-V Assembly programs to test RISC-V cores.

Installation
------------
1. Install `AAPG`


   The easiest way to  install `aapg` is to use `pip`.

   .. code-block:: console
       
       $ pip install aapg

   To stay up-to date with the latest developments and fixes you can use the development version.

   .. code-block:: console
       
       $ git clone https://gitlab.com/shaktiproject/tools/aapg
       $ cd aapg
       $ python3 setup.py install

   This will install aapg on your path.

2. Download the pre-built ``aapg_plugin`` from `river_core_plugins`

   The ``aapg_plugin`` can be found in the Generator plugins repo in the ``river_core_plugins`` repository.

   .. code-block:: console
       
       $ git clone https://gitlab.com/incoresemi/river-framework/core-verification/river_core_plugins 
       $ cd generator_plugins/aapg_plugin/

Configuring the Plugin
----------------------

A YAML file is placed in the aapg plugin folder with the name ``aapg_gen_config.yaml``.

- **global_config_path** ->  Path to the plugin directory, TBD
- **global_command** -> Command to generate files. i.e. ``aapg gen``

- **templates** -> Ideally the test yamls for AAPG can be stored in a folder which can be then filtered via the filter option in the ``config.ini`` file.

.. code-block:: yaml

   # Preferred name scheme is given as an example
   templates:
      rv64imafdc:
         path: templates/chromite

Output from the plugin
----------------------

The gen hook of the plugin must return a dictionary of the test and their attributes as defined by
the :ref:`Test List Format <testlist>`.

Instance in ``config.ini``
--------------------------

To use AAPG in the config.ini the following template can be followed:

.. code-block:: ini

   path_to_suite = ~/river_core_plugins/generator_plugins
   generator = aapg

   [aapg]
   # Number of jobs to use to generate the tests
   jobs = 8
   # Filter for your tests to only use config file whose name matches the regex rv64imafdc_hazards_s
   filter = rv64imafdc_hazards_s
   seed = random
   # number of tests per selected config file
   count = 2
   # path to any gen_config yaml which can be used by the AAPG plugin as described above.
   config_yaml = /scratch/git-repo/incoresemi/river-framework/core-verification/river_core_plugins/generator_plugins/aapg_plugin/aapg_gen_config.yaml

.. note:: one can maintain multiple \*_gen_config.yaml files and simple point to them in the main
   config.ini to change configurations. 
