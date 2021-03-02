# See LICENSE for details
"""Console script for river_core."""

import click

from river_core.rivercore import rivercore_clean, rivercore_compile, rivercore_generate
from river_core.__init__ import __version__


@click.group()
@click.version_option(version=__version__)
def cli():
    """ RiVer Core verification framework
        \b

        See LICENSE for details
        \b

        Is your config.ini ready? Configure RiVer Core there!
    """


@click.version_option(version=__version__)
@click.option('-v',
              '--verbosity',
              default='info',
              help='Set the verbosity level for the framework')
@click.option(
    '-c',
    '--config',
    type=click.Path(dir_okay=False, exists=True),
    help='Read option defaults from the specified INI file',
    show_default=True,
)
@click.option('--output_dir',
              '-o',
              default='',
              required=True,
              type=click.Path(),
              help='Output Dir <!>')
@cli.command()
def clean(config, output_dir, verbosity):
    '''
        subcommand to clean generated programs.
    '''
    rivercore_clean(config, output_dir, verbosity)


@click.version_option(version=__version__)
@click.option('-v',
              '--verbosity',
              default='info',
              help='Set the verbosity level for the framework')
@click.option(
    '-t',
    '--test_list',
    type=click.Path(dir_okay=False, exists=True),
    help='Test List file to pass',
)
# required=True)
@click.option('-c',
              '--config',
              type=click.Path(dir_okay=False, exists=True),
              help='Read option defaults from the specified INI file',
              required=True)
@click.option('--output_dir',
              '-o',
              type=click.Path(exists=True),
              help='ASM files to compile')
@cli.command()
def compile(config, output_dir, test_list, verbosity):
    '''
        subcommand to compile generated programs.
    '''
    rivercore_compile(config, output_dir, test_list, verbosity)


@click.version_option(version=__version__)
@click.option('-v',
              '--verbosity',
              default='info',
              help='Set the verbosity level for the framework')
@click.option(
    '-c',
    '--config',
    type=click.Path(dir_okay=False, exists=True),
    help='Read option defaults from the specified INI file',
    show_default=True,
)
@click.option('--output_dir',
              '-o',
              default='',
              required=True,
              type=click.Path(),
              help='Output Dir <!>')
@cli.command()
def generate(config, output_dir, verbosity):
    """
    subcommand to generate programs.
    """
    rivercore_generate(config, output_dir, verbosity)


if __name__ == '__main__':
    cli()
