# See LICENSE for details
"""Console script for river_core."""

import click

from river_core.rivercore import rivercore_clean, rivercore_compile, rivercore_generate
from river_core.__init__ import __version__


# Helper Classes for selecting config
# https://stackoverflow.com/questions/46440950/require-and-option-only-if-a-choice-is-made-when-using-click
class OptionRequiredIf(click.Option):
    """
    Option is required if the context has `option` set to `value`
    """

    def __init__(self, *a, **k):
        try:
            option = k.pop('option')
            value = k.pop('value')
        except KeyError:
            raise (KeyError("OptionRequiredIf needs the option and value "
                            "keywords arguments"))

        click.Option.__init__(self, *a, **k)
        self._option = option
        self._value = value

    def full_process_value(self, ctx, value):
        value = super(OptionRequiredIf, self).full_process_value(ctx, value)
        if value is None and ctx.params[self._option] == self._value:
            msg = 'Required if --{}={}'.format(self._option, self._value)
            raise click.MissingParameter(ctx=ctx, param=self, message=msg)
        return value


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
@click.option('-f',
              '--file_type',
              type=click.Choice(['test-list', 'config']),
              help='Type of config file to pass',
              required=True)
@click.option(
    '-c',
    '--config',
    type=click.Path(dir_okay=False, exists=True),
    help='Read option defaults from the specified INI file',
    show_default=True,
)
@click.option('--asm_dir',
              '-s',
              cls=OptionRequiredIf,
              option='file_type',
              value='config',
              type=click.Path(exists=True),
              help='ASM files to compile\n Only if you have .ini file')
@cli.command()
def compile(config, asm_dir, file_type, verbosity):
    '''
        subcommand to compile generated programs.
    '''
    rivercore_compile(config, asm_dir, file_type, verbosity)


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
