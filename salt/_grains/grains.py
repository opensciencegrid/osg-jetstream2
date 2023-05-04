#!/usr/bin/python3
  
import os
import re

def custom_grains():
    grains = {}

    grains['roles'] = []

    grains['roles'].append('common')

    # use hostname for now
    hostname = os.uname()[1]

    if re.search('control', hostname, re.IGNORECASE):
        grains['roles'].append('control')
    elif re.search('frontier-squid', hostname, re.IGNORECASE):
        grains['roles'].append('frontier-squid')
    elif re.search('worker', hostname, re.IGNORECASE):
        grains['roles'].append('worker')
    elif re.search('update|upgrade', hostname, re.IGNORECASE):
        grains['roles'].append('worker')

    return grains

