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

        Is your config/config.ini ready? Configure RiVer Core there!
    """

@click.version_option(version=__version__)
@click.option(
    '-c', '--config',
    type         = click.Path(dir_okay=False),
    help         = 'Read option defaults from the specified INI file',
    show_default = True,
)
@click.option('--outputdir',
              '-o',
              default='',
              required=True,
              type=click.Path(),
              help='Output Dir <!>')
@cli.command()
def clean(config, outputdir):
    """
    subcommand to clean generated programs.
    """
    rivercore_clean(config, outputdir)

@click.version_option(version=__version__)
@click.option(
    '-c', '--config',
    type         = click.Path(dir_okay=False),
    help         = 'Read option defaults from the specified INI file',
    show_default = True,
)
@click.option('--outputdir',
              '-o',
              default='',
              required=True,
              type=click.Path(),
              help='Output Dir <!>')
@cli.command()
def compile(config, outputdir):
    """
    subcommand to compile generated programs.
    """
    rivercore_compile(config, outputdir)

@click.version_option(version=__version__)
@click.option(
    '-c', '--config',
    type         = click.Path(dir_okay=False),
    help         = 'Read option defaults from the specified INI file',
    show_default = True,
)
@click.option('--outputdir',
              '-o',
              default='',
              required=True,
              type=click.Path(),
              help='Output Dir <!>')
@cli.command()
def generate(config, outputdir):
    """
    subcommand to generate programs.
    """
    rivercore_generate(config, outputdir)

if __name__ == '__main__':
    cli()
