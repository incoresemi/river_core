# Copyright (c) 2021, InCore Semiconductors Pvt. Ltd.
# See Licence for more details

# Author: Purushothaman P
# Email : purushothaman.palani@incoresemi.com

import os
import PySimpleGUI as Sg
import subprocess
import sys
from configparser import ConfigParser
import re

# Set appearence settings
Sg.theme('DarkGrey14')
n_font = "Arial 10"
b_font = "Arial 10 bold"

# TODO: Find way to obtain list of modules supported by uarch_test
list_modules = [
    'all', 'alu', 'branch_predictor', 'csr', 'decoder', 'decompressor', 'fpu',
    'm_ext', 'registerfile'
]


class config_data(object):
    """
        Class object to store the config file details
    """
    work_dir: str
    target: str
    reference: str
    generator: str
    isa: str
    path_to_target: str
    path_to_ref: str
    path_to_suite: str
    open_browser: bool
    space_saver: bool
    coverage_code: bool
    coverage_functional: bool
    dut_jobs: int
    dut_filter: str
    dut_count: int
    dut_src_dir: str
    dut_top_module: str
    dut_check_logs: bool
    gen_jobs: int
    gen_count: int
    gen_seed: str
    gen_dut_config: str
    gen_work_dir: str
    gen_linker_dir: str
    gen_modules_dir: str
    gen_modules: str
    gen_generate_covergroups: bool
    ref_jobs: int
    ref_count: int
    ref_filter: str

    def __init__(self,
                 wd='',
                 tgt='',
                 ref='',
                 gen='uarch_test',
                 isa='rv64imafdc',
                 tgt_path='',
                 ref_path='',
                 suite_path='',
                 brwsr=False,
                 space=False,
                 code=False,
                 func=False,
                 dut_job=4,
                 dut_filt='',
                 dut_ct=1,
                 dut_src_dir='',
                 dut_top_mod='',
                 dut_chk_log=False,
                 gen_jobs=4,
                 gen_ct=1,
                 gen_seed='random',
                 gen_dut_cfg='',
                 gen_work_dir='',
                 gen_link_dir='',
                 gen_mod_dir='',
                 gen_mod='all',
                 gen_gen_cg=True,
                 ref_jobs=1,
                 ref_ct=1,
                 ref_filt=''):
        self.work_dir = wd
        self.target = tgt
        self.reference = ref
        self.generator = gen
        self.isa = isa
        self.path_to_target = tgt_path
        self.path_to_ref = ref_path
        self.path_to_suite = suite_path
        self.open_browser = brwsr
        self.space_saver = space
        self.coverage_code = code
        self.coverage_functional = func
        self.dut_jobs = dut_job
        self.dut_filter = dut_filt
        self.dut_count = dut_ct
        self.dut_src_dir = dut_src_dir
        self.dut_top_module = dut_top_mod
        self.dut_check_logs = dut_chk_log
        self.gen_jobs = gen_jobs
        self.gen_count = gen_ct
        self.gen_seed = gen_seed
        self.gen_dut_config = gen_dut_cfg
        self.gen_work_dir = gen_work_dir
        self.gen_linker_dir = gen_link_dir
        self.gen_modules_dir = gen_mod_dir
        self.gen_modules = gen_mod
        self.gen_generate_covergroups = gen_gen_cg
        self.ref_jobs = ref_jobs
        self.ref_count = ref_ct
        self.ref_filter = ref_filt

    def __repr__(self):
        obj = f'work_dir: {self.work_dir}\ntarget: {self.target}\n'
        obj += f'reference: {self.reference}\ngenerator: {self.generator}\n\n'
        obj += f'isa: {self.isa}\n\npath_to_target: {self.path_to_target}\n'
        obj += f'path_to_ref: {self.path_to_ref}\npath_to_suite: {self.path_to_suite}\n'
        obj += f'open_browser: {self.open_browser}\nspace_saver: {self.space_saver}\n'
        obj += f'\n[{self.target}]\njobs: {self.dut_jobs}\nfilter: {self.dut_filter}\n'
        obj += f'count: {self.dut_count}\nsrc_dir: {self.dut_src_dir}\n'
        obj += f'top_module: {self.dut_top_module}\ncheck_logs: {self.dut_check_logs}\n'
        obj += f'\n[{self.generator}]\njobs: {self.gen_jobs}\ncount: {self.gen_count}\n'
        obj += f'seed: {self.gen_seed}\ndut_config: {self.gen_dut_config}\n'
        obj += f'work_dir: {self.gen_work_dir}\nlinker_dir: {self.gen_linker_dir}\n'
        obj += f'modules_dir: {self.gen_modules_dir}\nmodules: {self.gen_modules}\n'
        obj += f'\n[{self.reference}]\njobs: {self.ref_jobs}\ncount: {self.ref_count}\n'
        obj += f'filter: {self.ref_filter}\n'
        return obj


