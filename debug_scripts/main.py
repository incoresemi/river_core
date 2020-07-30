# See LICENSE file for details
"""Console script for repomanager."""

import os
import random
import datetime
import shutil
import click
import subprocess
import filecmp
from glob import glob

import pandas as pd
import numpy as np
from log import *
from utils import *
from constants import *
import re
@click.command()
@click.option('--verbose', '-v', default='error', help='Set verbose level')
@click.option('--clean','-c', is_flag='True', help='Clean builds')
@click.option('--fpath', '-f', help='generate')
def cli(verbose,  clean, fpath):
    pwd = os.getcwd()

    logger.info('Debugging')
    final_df = pd.DataFrame({
    'test_dir': [None],
    'fail_reason': [None],
    'fail_disass': [None],
    'diff_dump': [None]
    })
    grep_check = None
    fail_reason = None
    diff_dump = None
    fail_disass = None
    fail_list = []
    for dir,_,_ in os.walk(fpath):
        fail_list.extend(glob(os.path.join(dir, 'FAIL*'.format(fpath))))            
    for fail in fail_list:
        fail_name = os.path.dirname(fail)
        logger.debug('failname: {0}'.format(fail_name))
        
        os.chdir(fail_name)
        name = os.path.basename(fail_name)
        out, err = sys_command('{0}/comp_script.sh spike.dump rtl.dump'.format(pwd), logger)
        diff_dump = out
        #rtl_match = re.search('rtl.dump:(\d)\s+(\S+)\s+\(\S+\)\+x(.*) (0x\S+)', out)
        rtl_match = re.search('rtl.dump:(\d)\s+(\S+)\s+\(.*\)\s+(x.*)', out)
        spike_match = re.search('spike.dump:(\d)\s+(\S+)\s+\(.*\)\s+(x.*)', out)
        rtl_priv = None
        rtl_pc = None
        rtl_reg = None
        spike_priv = None
        spike_pc = None
        spike_reg = None

        if rtl_match:
            rtl_priv = rtl_match.group(1)
            rtl_pc = rtl_match.group(2)
            rtl_reg = rtl_match.group(3)
        if spike_match:
            spike_priv = spike_match.group(1)
            spike_pc = spike_match.group(2)
            spike_reg = spike_match.group(3)

        if rtl_priv != spike_priv:
            reason = "Value mismatch on PRIV "
        elif rtl_pc != spike_pc:
            reason = "Value mismatch on PC "
        elif rtl_reg != spike_reg:
            reason = "Value mismatch on REG "

        if bool(re.search('EOF on rtl.dump', err)):
            reason = "RTL hang --> {0}".format(out)
        elif bool(re.search('EOF on spike.dump', err)):
            reason = "RTL overshoot --> {0}".format(out)
        else:
            x = re.findall("8.*", out)
            x = x[0][:8]
            grep_check = x
            (out, err) = sys_command('{0}/print_disass.sh {1}'.format(pwd, grep_check), logger)
            fail_disass = "{0} ".format(out)
            df_temp = pd.DataFrame({'test_dir': [name],'fail_reason': [reason],
                 'fail_disass': [fail_disass],
                 'diff_dump': [diff_dump]})
            final_df = final_df.append(df_temp)

    logger.debug(final_df)
    final_df.to_csv('{0}/final_df.csv'.format(pwd),index=False)

  #  if clean:
  #      shutil.rmtree(cwd+'/workdir')
  #  if gen:
  #      index=0
  #      workdir = cwd + '/workdir'
  #      os.makedirs(workdir)
  #      for c in range(count):
  #          for template in template_list:
  #              template_name = os.path.basename(template)
  #              logger.debug('Generating test using template: {0}'.format(template))
  #              gen_seed = random.randint(0, 10000000)
  #              now = datetime.datetime.now()
  #              gen_prefix = '{0:04}_{1}'.format(gen_seed, now.strftime('%d%m%Y%H%M%S%f'))
  #              test_prefix = 'microtesk_{0}_{1}_{2}'.format(template_name.replace('.rb', ''), gen_prefix,c)
  #              testdir = '{0}/{1}'.format(workdir, test_prefix)

  #              logger.debug('testdir: {0}'.format(testdir))
  #              #os.makedirs(testdir)
  #              pwd = os.getcwd()
  #              #os.chdir(testdir)
  #              regress_list.append(testdir)
