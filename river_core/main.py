# See LICENSE for details
"""Console script for river_core."""

import click

from river_core.rivercore import rivercore
from river_core.__init__ import __version__

@click.command()
@click.version_option(version=__version__)
@click.option('--verbose', '-v', default='error', help='Set verbose level')
@click.option('--dir', '-d', default='', type=click.Path(), help='Work directory path')
@click.option('--clean','-c', is_flag='True', help='Clean builds')
def cli(verbose, dir, clean):
    rivercore(verbose, dir, clean)

if __name__ == '__main__':
    cli()