def reset_config(config_file):
    """
        this function takes in the file path (config_file) and writes/overwrites
        the config.ini file with default parameters.
    """
    f = open(config_file, 'w')
    f.write('[river_core]\n')
    f.write('# Main directory for all files generated by river_core\n')
    f.write('work_dir = work_dir\n')
    f.write('# Name of the target DuT plugin\n')
    f.write('target = chromite_verilator\n')
    f.write('# Name of the reference model plugin\n')
    f.write('reference = modspike\n')
    f.write('# Name of the generator(s) to be used. Comma separated\n')
    f.write('generator = uarch_test\n')
    f.write('# ISA for the tests\n')
    f.write('isa = rv64imafdc\n\n')
    f.write('# Set paths for each plugin\n')
    f.write('path_to_target = ../river_core_plugins/dut_plugins\n')
    f.write('path_to_ref = ../river_core_plugins/reference_plugins\n')
    f.write('path_to_suite = ../river_core_plugins/generator_plugins\n\n')
    f.write(
        '# To open the report automatically in the browser\nopen_browser = True'
        '\n\n')
    f.write('# Enable Space Saver\nspace_saver = True\n\n')
    f.write('[coverage]\ncode = False\nfunctional = False\n\n')

    # DUT plugin
    f.write('[chromite_verilator]\njobs = 4\nfilter =\ncount = 1\n')
    f.write('# src dir: Verilog Dir, BSC Path, Wrapper path\nsrc_dir = '
            '../chromite/build/hw/verilog/, ../bluespec/lib/Verilog, '
            '../chromite/bsvwrappers/common_lib\n')
    f.write('top_module = mkTbSoc\ncheck_logs = True\n\n')
    # Gen plugin
    f.write('[uarch_test]\njobs = 4\ncount = 1\nseed = random\n')
    f.write(
        'dut_config_yaml = ../dut_config.yaml\nwork_dir =\nlinker_dir =\nmodules_dir =\n'
    )
    f.write('modules = all\ngenerate_covergroups = True\n\n')
    # Ref plugin
    f.write('[modspike]\njobs = 1\ncount = 1\nfilter = \n')
    f.close()


