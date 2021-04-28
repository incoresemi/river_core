# See LICENSE for details
"""Console script for river_core."""

import click
import os

from river_core.log import *
from river_core.rivercore import rivercore_clean, rivercore_compile, rivercore_generate, rivercore_merge
from river_core.__init__ import __version__


def check_config():
    """ Checks if 
    1. ~/river_core.ini
    2. (pwd)/river_core.ini exists """
    if os.path.exists(os.path.expanduser('~/river_core.ini')):
        logger.info('Loading config from ~/river_core.ini')
        return '~/river_core.ini'
    elif os.path.isfile(str(os.getcwd()) + '/river_core.ini'):
        logger.info('Loading config from current directory')
        return str(os.getcwd()) + '/river_core.ini'
    else:
        logger.error("Couldn't find config file anywhere. Exiting")
        raise SystemExit


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
@click.option('-c',
              '--config',
              type=click.Path(dir_okay=False, exists=True),
              help='Read option defaults from the specified INI file',
              show_default=True)
@cli.command()
def clean(config, verbosity):
    '''
        subcommand to clean generated programs.
    '''
    if not config:
        config = check_config()
    rivercore_clean(config, verbosity)


@click.version_option(version=__version__)
@click.option('-v',
              '--verbosity',
              default='info',
              help='Set the verbosity level for the framework')
@click.option('-t',
              '--test_list',
              type=click.Path(dir_okay=False, exists=True),
              help='Test List file to pass',
              required=True)
# required=True)
@click.option('-c',
              '--config',
              type=click.Path(dir_okay=False, exists=True),
              help='Read option defaults from the specified INI file')
@click.option('--coverage', is_flag=True)
@cli.command()
def compile(config, test_list, coverage, verbosity):
    '''
        subcommand to compile generated programs.
    '''
    if not config:
        config = check_config()
    rivercore_compile(config, test_list, coverage, verbosity)


@click.version_option(version=__version__)
@click.option('-v',
              '--verbosity',
              default='info',
              help='Set the verbosity level for the framework')
@click.option('-c',
              '--config',
              type=click.Path(dir_okay=False, exists=True),
              help='Read option defaults from the specified INI file',
              show_default=True)
@cli.command()
def generate(config, verbosity):
    """
    subcommand to generate programs.
    """
    if not config:
        config = check_config()
    rivercore_generate(config, verbosity)


@click.version_option(version=__version__)
@click.option('-c',
              '--config',
              type=click.Path(dir_okay=False, exists=True),
              help='Read option defaults from the specified INI file',
              show_default=True)
@click.option('-v',
              '--verbosity',
              default='info',
              help='set the verbosity level for the framework')
@click.argument('db_files', nargs=-1, type=click.Path(exists=True))
@click.argument('output', nargs=1, type=click.Path())
@cli.command()
def merge(verbosity, db_files, output, config):
    """
    subcommand to merge coverage databases.
    """
    if not config:
        config = check_config()
    rivercore_merge(verbosity, db_files, output, config)


if __name__ == '__main__':
    cli()
