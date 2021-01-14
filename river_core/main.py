# See LICENSE for details
"""Console script for river_core."""

import click

from river_core.rivercore import rivercore_clean, rivercore_compile, rivercore_generate
from river_core.__init__ import __version__


@click.group()
def cli():
    """ RiVer Core verification framework
        \b

        See LICENSE for details
        \b

        Use the --help flag with the command to learn more
        about the configuration options
    """


@click.version_option(version=__version__)
@click.option('--verbose',
              '-v',
              default='error',
              help='Set verbosity level for the framework')
@click.option('--suite', '-ts', default='', help='Suite name to remove')
@cli.command()  # @cli, not @click!
def clean(verbose, suite):
    """
    subcommand to clean generated programs.
    """
    rivercore_clean(verbose, suite)


@click.version_option(version=__version__)
@click.option('--verbose',
              '-v',
              default='error',
              help='Set verbosity level for the framework')
@click.option('--jobs',
              '-j',
              default=1,
              help='Number of jobs to use for generation')
@click.option('--suite',
              '-ts',
              default='',
              help='Suite name to generate programs')
@click.option('--filter', '-f', type=str, default='', help='Filter option')
@click.option('--seed', '-s', default='random', help='Seed value')
@click.option('--count',
              '-n',
              default=1,
              type=int,
              help='No. of tests per template')
@click.option('--norun', '-nr', is_flag='True', help='Only display test list')
@cli.command()  # @cli, not @click!
def generate(verbose, jobs, suite, filter, seed, count, norun):
    """
    subcommand to generate programs.
    """
    rivercore_generate(verbose, jobs, suite, filter, seed, count, norun)


@click.version_option(version=__version__)
@click.option('--verbose',
              '-v',
              default='error',
              help='Set verbosity level for the framework')
@click.option('--jobs',
              '-j',
              default=1,
              help='Number of jobs to use for compilation')
@click.option('--suite',
              '-ts',
              default='',
              help='Suite from which the programs are compiled')
@click.option('--filter', '-f', type=str, default='', help='Filter option')
@click.option('--seed', '-s', default='random', help='Seed value')
@click.option('--count',
              '-n',
              default=1,
              type=int,
              help='No. of tests per template')
@click.option('--norun', '-nr', is_flag='True', help='Only display test list')
@cli.command()  # @cli, not @click!
def compile(verbose, jobs, suite, filter, seed, count, norun):
    """
    subcommand to compile the generated programs.
    """
    rivercore_compile(verbose, jobs, suite, filter, seed, count, norun)


if __name__ == '__main__':
    cli()