def read_existing_config(config_file):
    """
       this function takes in the file path (config_file) and reads the config
       file and returns the values as config_data object.
    """
    config = config_data()
    if os.path.isfile(config_file):
        cfg = ConfigParser()
        cfg.read(filenames=config_file)
        sections = cfg.sections()
        for i in sections:
            if i == 'river_core':
                config.work_dir = cfg[i]['work_dir']
                config.target = cfg[i]['target']
                config.reference = cfg[i]['reference']
                config.generator = cfg[i]['generator']
                config.isa = cfg[i]['isa']
                config.path_to_target = cfg[i]['path_to_target']
                config.path_to_ref = cfg[i]['path_to_ref']
                config.path_to_suite = cfg[i]['path_to_suite']
                config.open_browser = cfg[i]['open_browser']
                config.space_saver = cfg[i]['space_saver']
            if i == 'coverage':
                config.coverage_code = cfg[i]['code']
                config.coverage_functional = cfg[i]['functional']
            if i in [
                'chromite_verilator', 'cclass_verilator', 'chromite_questa',
                'chromite_cadence'
            ]:
                config.dut_jobs = cfg[i]['jobs']
                config.dut_filter = cfg[i]['filter']
                config.dut_count = cfg[i]['count']
                config.dut_src_dir = cfg[i]['src_dir']
                config.dut_top_module = cfg[i]['top_module']
                config.dut_check_logs = cfg[i]['check_logs']
            if i in ['uarch_test']:
                config.gen_jobs = cfg[i]['jobs']
                config.gen_count = cfg[i]['count']
                config.gen_seed = cfg[i]['seed']
                config.gen_dut_config = cfg[i]['dut_config_yaml']
                config.gen_work_dir = cfg[i]['work_dir']
                config.gen_linker_dir = cfg[i]['linker_dir']
                config.gen_modules_dir = cfg[i]['modules_dir']
                config.gen_modules = cfg[i]['modules']
            if i in ['spike', 'modspike']:
                config.ref_jobs = cfg[i]['jobs']
                config.ref_count = cfg[i]['count']
                config.ref_filter = cfg[i]['filter']
    else:
        reset_config(config_file)
        read_existing_config(config_file)
    return config


def save_new_config(config_file, val):
    """
        this function takes in the file path and the values obtained from gui
        and overwrites the config.ini file.
    """
    isa = 'rv64i'
    # if val['rv_i']:
    #   isa += 'i'
    if val['rv_m']:
        isa += 'm'
    if val['rv_a']:
        isa += 'a'
    if val['rv_f']:
        isa += 'f'
    if val['rv_d']:
        isa += 'd'
    if val['rv_c']:
        isa += 'c'

    f = open(config_file, 'w')
    f.write('[river_core]\n')
    f.write('# Main directory for all files generated by river_core\n')
    f.write('work_dir = {0}\n\n'.format(val['work_dir']))
    f.write('# Name of the target DuT plugin\n')
    f.write('target = {0}\n\n'.format(val['dut_plugin']))
    f.write('# Name of the reference model plugin\n')
    f.write('reference = {0}\n\n'.format(val['ref_plugin']))
    f.write('# Name of the generator(s) to be used. Comma separated\n')
    f.write('generator = {0}\n\n'.format(val['gen_plugin']))
    f.write('# ISA for the tests\n')
    f.write('isa = {0}\n\n'.format(isa))
    f.write('# Set paths for each plugin\n')
    f.write('path_to_target = {0}\n'.format(val['path_to_target']))
    f.write('path_to_ref = {0}\n'.format(val['path_to_ref']))
    f.write('path_to_suite = {0}\n\n'.format(val['path_to_suite']))
    f.write(
        '# To open the report automatically in the browser\nopen_browser =' +
        str(val['open_browser']) + '\n\n')
    f.write('# Enable Space Saver\nspace_saver = {0}\n\n'.format(
        str(val['space_saver'])))

    f.write('[coverage]\ncode = {0}\nfunctional = {1}\n\n'.format(
        val['code'], val['functional']))
    # DUT plugin
    f.write('[{0}]\njobs = 4\nfilter =\ncount = 1\n'.format(val['dut_plugin']))
    f.write(
        '# src dir: Verilog Dir, BSC Path, Wrapper path\nsrc_dir = {0}, {1}, {2}\n'
            .format(val['dut_verilog_dir'], val['dut_bsc_path'],
                    val['dut_wrapper_path']))
    f.write('top_module = {0}\ncheck_logs = {1}\n\n'.format(
        val['dut_top_module'], val['dut_check_logs']))
    # Gen plugin
    f.write('[{0}]\njobs = 4\ncount = 1\nseed = random\n'.format(
        val['gen_plugin']))
    f.write(
        'dut_config_yaml = {0}\nwork_dir = {1}\nlinker_dir = {2}\nmodules_dir = {3}\n'
            .format(val['gen_config_yaml'], val['gen_work_dir'],
                    val['gen_linker_dir'], val['gen_modules_dir']))
    f.write('modules = {0}\ngenerate_covergroups = {1}\n\n'.format(
        ", ".join(val['gen_modules']), str(val['gen_generate_covergroups'])))
    # Ref plugin
    f.write('[{0}]\njobs = 1\ncount = 1\nfilter = \n'.format(val['ref_plugin']))
    f.close()


