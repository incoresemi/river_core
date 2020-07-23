#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
import pandas as pd
import numpy as np
import subprocess


# In[2]:


df = pd.read_csv('fail2.9.1.csv')
df_sample = df.head(n=145)


# In[3]:


df_sample['Test Dir']


# In[12]:


final_df = pd.DataFrame({
    'test_dir': [None],
    'fail_reason': [None],
    'diff_disass': [None]
})


# In[13]:


i = 0
import re
os.chdir('/scratch/lavanya/i-class/base-sim/verification/workdir/aapg/fails_2.9.1/failed')
for name in df_sample['Test Dir']:
    grep_check = None
    reason = None
    diff_disass = None
    cur_dir = os.getcwd()
    print('cd /scratch/lavanya/i-class/base-sim/verification/workdir/aapg/fails_2.9.1/failed/{0}'.format(name))
    os.chdir(os.path.join('/scratch/lavanya/i-class/base-sim/verification/workdir/aapg/fails_2.9.1/failed',name))
    print('source /scratch/lavanya/i-class/base-sim/verification/workdir/aapg/I-Class_auto_verifier/comp_script.sh spike.dump rtl.dump > temp.txt')
    os.system('source /scratch/lavanya/i-class/base-sim/verification/workdir/aapg/I-Class_auto_verifier/comp_script.sh spike.dump rtl.dump','>','temp.txt', shell=True)
    out = ""
    with open('temp.txt','r') as f:
        while(1):
            line = f.readline()
            if not line:
                break
            out = out + line + '\n'
    #print(out)
    diff_disass = out
    os.remove('temp.txt')
    
    #if(out==""):
    #    #print('empty diff')
    #    # Read rtl last line?
    #    if(os.path.exists('rtl.dump')):
    #        with open('rtl.dump','r') as sf:
    #            for line in sf.readlines()[-1:]:
    #                x = re.findall("8.*", line)
    #                x = x[0][:8]
    #                grep_check = x
    #                reason = "rtl hang due to -->"
    #else:
    #    x = re.findall("8.*", out)
    #    x = x[0][:8]
    #    grep_check = x
    #if grep_check != None and reason==None:
    #    cmd = 'grep '+grep_check+' '+name+'.disass > temp2.txt'
    #    os.system(cmd)
    #    out = ""
    #    with open('temp2.txt','r') as f:
    #        while(1):
    #            line = f.readline()
    #            if not line:
    #                break
    #            out = out + line + '\n'
    #    x = re.findall("8.*:\t.*\n", out)
    #    if(len(x)!=0):
    #        x = x[0]
    #    else:
    #        x = ''
    #    reason = "mismatch due to --> " + x
    #    os.remove('temp2.txt')
    #elif grep_check != None and reason != None:
    #    #print('here')
    #    cmd = 'grep -C 2 '+grep_check+' '+name+'.disass > temp2.txt'
    #    os.system(cmd)
    #    out = ""
    #    with open('temp2.txt','r') as f:
    #        while(1):
    #            line = f.readline()
    #            if not line:
    #                break
    #            out = out + line + '\n'
    #    diff_disass = out
    #    #print(diff_disass)
    #    x = re.findall(grep_check+'.*\n', out)
    #    if(len(x)!=0):
    #        x = x[0]
    #    else:
    #        x = ''
    #    reason_fix = diff_disass.split('\n')
    #    reason = "rtl hang from " + reason_fix[6]
    #    #print(reason)
    #    os.remove('temp2.txt')
    #    
    
    df_temp = pd.DataFrame({
        'test_dir': [name],
        'fail_reason': [reason],
        'diff_disass': [diff_disass]
    })
    final_df = final_df.append(df_temp)
    #print(df_temp)
    os.chdir(cur_dir)


# In[14]:


#print(final_df)
final_df.to_csv('final_df.csv',index=False)


# In[ ]:


#     try:
#         bin_string = subprocess.check_output('source /Users/abishek/Desktop/IIT_M_Winter/verification/comp_s spike.dump rtl.dump', shell=True,stderr=subprocess.STDOUT)
#     except subprocess.CalledProcessError as e:
#         raise RuntimeError("command '{}' return with error (code {}): {}".format(e.cmd, e.returncode, e.output))
#     print(bin_string)

