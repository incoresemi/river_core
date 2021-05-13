=======================
Developer Documentation
=======================

.. _test-file: https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/blob/dev/examples/sample-config.ini
This chapter will discuss about the nuances of the river_core framework and how to add more plugins or create customizations in the framework.


Plugin Development
##################

To facilitate a plugin based approach, we use the `Pluggy Framework <https://pluggy.readthedocs.io/en/latest/index.html>`_.
And to do all the low-level work (command generation, running commands) we use the `Pytest Framework <https://docs.pytest.org/en/6.2.x/index.html>`_ in combination with the Pluggy framework.
It also is helpful as it provides with detailed HTML reports.

As explained in the :ref:`Overview <overview>`, the plugins are broadly classified into Generator, DuT (Device Under Test) and Reference Plugins.

To re-iterate the above things in short:

- **Generator plugins**:
  These plugins are wrappers aroung existing Random Code Generator tools that generate random ASM files for a design to run. Some of the common examples include:

  + AAPG
  + Torture
  + Microtesk

- **DuT plugins**:

  These Plugins help in running the above generated tests on a design and compiler that you want. Some of the common compiler plugins include:

  + Verilator
  + Questa
  + Cadence

  Supported cores at the moment:

    + Chromite
    + Your design :)

- **Reference Plugins** run the above generated tests on a golden standard. Some of the common examples include:

  + Spike
  + SAIL


Example Plugin Directory
^^^^^^^^^^^^^^^^^^^^^^^^
Common Files
""""""""""""

+ ``{name}_plugin.py`` the main Python file that is loaded when the Plugin is loaded into RiVer Core.
+ ``conftest.py`` config file for the Pytest framework
+ ``gen_framework.py`` main file which will be containing the pytest parameters and commands to execute.
+ ``README.md`` README for the plugin
+ ``__init__.py`` Standard __init__ file for importing packages

Generator Plugins
"""""""""""""""""
Taking the example of the ``AAPG`` plugin:

.. code-block:: bash

        ├── aapg_gen_config.yaml
        ├── aapg_plugin.py
        ├── conftest.py
        ├── gen_framework.py
        ├── README.md
        ├── __init__.py
        └── templates

+ ``aapg_gen_config.yaml`` contains the configuration specific to the AAPG plugin, config.yaml path and the command to run etc.
+ ``templates`` AAPG specific templates for generator YAMLs


Device Under Test Plugins
"""""""""""""""""""""""""
Taking an example of the ``Chromite Verilator`` plugin:

.. code-block:: bash

    ├── boot
    │   ├── boot.hex
    │   ├── chromite.dtb
    │   ├── chromite.dts
    │   ├── config.chromite
    │   └── Makefile
    ├── chromite_verilator_plugin.py
    ├── conftest.py
    ├── gen_framework.py
    ├── __init__.py
    └── README.rst

+ ``boot`` directory contains files related to ``Chromite``
+ ``sim_main.cpp`` here contains the configuration related to Verilator.

Reference Plugins
"""""""""""""""""
Taking an example of the ``Spike`` plugin:

.. code-block:: bash

    ├── conftest.py
    ├── gen_framework.py
    ├── __init__.py
    ├── README.md
    └── spike_plugin.py


Plugin API
----------
This topic will explain some of the APIs available for various plugins

Generator Plugins
^^^^^^^^^^^^^^^^^

DuT Plugins
^^^^^^^^^^^


Reference Plugins
^^^^^^^^^^^^^^^^^


Things to look at while designing a custom plugin
-------------------------------------------------

Generator Plugins
^^^^^^^^^^^^^^^^^


DuT Plugins
^^^^^^^^^^^


Reference Plugins
^^^^^^^^^^^^^^^^^



Plugin naming
-------------

The class for the plugin has to be `plugin_name`+`plugin`. Keeping all the plugins in lowercase.