def strip_ansi(source):
    # strip color code from logger output
    return re.sub(r'\033\[(\d|;)+?m', '', source)


def create_river_layout(config_obj):
    """
        this function takes in configuration details and returns the home page
        GUI layout.
    """
    menu_layout = [
        [
            'File',
            [
                'Setup RiVer-Core', 'Generate', 'Compile', 'Merge', 'Clean',
                'Quit'
            ]
        ],
        [
            'Edit',
            ['Set Paths'],
        ],
        ['Help', 'About...'],
    ]

    river_layout = [
        [Sg.Menu(menu_layout)],
        [
            Sg.Text("Verbosity: "),
            Sg.Combo(['Info', 'Debug', 'Error'],
                     default_value='debug',
                     key='verb'),
        ],
        [
            Sg.Frame('DUT Plugin',
                     layout=[
                         [Sg.Text('  ')],
                         [
                             Sg.T("DUT         : {0}".format(
                                 config_obj.target)),
                         ],
                         [
                             Sg.T('Top Module  : {0}'.format(
                                 config_obj.dut_top_module))
                         ],
                         [
                             Sg.T('Verilog Dir : {0}'.format(
                                 config_obj.dut_src_dir.split(', ')[0]))
                         ],
                         [
                             Sg.T('BSC Dir     : {0}'.format(
                                 config_obj.dut_src_dir.split(', ')[1]))
                         ],
                         [
                             Sg.T('Wrapper Dir : {0}'.format(
                                 config_obj.dut_src_dir.split(', ')[2]))
                         ],
                         [
                             Sg.T('Check Logs  : {0}'.format(
                                 config_obj.dut_check_logs))
                         ],
                         [Sg.Text('  ')],
                     ]),
            Sg.T(''),
            Sg.Frame('Generator Plugin',
                     layout=[
                         [Sg.Text('  ')],
                         [
                             Sg.T("Generator         : {0}".format(
                                 config_obj.generator)),
                         ],
                         [
                             Sg.T('DUT_Config YAML   : {0}'.format(
                                 config_obj.gen_dut_config))
                         ],
                         [
                             Sg.T('Work Directory    : {0}'.format(
                                 config_obj.gen_work_dir))
                         ],
                         [
                             Sg.T('Linker Directory  : {0}'.format(
                                 config_obj.gen_linker_dir))
                         ],
                         [
                             Sg.T('Modules Directory : {0}'.format(
                                 config_obj.gen_modules_dir))
                         ],
                         [
                             Sg.T('Modules           : {0}'.format(
                                 config_obj.gen_modules))
                         ],
                         [
                             Sg.T('Gen Covergroups   : {0}'.format(
                                 config_obj.gen_generate_covergroups))
                         ],
                     ],
                     size=(100, 50)),
            # Sg.Frame(
            #     'Reference Plugin',
            #     layout=[[Sg.Text("Reference: {}".format(
            #                      config_obj.reference))]])
        ],
        # [
        #     Sg.Frame(
        #        'Reference Plugin',
        #        layout=[[Sg.Text("Reference: {}".format(
        #                         config_obj.reference))]]),
        # ],
        [
            Sg.Button('Setup'),
            Sg.Button('Generate'),
            Sg.Button('Compile'),
            Sg.Button('Merge'),
            Sg.Button('Clean')
        ],
    ]

    return river_layout


