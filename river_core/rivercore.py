# See LICENSE file for details
import sys
import os
import shutil
import yaml

from river_core.log import *
from river_core.utils import *
from river_core.constants import *
from river_core.__init__ import __version__

def rivercore(verbose, dir, clean):

    logger.level(verbose)
    logger.info('****** RiVer Core {0} *******'.format(__version__ ))
    logger.info('Copyright (c) 2020, InCore Semiconductors Pvt. Ltd.')
    logger.info('All Rights Reserved.')
    
