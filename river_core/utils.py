# See LICENSE for details
"""Provide Utility functions for river_core"""
import sys
import os
import subprocess
import shlex
from river_core.log import logger
import distutils.util
import ruamel
import signal
from ruamel.yaml import YAML
from threading import Timer
import pathlib
import difflib
import shlex
import riscv_config.isa_validator as isa_val

yaml = YAML(typ="safe")
yaml.default_flow_style = False
yaml.allow_unicode = True

def self_check(file1):
  '''
  Function to check if all values in the signature are 0s to indicate a pass,
  else the test has failed.
  '''
  result = 'Passed'
  rout = ''
  with open(file1,'r') as f:
    for lineno, line in enumerate(f):
      line_val = f'0x{line}'
      if int(line_val,0) != 0:
        result = 'Failed'
        rout = f'\nLine:{lineno} has a non-zero value indicating a fail'
  return result, rout

def get_file_size(file):
    '''
    Function to give the number of lines
    '''
    with open(f'{file}','r') as fd:
      rcount = len(fd.readlines())
    return rcount

def compare_signature(file1, file2):
    '''
        Function to check whether two signature files are equivalent. This funcion uses the
        :py:mod:`difflib` to perform the comparision and obtain the difference.
        :param file1: The path to the first signature.
        :param file2: The path to the second signature.
        :type file1: str
        :type file2: str
        :return: A string indicating whether the test "Passed" (if files are the same)
            or "Failed" (if the files are different) and the diff of the files.
    '''
    if not os.path.exists(file1) :
        logger.error('Signature file : ' + file1 + ' does not exist')
        raise SystemExit(1)
    cmd = f'diff -iw {file1} {file2}'
    errcode, rout, rerr = sys_command(cmd, logging=False)
    if errcode != 0:
        status = 'Failed'
    else:
        status = 'Passed'
    with open(f'{file1}','r') as fd:
      rcount = len(fd.readlines())


#    file1_lines = open(file1, "r").readlines()
#    file2_lines = open(file2, "r").readlines()
#    res = ("".join(
#        difflib.unified_diff(file1_lines,file2_lines, file1, file2))).strip()
#    if res == "":
#        if len(file1_lines)==0:
#            return 'Failed', '---- \nBoth FIles empty\n'
#        else:
#            status = 'Passed'
#    else:
#        status = 'Failed'
#
#        error_report = '\nFile1 Path:{0}\nFile2 Path:{1}\nMatch  Line#    File1    File2\n'.format(
#                            file1,file2)
#        fmt = "{0:5s} {1:6d} {2:100s} {3:100s}\n"
#        prev = ''
#        include = False
#        for lnum,lines in enumerate(zip(file1_lines,file2_lines)):
#            if lines[0] != lines[1]:
#                include = True
#                if not include:
#                    error_report += prev
#                rline = fmt.format("*",lnum,lines[0].strip(),lines[1].strip())
#                error_report += rline
#                prev = rline
#            elif include:
#                rline = fmt.format("",lnum,lines[0].strip(),lines[1].strip())
#                error_report += rline
#                include = False
#                prev = rline
##        res = error_report
    return status, rout, rcount

def str_2_bool(string):
    """
        Simple String to Bool conversion
        
        :param string: A string to convert

        :returns: Boolean value (True or False)
        
        :rtype: bool
    """
    return bool(distutils.util.strtobool(string))


def save_yaml(data, out_file):
    """
        Save a dict to a file

        :param data: Input data 

        :param out_file: Full/Abs path of Output file 

        :type data: dict 

        :type out_file: str 
    """
    try:
        with open(out_file, 'w') as outfile:
            ruamel.yaml.dump(data, outfile)
    except FileNotFoundError:
        logger.error("File doesn't exist")


def load_yaml(input_yaml):
    """
        Save a dict to a file

        :param input_yaml: YAML file to read 

        :type input_yaml: str 

        :returns: The loaded yaml 

        :rtype: dict
    """
    try:
        with open(input_yaml, "r") as file:
            return dict(yaml.load(file))
    except ruamel.yaml.constructor.DuplicateKeyError as msg:
        raise SystemExit(1)