def create_setup_layout():
    """
        this function returns the home page setup page GUI layout.
    """
    setup_layout = [
        # ISA Settings
        [
            Sg.Frame(
                'ISA Selection',
                layout=[[
                    Sg.Text('RV64', font=b_font),
                    Sg.Checkbox('I', key='rv_i', default=True, disabled=True),
                    Sg.Checkbox('M', key='rv_m', default=True),
                    Sg.Checkbox('A', key='rv_a', default=True),
                    Sg.Checkbox('F', key='rv_f', default=True),
                    Sg.Checkbox('D', key='rv_d', default=True),
                    # Sg.Checkbox('Q', key='rv_q', default=False,
                    #             disabled=True),
                    # Sg.Checkbox('Zicsr', key='rv_zicsr',
                    #             default=False, disabled=True),
                    Sg.Checkbox('C', key='rv_c', default=True),
                ]])
        ],
        # Path Settings
        [
            Sg.Frame(
                'Path Settings',
                layout=[
                    [
                        Sg.Text('Work Directory :', font=n_font),
                        Sg.Input(key='work_dir', size=(40, 1), default_text=""),
                        Sg.FolderBrowse()
                    ],
                    [
                        Sg.Text('Target Path    :', font=b_font),
                        Sg.Input(key='path_to_target',
                                 size=(40, 1),
                                 default_text=""),
                        Sg.FolderBrowse()
                    ],
                    [
                        Sg.Text('Reference Path :', font=b_font),
                        Sg.Input(key='path_to_ref',
                                 size=(40, 1),
                                 default_text=""),
                        Sg.FolderBrowse()
                    ],
                    [
                        Sg.Text('Suite Path     :', font=b_font),
                        Sg.Input(key='path_to_suite',
                                 size=(40, 1),
                                 default_text=""),
                        Sg.FolderBrowse()
                    ],
                ],
            )
        ],
        # Plugin Settings
        [
            Sg.Frame(
                'Plugin Setup',
                layout=[
                    # DUT, Generator Plugin Settings
                    [
                        Sg.Frame(
                            '1. DUT Plugin',
                            layout=[
                                [Sg.T()],
                                [
                                    Sg.Text('DUT Plugin :', font=b_font),
                                    Sg.Combo([
                                        'chromite_Cadence', 'cclass_verilator',
                                        'chromite_questa', 'chromite_verilator'
                                    ],
                                        default_value='chromite_verilator',
                                        key='dut_plugin')
                                ],
                                [Sg.T()],
                                [
                                    Sg.Text('Verilog Dir  :', font=b_font),
                                    Sg.Input(key='dut_verilog_dir',
                                             size=(35, 1),
                                             default_text='verilog dir'),
                                    Sg.FolderBrowse(button_text='...',
                                                    initial_folder=os.getcwd())
                                ],
                                [
                                    Sg.Text('BSC Path     :', font=b_font),
                                    Sg.Input(key='dut_bsc_path',
                                             size=(35, 1),
                                             default_text='bsc dir'),
                                    Sg.FolderBrowse(button_text='...',
                                                    initial_folder=os.getcwd())
                                ],
                                [
                                    Sg.Text('Wrapper Path :', font=b_font),
                                    Sg.Input(key='dut_wrapper_path',
                                             size=(35, 1),
                                             default_text='wrapper_dir'),
                                    Sg.FolderBrowse(button_text='...',
                                                    initial_folder=os.getcwd())
                                ],
                                [Sg.T()],
                                [
                                    Sg.Text('Top Module   :', font=n_font),
                                    Sg.Input(key='dut_top_module',
                                             size=(10, 1),
                                             default_text='mkTbSoc')
                                ],
                                [
                                    # Sg.Text('Check Logs   :',),
                                    Sg.Checkbox(' Check Logs',
                                                font=n_font,
                                                key='dut_check_logs',
                                                default=True)
                                ],
                            ],
                            size=(120, 120)),
                        Sg.Frame(
                            '2. Generator Plugin',
                            layout=[
                                [
                                    Sg.Text('Generator Plugin :', font=b_font),
                                    Sg.Combo(
                                        ['uarch_test'],
                                        default_value='uarch_test',
                                        key='gen_plugin',
                                        disabled=True),
                                ],
                                [
                                    Sg.Text('config.yaml :', font=b_font),
                                    Sg.Input(
                                        key='gen_config_yaml',
                                        size=(35, 1),
                                        default_text='dut_config.yaml'),
                                    Sg.FileBrowse(button_text='...',
                                                  file_types=(("YAML Files",
                                                               "*.yaml"),))
                                ],
                                [
                                    Sg.Text('work dir    :', font=n_font),
                                    Sg.Input(
                                        key='gen_work_dir',
                                        size=(35, 1),
                                        default_text=''),
                                    Sg.FolderBrowse(button_text='...')
                                ],
                                [
                                    Sg.Text('linker dir  :', font=n_font),
                                    Sg.Input(
                                        key='gen_linker_dir',
                                        size=(35, 1),
                                        default_text=''),
                                    Sg.FolderBrowse(button_text='...')
                                ],
                                [
                                    Sg.Text('Modules dir :', font=n_font),
                                    Sg.Input(
                                        key='gen_modules_dir',
                                        size=(35, 1),
                                        default_text=''),
                                    Sg.FolderBrowse(button_text='...')
                                ],
                                [
                                    Sg.Text('Select Modules:', font=n_font),
                                    Sg.Listbox(
                                        values=list_modules,
                                        select_mode='extended',
                                        default_values=['all'],
                                        size=(len(max(list_modules, key=len)) +
                                              2, 5),
                                        key='gen_modules'),
                                ],
                                [
                                    Sg.Checkbox(' Generate Covergroups',
                                                font=n_font,
                                                key='gen_generate_covergroups',
                                                default=True),
                                ],
                            ]),
                    ],
                    # Reference Plugin Settings
                    [
                        Sg.Frame(
                            '3. Reference Plugin',
                            layout=[[
                                Sg.Text('Reference Plugin :', font=b_font),
                                Sg.Combo(['modspike', 'spike'],
                                         default_value='modspike',
                                         key='ref_plugin')
                            ]],
                        ),
                    ],
                ])
        ],
        # Additional Settings
        [
            Sg.Frame(
                'Additional Options',
                layout=[[
                    Sg.Checkbox(' Open Browser Report',
                                font=n_font,
                                key='open_browser',
                                default=True),
                    Sg.Checkbox(' Space Saver',
                                font=n_font,
                                key='space_saver',
                                default=False),
                ]],
            ),
            Sg.Frame('Coverage Options',
                     layout=[[
                         Sg.Checkbox(' Code Coverage',
                                     font=n_font,
                                     key='code',
                                     default=True),
                         Sg.Checkbox(' Functional Coverage',
                                     font=n_font,
                                     key='functional',
                                     default=True),
                     ]]),
        ],
        [Sg.T()],
        [
            Sg.T(size=(25, 1)),
            Sg.Button('Save Configuration', key='save_config'),
            Sg.Button('Reset to Defaults !',
                      button_color='red',
                      key='reset_config'),
            Sg.Button('Exit without Saving', key='exit_config')
        ],
    ]
    return setup_layout


