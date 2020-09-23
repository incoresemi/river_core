# See LICENSE for details
"""Console script for river_core."""

import click

from river_core.rivercore import rivercore
from river_core.__init__ import __version__

@click.command()
@click.version_option(version=__version__)
@click.option('--verbose', '-v', default='error', help='Set verbose level')
@click.option('--jobs', '-j', default=1, help='No of jobs')
@click.option('--dir', '-d', default='', type=click.Path(), help='Work directory path')
@click.option('--env', '-e', default='', help='Env File Path')
@click.option('--suite','-ts', default='', help='Suite name')
@click.option('--generate','-g', is_flag='True', help='generate tests')
@click.option('--compile','-c', default='', type=click.Path(), help='compile tests')
@click.option('--clean','-c', is_flag='True', help='Clean builds')
@click.option('--seed', '-s', default='random', help='Seed value')
@click.option('--count', '-n', default=1, type=int, help='No. of tests per template')
@click.option('--norun','-nr', is_flag='True', help='Only display test list')
@click.option('--filter','-f', type=str, default= '', help='Filter option')
def cli(verbose, dir, env, jobs, suite, generate, compile, clean, filter, seed, count, norun):
    rivercore(verbose, dir, env, jobs, suite, generate, compile, clean, filter, seed, count, norun)

if __name__ == '__main__':
    cli()