def check_isa(isa):
    (ext_list, err, err_list) = isa_val.get_extension_list(isa)
    if err:
      for e in err_list:
        logger.error(e)
      raise SystemExit(1)

def sys_command(command, timeout=240, logging=True):
    '''
        Wrapper function to run shell commands with a timeout.
        Uses :py:mod:`subprocess`, :py:mod:`shlex`, :py:mod:`os`
        to ensure proper termination on timeout

        :param command: The shell command to run.

        :param timeout: The value after which the framework exits. Default set to configured to 240 seconds

        :type command: list

        :type timeout: int

        :returns: Error Code (int) ; STDOUT ; STDERR

        :rtype: list
    '''
    logger.debug('$ timeout={1} {0} '.format(' '.join(shlex.split(command)),
                                               timeout))
    out = ''
    err = ''
    with subprocess.Popen(shlex.split(command),
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE,
                          start_new_session=True) as process:
        try:
            out, err = process.communicate(timeout=timeout)
            out = out.rstrip()
            err = err.rstrip()
        except subprocess.TimeoutExpired:
            process.kill()
            out, err = process.communicate()
            out = out.rstrip()
            err = err.rstrip()
            pgrp = os.getpgid(process.pid)
            os.killpg(pgrp, signal.SIGTERM)
            logger.error('Process Killed')
            logger.error("Command did not exit within {0} seconds: {1}".format(timeout,command))
            return 1, "GuruMeditation", "TimeoutExpired"
        rout = ''
        rerr = ''
        cwd = os.getcwd()
        try:
            fmt = sys.stdout.encoding if sys.stdout.encoding is not None else 'utf-8'
            rout = out.decode(fmt)
            if out:
                if process.returncode != 0 and logging:
                    logger.error(out.decode(fmt))
                elif logging:
                    logger.debug(out.decode(fmt))
        except UnicodeError:
            if logging:
                logger.warning("Unable to decode STDOUT for launched subprocess. Output written to:"+
                    cwd+"/stdout.log")
            rout = "Unable to decode STDOUT for launched subprocess. Output written to:"+ cwd+"/stdout.log"
            with open(cwd+"/stdout.log","wb") as f:
                f.write(out)
        try:
            fmt = sys.stderr.encoding if sys.stdout.encoding is not None else 'utf-8'
            rerr = err.decode(fmt)
            if err:
                if process.returncode != 0 and logging:
                    logger.error(err.decode(fmt))
                elif logging:
                    logger.debug(err.decode(fmt))
        except UnicodeError:
            if logging:
                logger.warning("Unable to decode STDERR for launched subprocess. Output written to:"+
                    cwd+"/stderr.log")
            rerr = "Unable to decode STDERR for launched subprocess. Output written to:"+ cwd+"/stderr.log"
            with open(cwd+"/stderr.log","wb") as f:
                f.write(out)
    return process.returncode, rout, rerr


def sys_command_file(command, filename, timeout=500):
    '''
        Wrapper function to run shell commands with a timeout which involve operating with a file.
        Uses :py:mod:`subprocess`, :py:mod:`shlex`, :py:mod:`os`
        to ensure proper termination on timeout

        :param command: The shell command to run.

        :param filename: File on which the operation is performed. 

        :param timeout: The value after which the framework exits.
        Default set to configured to 240 seconds

        :type command: list

        :type filename: str 

        :type timeout: int

        :returns: Error Code (int) ; None ; None 

        :rtype: list

    '''
    cmd = command.split(' ')
    cmd = [x.strip(' ') for x in cmd]
    cmd = [i for i in cmd if i]
    logger.warning('$ {0} > {1}'.format(' '.join(cmd), filename))
    fp = open(filename, 'w')
    x = subprocess.Popen(cmd, stdout=fp, stderr=fp)
    timer = Timer(timeout, x.kill)
    try:
        timer.start()
        stdout, stderr = x.communicate()
    finally:
        timer.cancel()

    fp.close()

    return (x.returncode, None, None)