def setup_page(config_file):
    """
        this function displays the setup page based upon the attributes stored
        in config_file.
    """
    window = Sg.Window('Configure River-Core',
                       layout=create_setup_layout(),
                       debugger_enabled=True, finalize=False)
    while True:
        event, values = window.read()
        if event == Sg.WIN_CLOSED or event == 'exit_config':
            break
        elif event == 'save_config':
            ok = Sg.PopupOKCancel(
                'Do you want to Save the present Configuration? '
                'Previous Configuration will be overwritten. '
                'RESTART TO SAVE Changes',
                keep_on_top=True,
                title='Save Config')
            if ok is 'OK':
                save_new_config(config_file, values)
                Sg.PopupOK('Saved Configuration')
                break
        elif event == 'reset_config':
            ok = Sg.PopupOKCancel(
                'Do you want to RESET Configuration to default '
                'state? This will break the setup and Path\'s '
                'need to be set once again to continue '
                'execution!',
                text_color='red',
                title='Reset Config',
                button_color='red',
                keep_on_top=True)
            if ok is 'OK':
                reset_config(config_file)
                Sg.PopupOK('Reset Configuration')
                break
    window.close()


def run_command(cmd, timeout=None, window=None):
    """
        this function runs the command (cmd) on the shell and displays the text
        in window
    """
    p = subprocess.Popen(cmd,
                         shell=True,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT)
    output = ''
    txt = window.FindElement('-ML-').Widget
    txt.tag_config("info", background='#2c2e2e', foreground="white")
    txt.tag_config("debug", background='#2c2e2e', foreground="green")
    txt.tag_config("warning", background='#2c2e2e', foreground="yellow")
    txt.tag_config("error", background='#2c2e2e', foreground="orange")
    txt.tag_config("critical", background='#2c2e2e', foreground="red")
    txt.tag_config("message", background='#2c2e2e', foreground="cyan")

    for line in p.stdout:
        line = line.decode(errors='replace' if sys.version_info <
                           (3, 5) else 'backslashreplace',
                           encoding='utf-8').rstrip()
        line = strip_ansi(line)
        output += line
        if "    critical  |" in line:
            txt.insert("end", line + '\n', 'critical')
        elif "       error  |" in line:
            txt.insert("end", line + '\n', 'error')
        elif "     command  |" in line:
            txt.insert("end", line + '\n', 'warning')
        elif "       debug  |" in line:
            txt.insert("end", line + '\n', 'debug')
        elif "        info  |" in line:
            txt.insert("end", line + '\n', 'info')
        else:
            txt.insert("end", line + '\n', 'message')
        # window.refresh()
    ret_val = p.wait(timeout)
    return ret_val, output


