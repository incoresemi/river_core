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
    with open(os.path.join(here, "requirements.txt"),"r") as reqfile:
        return reqfile.read().splitlines()

setup_requirements = [ ]

test_requirements = [ ]

setup(
    author="InCore Semiconductors Pvt. Ltd.",
    author_email='incorebot@gmail.com',
    python_requires='>=3.5',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
    ],
    description="RISC-V Core Verification Framework",
    entry_points={
        'console_scripts': [
            'river_core=river_core.main:cli',
        ],
    },
    install_requires=read_requires(),
    license="MIT license",
    long_description=readme + '\n\n',
    include_package_data=True,
    keywords='river_core',
    name='river_core',
    packages=find_packages(),
    package_dir={'river_core': 'river_core/'},
    package_data={
        'river_core': [
            'requirements.txt',
            ]
        },
    setup_requires=setup_requirements,
    test_suite='tests',
    tests_require=test_requirements,
    url='https://gitlab.com/incoresemi/river-framework/core-verification/river_core',
    version='0.1.0',
    zip_safe=False,
)