class makeUtil():
    """
    Utility for ease of use of make commands like `make` and `pmake`.
    Supports automatic addition and execution of targets. Uses the class
    :py:class:`shellCommand` to execute commands.
    """

    def __init__(self, makeCommand='make', makefilePath="./Makefile"):
        """ Constructor.

        :param makeCommand: The variant of make to be used with optional arguments.
            Ex - `pmake -j 8`

        :type makeCommand: str

        :param makefilePath: The path to the makefile to be used.

        :type makefilePath: str

        """
        self.makeCommand = makeCommand
        self.makefilePath = makefilePath
        makefile = open(makefilePath, 'w')
        makefile.close()
        self.targets = []

    def add_target(self, command, tname=""):
        """
        Function to add a target to the makefile.

        :param command: The command to be executed when the target is run.

        :type command: str

        :param tname: The name of the target to be used. If not specified, TARGET<num> is used as the name.

        :type tname: str
        """
        if tname == "":
            tname = "TARGET" + str(len(self.targets))
        with open(self.makefilePath, "a") as makefile:
            makefile.write("\n\n.PHONY : " + tname + "\n" + tname + " :\n\t" +
                           command.replace("\n", "\n\t"))
            self.targets.append(tname)

    def execute_target(self, tname, cwd="./"):
        """
        Function to execute a particular target only.

        :param tname: Name of the target to execute.

        :type tname: str

        :param cwd: The working directory to be set while executing the make command.

        :type cwd: str

        :raise AssertionError: If target name is not present in the list of defined targets.

        """
        assert tname in self.targets, "Target does not exist."
        return shellCommand(self.makeCommand + " -f " + self.makefilePath +
                            " " + tname).run(cwd=cwd)

    def execute_all(self, cwd):
        """
        Function to execute all the defined targets.

        :param cwd: The working directory to be set while executing the make command.

        :type cwd: str

        """
        return shellCommand(self.makeCommand + " -f " + self.makefilePath +
                            " " + " ".join(self.targets)).run(cwd=cwd)


