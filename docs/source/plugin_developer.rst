=======================
Developer Documentation
=======================

.. _test-file: https://gitlab.com/incoresemi/river-framework/core-verification/river_core/-/blob/dev/examples/sample-config.ini
This chapter will discuss about the nuances of the river_core framework and how to add more plugins or create customizations in the framework.


**Still work in progress**

Workflow of the framework
#########################

.. image:: _static/river_core.png
    :align: center
    :alt: riscof-flow

As the image shows initally the generate command generates test lists which can then be passed to the compilation subcommand that then runs the tests on reference and target plugins. Then after comparing this, the framework proceeds to create an HTML report of the same.


Plugin creation
###############

Plugin naming
-------------

The class for the plugin has to be `plugin_name`+`plugin`. Keeping all the plugins in lowercase.
