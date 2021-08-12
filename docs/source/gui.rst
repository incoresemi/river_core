.. See LICENSE.incore for details

.. _gui:

==============
RiVer Core GUI
==============

RiVer Core Framework comes with a Graphical User Interface. The GUI can be run by invoking

::

   river_core gui
   
-------------
Using the GUI
-------------

Initial Setup
-------------
   
If this is the **first time** you are invoking river_core with the gui, the gui will search the directory if a `config.ini` file is present. If the file is not present, the tool will create the same. You will see the following screen when the gui tries to create the `config.ini` file.

.. figure:: _static/_gui/gui_file_initialized_screen.png
   :align: center

This would have created a `config.ini` file with required entries in the directory from which you invoked the GUI. Clicking `OK` will close the GUI. You should Invoke the GUI again by running the `river_core gui` command.

.. note:: the GUI currently creates a file named `config.ini` in whatever directory it gets invoked from (even if a river_core config `.ini` file is present. This is being done because of certain issues we face with the ordering of sections within the .ini file. This will be fixed in coming updates.

Now, when you invoke river_core again after it creates its own config file, you will see the main page. 

.. figure:: _static/_gui/gui_main_page_default.png
   :align: center

The main window.

The window you see above is the main window of the GUI. This window will be used to generate and compile tests. 

When you are running GUI for the first time, it is necessary that you set-up river_core by specifying the paths, work directory, etc. similiar to the one mentioned in RiVer Core's `quickstart <https://river-core.readthedocs.io/en/stable/installation.html#setup-the-plugins>`_. 

To set-up river_core through the GUI, click on the `Setup` button you find on the main window. Once you click that, a new window titles `configure RiVer core` will show up. 

.. figure:: _static/_gui/gui_setup_page.png
   :align: center

The Setup page

.. note:: you can always update the `config.ini` file manually if you feel the GUI to be time intensive. But, **make sure you stick to the same ordering of sections in the ini file as it was created by the GUI**. Failing to do so, creates a stack overflow. This is a known issue. You can check the known issues section of this document to check if has been resolved. 


-------------
Known Issues:
-------------

IMPORTANT
---------
- **Closing the setup screen (with or wothout saving) rewrites the config file. This is a problem when the user just wants to update a single parameter!** 
- The resolution of the GUI window is fixed and not scalable. This will lead to issues in Hi-Resolution displays.

LOWER PRIORITY
--------------
- Path to the config file can be passed instead of creating a config file everytime.
- requires restart (after all operations involving writing to config file)
- reordering the config file parameters ends in a stack overflow.
- The terminal window pastes in bulk.
