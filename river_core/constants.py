# See LICENSE for details

import os
from ruamel.yaml import YAML
from cerberus import Validator

root = os.path.abspath(os.path.dirname(__file__))
testlist_schema = '''
asm_file:
  type: string
  nullable: False
  required: True
  check_with: filecheck
cc:
  type: string
  nullable: True
cc_args:
  type: string
  nullable: True
generator:
  type: string
  required: True
isa: 
  type: string
  required: True
linker_file:
  type: string
  required: True
  check_with: filecheck
linker_args:
  type: string
  required: True
mabi:
  type: string
  required: True
march:
  type: string
  required: True
work_dir:
  type: string
  required: True
  check_with: dircheck
result:
  type: string
extra_compile:
  type: list
  schema:
    type: string
    nullable: True
    check_with: filecheck
  empty: True
include:
  type: list
  schema:
    type: string
    nullable: True
    check_with: dircheck
  empty: True
''' #: This contains the schema for validation


class YamlValidator(Validator):

    def _check_with_filecheck(self, field, value):
        if not os.path.isfile(value):
            self._error(field, 'File {0} not found'.format(value))

    def _check_with_dircheck(self, field, value):
        if not os.path.isdir(value):
            self._error(field, 'Dir {0} not found'.format(value))


cwd = os.getcwd()
