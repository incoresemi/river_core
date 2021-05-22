.. _chromite_cadence:

Chromite [Cadence]
==================

This section will help you setup the `chromite_cadence` plugin.

.. include:: ./chromite.rst



Cadence Plugin Configuration
============================

1. Ensure you have setup `Cadence` in your path. Binaries used by this plugin:

   - `ncvlog`

   - `ncelab`

   - `imc`

.. note:: The user is advised to ensure all of the above binaries are accessible via the shell that will be running `RIVER CORE`.

2. Configure `chromite_verilator.py`


Configuring river_core.ini
----------------------------

Things to configure
^^^^^^^^^^^^^^^^^^^

- In `river_core.ini`, you will have to configure

  1. `src_dir` = Absolute paths to following directories, seperated by commas

    [0] - Verilog Dir [ending with `build/hw/verilog/`]

    [1] - BSC Path [ending with `lib/Verilog`]

    [2] - Wrapper path [ending with `chromite/bsvwrappers/common_lib`]

    An example:

    .. code-block:: bash

        # src dir
        # Verilog Dir
        # BSC Path
        # Wrapper path
        src_dir = /home/vagrant/core/chromite/build/hw/verilog/,/home/vagrant/tools/bsc/inst/lib/Verilog,/home/vagrant/core/chromite/bsvwrappers/common_lib


  2. `top_module` = The top most module for simulation

    .. code-block:: bash

        # Top Module for simulation
        top_module = mkTbSoc
