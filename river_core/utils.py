# See LICENSE for details

"""Common Utils """
import sys
import os
import subprocess
import shlex
from river_core.log import logger
import ruamel
from ruamel.yaml import YAML
from threading import Timer

def sys_command(command, timeout=500):
    logger.warning('$ timeout={1} {0} '.format(' '.join(shlex.split(command)), timeout))
    x = subprocess.Popen(shlex.split(command),
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         )
    timer = Timer(timeout, x.kill)
    try:
        timer.start()
        out, err = x.communicate()
    finally:
        timer.cancel()
        
    #except subprocess.TimeoutExpired:
    #    x.kill()
    #    out, err = x.communicate()

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
    return (x.returncode, out.decode("ascii"), err.decode("ascii"))

def sys_command_file(command, filename, timeout=500):
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