class Command():
    """
    Class for command build which is supported
    by :py:mod:`suprocess` module. Supports automatic
    conversion of :py:class:`pathlib.Path` instances to
    valid format for :py:mod:`subprocess` functions.
    """

    def __init__(self, *args, pathstyle='auto', ensure_absolute_paths=False):
        """Constructor.

        :param pathstyle: Determine the path style when adding instance of
            :py:class:`pathlib.Path`. Path style determines the slash type
            which separates the path components. If pathstyle is `auto`, then
            on Windows backslashes are used and on Linux forward slashes are used.
            When backslashes should be prevented on all systems, the pathstyle
            should be `posix`. No other values are allowed.

        :param ensure_absolute_paths: If true, then any passed path will be
            converted to absolute path.

        :param args: Initial command.

        :type pathstyle: str

        :type ensure_absolute_paths: bool
        """
        self.ensure_absolute_paths = ensure_absolute_paths
        self.pathstyle = pathstyle
        self.args = []

        for arg in args:
            self.append(arg)

    def append(self, arg):
        """Add new argument to command.

        :param arg: Argument to be added. It may be list, tuple,
            :py:class:`Command` instance or any instance which
            supports :py:func:`str`.
        """
        to_add = []
        if type(arg) is list:
            to_add = arg
        elif type(arg) is tuple:
            to_add = list(arg)
        elif isinstance(arg, type(self)):
            to_add = arg.args
        elif isinstance(arg, str) and not self._is_shell_command():
            to_add = shlex.split(arg)
        else:
            # any object which will be converted into str.
            to_add.append(arg)

        # Convert all arguments to its string representation.
        # pathlib.Path instances
        to_add = [
            self._path2str(el) if isinstance(el, pathlib.Path) else str(el)
            for el in to_add
        ]
        self.args.extend(to_add)

    def clear(self):
        """Clear arguments."""
        self.args = []

    def run(self, **kwargs):
        """Execute the current command.
        Uses :py:class:`subprocess.Popen` to execute the command.
        :return: The return code of the process     .
        :raise subprocess.CalledProcessError: If `check` is set
                to true in `kwargs` and the process returns
                non-zero value.
        """
        kwargs.setdefault('shell', self._is_shell_command())
        kwargs.setdefault('timeout', 300)
        cwd = self._path2str(kwargs.get(
            'cwd')) if not kwargs.get('cwd') is None else self._path2str(
                os.getcwd())
        kwargs.update({'cwd': cwd})
        process_args = dict(kwargs)
        timeout = kwargs['timeout']
        del process_args['timeout']
        in_val = None
        if 'input' in kwargs:
            in_val = kwargs['input']
            del process_args['input']
        logger.debug(cwd)
        # When running as shell command, subprocess expects
        # The arguments to be string.
        logger.debug(str(self))
        cmd = str(self) if kwargs['shell'] else self
        x = subprocess.Popen(cmd,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE,
                             **process_args)
        try:
            out, err = x.communicate(input=in_val,timeout=timeout)
            out = out.rstrip()
            err = err.rstrip()
        except subprocess.TimeoutExpired as cmd:
            x.kill()
            out, err = x.communicate()
            out = out.rstrip()
            err = err.rstrip()
            logger.error("Process Killed.")
            logger.error("Command did not exit within {0} seconds: {1}".format(timeout,cmd))

        try:
            fmt = sys.stdout.encoding if sys.stdout.encoding is not None else 'utf-8'
            if out:
                if x.returncode != 0:
                    logger.error(out.decode(fmt))
                else:
                    logger.debug(out.decode(fmt))
        except UnicodeError:
            logger.warning("Unable to decode STDOUT for launched subprocess. Output written to:"+
                    cwd+"/stdout.log")
            with open(cwd+"/stdout.log","wb") as f:
                f.write(out)
        try:
            fmt = sys.stderr.encoding if sys.stdout.encoding is not None else 'utf-8'
            if err:
                if x.returncode != 0:
                    logger.error(err.decode(fmt))
                else:
                    logger.debug(err.decode(fmt))
        except UnicodeError:
            logger.warning("Unable to decode STDERR for launched subprocess. Output written to:"+
                    cwd+"/stderr.log")
            with open(cwd+"/stderr.log","wb") as f:
                f.write(out)
        return x.returncode

    def _is_shell_command(self):
        """
        Return true if current command is supposed to be executed
        as shell script otherwise false.
        """
        return any('|' in arg for arg in self.args)

    def _path2str(self, path):
        """Convert :py:class:`pathlib.Path` to string.

        The final form of the string is determined by the
        configuration of `Command` instance.

        :param path: Path-like object which will be converted
                     into string.
        :return: String representation of `path`
        """
        path = pathlib.Path(path)
        if self.ensure_absolute_paths and not path.is_absolute():
            path = path.resolve()

        if self.pathstyle == 'posix':
            return path.as_posix()
        elif self.pathstyle == 'auto':
            return str(path)
        else:
            raise ValueError(f"Invalid pathstyle {self.pathstyle}")

    def __add__(self, other):
        cmd = Command(self,
                      pathstyle=self.pathstyle,
                      ensure_absolute_paths=self.ensure_absolute_paths)
        cmd += other
        return cmd

    def __iadd__(self, other):
        self.append(other)
        return self

    def __iter__(self):
        """
        Support iteration so functions from :py:mod:`subprocess` module
        support `Command` instance.
        """
        return iter(self.args)

    def __repr__(self):
        return f'<{self.__class__.__name__} args={self.args}>'

    def __str__(self):
        return ' '.join(self.args)


class shellCommand(Command):
    """
        Sub Class of the command class which always executes commands as shell commands.
    """

    def __init__(self, *args, pathstyle='auto', ensure_absolute_paths=False):
        """
        :param pathstyle: Determine the path style when adding instance of
            :py:class:`pathlib.Path`. Path style determines the slash type
            which separates the path components. If pathstyle is `auto`, then
            on Windows backslashes are used and on Linux forward slashes are used.
            When backslashes should be prevented on all systems, the pathstyle
            should be `posix`. No other values are allowed.

        :param ensure_absolute_paths: If true, then any passed path will be
            converted to absolute path.

        :param args: Initial command.

        :type pathstyle: str

        :type ensure_absolute_paths: bool

        """
        return super().__init__(*args,
                                pathstyle=pathstyle,
                                ensure_absolute_paths=ensure_absolute_paths)

    def _is_shell_command(self):
        return True
