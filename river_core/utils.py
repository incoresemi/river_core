# See LICENSE for details

"""Common Utils """
import sys
import os
import subprocess
import shlex
from river_core.log import logger

def sys_command(command):
    logger.warning('$ {0} '.format(' '.join(shlex.split(command))))
    x = subprocess.Popen(shlex.split(command),
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         )
    try:
        out, err = x.communicate(timeout=5)
    except subprocess.TimeoutExpired:
        x.kill()
        out, err = x.communicate()

    out = out.rstrip()
    err = err.rstrip()
    if x.returncode != 0:
        if out:
            logger.error(out.decode("ascii"))
        if err:
            logger.error(err.decode("ascii"))
    else:
        if out:
            logger.debug(out.decode("ascii"))
        if err:
            logger.debug(err.decode("ascii"))
    return out.decode("ascii")

def sys_command_file(command, filename):
    cmd = command.split(' ')
    cmd = [x.strip(' ') for x in cmd]
    cmd = [i for i in cmd if i] 
    logger.debug('{0} > {1}'.format(' '.join(cmd), filename))
    fp = open(filename, 'w')
    out = subprocess.Popen(cmd, stdout=fp, stderr=fp)
    stdout, stderr = out.communicate()
    fp.close()