def rivercore_gui():
    """
        Main function to create the home page gui and invoke other functions
        based on user actions.
    """
    config_file = os.path.join(os.getcwd(), 'config.ini')
    if os.path.isfile(config_file):
        existing = read_existing_config(config_file)
        console_layout = [
            [
                Sg.MLine(size=(120, 18),
                         background_color='#2c2e2e',
                         text_color='#b7ede8',
                         reroute_stdout=True,
                         reroute_stderr=True,
                         reroute_cprint=True,
                         auto_refresh=True,
                         write_only=True,
                         font='Courier 11',
                         autoscroll=True,
                         key='-ML-')
            ],
            [
                Sg.Button('Clear', key='clear_term')
            ]
        ]
        river_frame = [[
            Sg.Frame('River-Core Configuration',
                     layout=create_river_layout(existing))
        ]]
        console_frame = [[Sg.Frame('Terminal', layout=console_layout)]]

        window = Sg.Window('River-Core GUI',
                           layout=[river_frame, [Sg.HSeparator()],
                                   console_frame],
                           finalize=True,
                           debugger_enabled=True)

        while True:
            event, values = window.read()
            if event == Sg.WIN_CLOSED or event in ['Exit', 'Quit']:
                break
            elif event in ['Set Paths', 'Setup', 'Setup RiVer-Core']:
                setup_page(config_file)
                Sg.PopupOK('Restart RiVer-Core GUI',
                           background_color='black',
                           text_color='red')
                break
            elif event in ['Generate']:
                # river_core generate -c <path_to_ini_file> -v <value>
                run_command('river_core generate -c {0} -v {1}'.format(
                    config_file, values['verb']),
                    window=window)
            elif event in ['Compile']:
                run_command('river_core compile -t {0} -v {1}'.format(
                    os.path.join(existing.work_dir, 'test_list.yaml'),
                    values['verb']),
                    window=window)
            if event in ['About...']:
                run_command(
                    'python -m webbrowser "https://river-core.readthedocs.io'
                    '/en/stable"')
            if event == 'clear_term' or event == 'clear':
                window['-ML-'].Update(' ')
    else:
        reset_config(config_file)
        Sg.PopupOK('Files Initialized. Restart RiVer Core GUI')


if __name__ == '__main__':
    rivercore_gui()
