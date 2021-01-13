# See LICENSE for details
"""Console script for river_core."""

import click

from river_core.rivercore import rivercore_clean, rivercore_compile, rivercore_generate 
from river_core.__init__ import __version__

@click.group()
def cli():
    pass 

@click.version_option(version=__version__)
@click.option('--verbose', '-v', default='error', help='Set verbose level for the framework')
@click.option('--suite','-ts', default='', help='Suite name to remove')
@cli.command()  # @cli, not @click!
def clean(verbose,suite):
    rivercore_clean(verbose,suite)

# @click.option('--generate','-g', is_flag='True', help='generate tests')
# @click.option('--compile','-c', default='', type=click.Path(), help='compile tests')
# @click.option('--clean','-c', is_flag='True', help='Clean builds')


@click.version_option(version=__version__)
@click.option('--verbose', '-v', default='error', help='Set verbose level for the framework')
@click.option('--jobs', '-j', default=1, help='Number of jobs to use for Generation')
@click.option('--suite','-ts', default='', help='Suite name to remove')
@click.option('--filter','-f', type=str, default= '', help='Filter option')
@click.option('--seed', '-s', default='random', help='Seed value')
@click.option('--count', '-n', default=1, type=int, help='No. of tests per template')
@click.option('--norun','-nr', is_flag='True', help='Only display test list')
@cli.command()  # @cli, not @click!
def generate(verbose, jobs, suite, filter, seed, count, norun):
    rivercore_generate(verbose, jobs, suite, filter, seed, count, norun)


@click.version_option(version=__version__)
@click.option('--verbose', '-v', default='error', help='Set verbose level for the framework')
@click.option('--jobs', '-j', default=1, help='Number of jobs to use for Generation')
@click.option('--suite','-ts', default='', help='Suite name to remove')
@click.option('--filter','-f', type=str, default= '', help='Filter option')
@click.option('--seed', '-s', default='random', help='Seed value')
@click.option('--count', '-n', default=1, type=int, help='No. of tests per template')
@click.option('--norun','-nr', is_flag='True', help='Only display test list')
@cli.command()  # @cli, not @click!
def compile(verbose, jobs, suite, filter, seed, count, norun):
    rivercore_compile(verbose, jobs, suite, filter, seed, count, norun)

if __name__ == '__main__':
    cli()