# #               sys_command('bash {0}/bin/generate.sh riscv {1}/{2} \
# #                               --code-file-extension S \
# #                               --tracer-log \
# #                               --coverage-log \
# #                               --output-dir {testdir} \
# #                               --verbose -debug-print \
# #                               --self-checks \
# #                               --asserts-enabled \
# #                               --code-file-prefix {4} \
# #                               --rs {5} -g \
# #                               1>{3}/test.stdout \
# #                        h       2>{3}/test.stderr'.format(microtesk_home, template_path, template, outdir, , gen_seed), logger)
#
  #              command_list.append('bash {0}/bin/generate.sh riscv {1} \
  #                              --code-file-extension S \
  #                              --output-dir {2} \
  #                              --code-file-prefix {3} \
  #                              --rs {4} -g \
  #                              '.format(microtesk_home, template, testdir, test_prefix , gen_seed))
  #                  #os.chdir(pwd) 
  #      logger.debug(regress_list)
  #      logger.debug(command_list)
  #      processes = set()
  #      for i in range(len(command_list)):
  #          logger.debug(command_list[i])
  #          logger.debug(regress_list[i])
  #          testdir = regress_list[i]
  #          os.makedirs(testdir)
  #          os.chdir(testdir)
  #          sys_command(command_list[i], logger, 120)
  #          gendir_list = []
  #          for dir,_,_ in os.walk(regress_list[i]):
  #              gendir_list.extend(glob(os.path.join(dir, '{0}/*.S'.format(regress_list[i]))))
  #          logger.debug('Generated S files:{0}'.format(gendir_list))
  #          for gentest in gendir_list:
  #              ldname = os.path.basename(testdir)
  #              testname = os.path.basename(gentest).replace('.S','')
  #              dirname = os.path.dirname(gentest)
  #              test_gen_dir = '{0}/{1}'.format(workdir, testname)
  #              os.makedirs(test_gen_dir)
  #              logger.debug('created {0}'.format(test_gen_dir))
  #              logger.debug('testdir {0}'.format(testdir))
  #              sys_command('cp {0}/{1}.ld {2}'.format(testdir, ldname, test_gen_dir), logger)
  #              sys_command('mv {0}/{1}.log {2}'.format(testdir, testname, test_gen_dir), logger)
  #              sys_command('mv {0}/{1}.S {2}'.format(testdir, testname, test_gen_dir), logger)
  #          shutil.rmtree(testdir)
  #         #logger.warning('$ {0} '.format(' '.join(shlex.split(command_list[i]))))
  #         #processes.add(subprocess.Popen(shlex.split(command_list[i])))
  #         #logger.warning(command_list[i])
  #         #if len(processes) >= parallel:
  #         #    os.wait()
  #         #    processes.difference_update(
  #         #        p for p in processes if p.poll() is not None])


  #  if compile:
  #      logger.debug('Compile')
  #      regress_list = glob('{0}/*'.format(workdir))
  #      logger.debug(regress_list)
  #      for test in regress_list:
  #          os.chdir(test)
  #          for ld_name in glob('{0}/*.ld'.format(test)):
  #              logger.debug(ld_name)
  #          
  #              test_name = os.path.basename(test)
  #              test_path = test
  #              logger.debug('test_name: {0}'.format(test_name))
  #              logger.debug('test_path: {0}'.format(test_path))

  #              sys_command('riscv64-unknown-elf-gcc -march=rv64imafdc -mabi=lp64 \
  #                      -static -mcmodel=medany -fvisibility=hidden -nostdlib \
  #                      -nostartfiles -T{1} {0}/{2}.S \
  #                      -o {0}/{2}.elf'.format(test_path, ld_name, test_name), logger)
  #              sys_command_file('riscv64-unknown-elf-objdump --disassemble-all \
  #                      --disassemble-zeroes --section=.text \
  #                      --section=.text.startup --section=.text.init \
  #                      --section=.data {0}/{1}.elf'.format(test_path,test_name),
  #                      '{0}/{1}.disass'.format(test_path, test_name), logger)
  #              sys_command('spike -c --isa=rv64imafdc +signature=spike_sig \
  #                      {0}/{1}.elf'.format(test_path, test_name), logger, 120)
  #              sys_command_file('elf2hex  16  131072 {0}/{1}.elf 2147483648'.format(test_path, test_name),
  #                      '{0}/code.mem'.format(test_path), logger)
  #              sys_command('ln -sf {0}/out .'.format(os.environ['BIN_PATH'], cwd),logger)
  #              sys_command('ln -sf {0}/bootfile .'.format(os.environ['BIN_PATH'], cwd),logger)
  #              sys_command('./out +rtldump', logger, 60)
  #              sys_command_file('head -n -4 rtl.dump','temp.dump', logger)
  #              sys_command('mv temp.dump rtl.dump', logger)
  #              if filecmp.cmp('rtl.dump', 'spike.dump'):
  #                  logger.debug('PASSED')
  #                  sys_command('touch PASSED', logger)
  #              else:
  #                  logger.debug('FAILED')
  #                  sys_command('touch FAILED', logger)
#mv temp.dump rtl.dump
#diff rtl.dump spike.dump
##../../sign_fix.sh spike_sig
##
#echo "===================================================="
#echo " $1 Test Result "
#echo "===================================================="
##diff -ys spike_sig_temp signature
#diff -s spike.dump rtl.dump
#echo "===================================================="
#cd ../../

if __name__ == '__main__':
    cli()

