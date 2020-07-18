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
@click.option('--generate','-g', is_flag='True', help='generate tests')
@click.option('--compile','-c', is_flag='True', help='compile tests')
@click.option('--clean','-c', is_flag='True', help='Clean builds')
@click.option('--simenv','-s', default='simenv.yaml', type=click.File('r'), help='Repo list to be cloned')
def cli(verbose, dir, jobs, generate, compile, clean, simenv):
    rivercore(verbose, dir, jobs, generate, compile, clean, simenv)

if __name__ == '__main__':
    cli()
