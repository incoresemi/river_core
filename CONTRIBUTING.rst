.. See LICENSE for details

.. highlight:: shell

============
Contributing
============

Contributions are welcome, and they are greatly appreciated and credit will always be given.

You can contribute in many ways:

Types of Contributions
----------------------

Report Bugs
~~~~~~~~~~~

Report bugs at https://github.com/incoresemi/river_core/issues.

Submit Feedback
~~~~~~~~~~~~~~~

The best way to send feedback is to file an issue at https://github.com/incoresemi/river_core/issues.

If you are proposing a feature:

* Explain in detail how it would work.
* Keep the scope as narrow as possible, to make it easier to implement.
* Remember that this is a volunteer-driven project, and that contributions
  are welcome :)

Get Started!
------------

Ready to contribute? Here's how to set up `river_core` for local development.

1. Fork the `river_core` repo on Github.
2. Clone your fork locally::

    $ git clone https://github.com/<your-username>/river_core.git

3. Create an issue and WIP pull request that creates a working branch for you

    $ git checkout -b name-of-your-bugfix-or-feature

   Now you can make your changes locally.

4. Commit your changes and push your branch to Github::

    $ git add .
    $ git commit -m "Your detailed description of your changes."
    $ git push origin name-of-your-bugfix-or-feature

5. Submit a pull request through the Github website.

Pull Request Guidelines
-----------------------

Before you submit a pull request, check that it meets these guidelines:

1. If the pull request adds functionality, the docs should be updated.
2. The pull request should work for Python 3.6, 3.7 and 3.8, and for PyPy. 
   and make sure that the tests pass for all supported Python versions.

Deploying
---------

A reminder for the maintainers on how to deploy.
Make sure all your changes are committed.
Then run::

$ bumpversion --allow-dirty --config-file setup.cfg patch  # possible: major / minor / patch
$ git push origin name-of-your-branch

