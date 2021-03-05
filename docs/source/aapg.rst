AAPG
====

.. _AAPG: https://gitlab.com/shaktiproject/tools/aapg

`AAPG`_ plugin is based on the tool developed by Team Shakti to generate random RISC-V programs to test RISC-V cores.

Ensure you have AAPG installed in your path.

Config.yaml options
===================
A YAML file is placed in the aapg plugin folder with the name `aapg_gen_config.yaml`.

- **global_config_path** ->  Path to the plugin directory, TBD
- **global_command** -> Command to generate files. i.e. `aapg gen`

- **templates** -> Ideally the test yamls for AAPG can be stored in a folder which can be then filtered via the filter option in the `config.ini` file.

.. code-block:: yaml

   # Preferred name scheme is given as an example
   templates:
      rv64imafdc:
         path: templates/chromite
