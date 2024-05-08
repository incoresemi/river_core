# See LICENSE for details

#!/usr/bin/env python
"""The setup script."""
import os
from setuptools import setup, find_packages

# Base directory of package
here = os.path.abspath(os.path.dirname(__file__))

with open('README.rst') as readme_file:
    readme = readme_file.read()


def read_requires():
    with open(os.path.join(here, "river_core/requirements.txt"), "r") as reqfile:
        return reqfile.read().splitlines()


setup_requirements = []

test_requirements = []

setup(
    author="InCore Semiconductors Pvt. Ltd.; Tessolve",
    author_email='neelgala@incoresemi.com',
    python_requires='>=3.6',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
    ],
    description="RiVer Core Verification Framework",
    entry_points={
        'console_scripts': ['river_core=river_core.main:cli',],
    },
    install_requires=read_requires(),
    license="BSD-3-Clause",
    long_description=readme + '\n\n',
    include_package_data=True,
    keywords='river_core',
    name='river_core',
    packages=find_packages(),
    package_dir={'river_core': 'river_core/'},
    package_data={
        'river_core': [
            'requirements.txt', 'templates/setup/dut/*.py',
            'templates/setup/generator/*.py',
            'templates/setup/reference/*.py',
            'templates/style.css',
            'templates/report.html',
            'templates/coverage_report.html'
        ]
    },
    setup_requires=setup_requirements,
    test_suite='',
    tests_require=test_requirements,
    url=
    'https://github.com/incoresemi/river_core',
    version='1.5.0',
    zip_safe=False,
)
