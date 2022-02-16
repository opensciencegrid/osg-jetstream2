#!/usr/bin/python3

import openstack
import re
import sys
import time
import os

from datetime import datetime, timedelta
from dateutil import parser, tz

from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse

from pprint import pprint

# consts
MAX_INSTANCES_TOTAL = 60
MAX_INSTANCES_AUTOSCALE = 10

app = FastAPI()

cloud = openstack.connect(cloud='openstack')

def instances():
    '''
    returns a list of current instances, and in the process
    cleans out old ones
    '''

    i = {"counts": {}, "instances": {}}
    i["counts"]["total_instances"] = 0

    for server in cloud.compute.servers():
        #print(server)
        if not re.match('^osg-worker', server.name):
            continue

        created_at = parser.parse(server.created_at, ignoretz=True)
        if not 'updated' in server:
            server.updated = server.created_at
        last_update = parser.parse(server.updated, ignoretz=True)
        now = datetime.utcnow()

        if server.status == 'SHUTOFF' or server.status == 'ERROR':
            # remove the server
            print('     ... deleting server')
            cloud.delete_server(server)
            continue
    
        # sometimes the instances get stuck in BUILD state
        if server.status == 'BUILD' and created_at < now - timedelta(hours=2):
            # remove the server
            print('     ... deleting server')
            cloud.delete_server(server)
            continue
    
        # just stuck
        if last_update < now - timedelta(days=2):
            # remove the server
            print('     ... seems stuck, deleting server')
            cloud.delete_server(server)
            continue

        #print(server)
    
        if server.status == 'ACTIVE' or server.status == 'BUILD':
            i["counts"]["total_instances"] += 1

            i["instances"][server.name] = server

            continue

    return i


def add(n):

    ins = instances()
    if ins["counts"]["total_instances"] + n > MAX_INSTANCES_TOTAL:
        n = MAX_INSTANCES_TOTAL - ins["counts"]["total_instances"] 
    if n <= 0:
        return 0

    # select image to use
    image_selected = None
    for i in cloud.compute.images():
        if not re.match('^osg-worker-', i.name):
            continue
        if image_selected is None or \
           i.name > image_selected.name:
            image_selected = i
    print('Selected %s for a new instance' %(image_selected.name))

    flavor = cloud.compute.find_flavor('m3.medium')

    network = cloud.network.find_network('private')

    keypair = cloud.compute.find_keypair('rynge-2020')

    dt = datetime.now()
    basename = 'osg-worker-%s' %(dt.strftime('%Y%m%d%H%M%S'))

    for i in range(n):
        name = "{}-{}".format(basename, i)
        print('Starting a new instance with name %s' %(name))
        cloud.create_server(name, \
                            image=image_selected, \
                            flavor=flavor, \
                            network=[network], \
                            key_name='rynge-2020', \
                            auto_ip=False)
    return n


def remove(n):
    # n could be given as a negative
    n = abs(n)
    ins = instances()
    if ins["counts"]["total_instances"] - n < MAX_INSTANCES_AUTOSCALE:
        n = ins["counts"]["total_instances"] - MAX_INSTANCES_AUTOSCALE 
    if n <= 0:
        return 0

    # remove the oldest ones
    for i in range(n):
        oldest_name = None
        oldest_id = None
        oldest_ts = None
        for name, s in ins["instances"].items():
            ts = parser.parse(s.created_at, ignoretz=True)
            if oldest_ts is None or ts < oldest_ts:
                oldest_name = s.name
                oldest_id = s.id
                oldest_ts = ts
        print("Remove server {}".format(oldest_name))
        # we now have the oldest one to remove
        try:
            cloud.compute.delete_server(oldest_id)
        except:
            pass
        ins["instances"].pop(oldest_name)

    return n

def auth(token):
    if token != os.environ['RESTAPI_TOKEN']:
        raise HTTPException(status_code=400, detail="Invalid token")

@app.get("/status/", response_class=HTMLResponse)
async def status(token: str):
    auth(token)
    i = instances()
    msg = "Instances: {}, CPUs: {}, Autoscale instance target: {}\n".format(
            i["counts"]["total_instances"],
            i["counts"]["total_instances"] * 6,
            MAX_INSTANCES_AUTOSCALE)
    return msg

@app.get("/scale/", response_class=HTMLResponse)
async def status(token: str, adjustment: int):
    auth(token)
    changed = 0
    if adjustment > 0:
        changed = add(adjustment)
    else:
         changed = remove(adjustment)
    if abs(adjustment) - abs(changed) == 0:
        msg = "Ok\n"
    else:
        msg = "Unable to fully complete the request. Actual change: {}\n".format(
                abs(changed))
    return msg

@app.get("/autoscale/", response_class=HTMLResponse)
async def status(token: str):
    auth(token)
    i = instances()

    # slow start
    max_add = i["counts"]["total_instances"] * 2 + 1
    max_add = min(max_add, 10)

    delta = MAX_INSTANCES_AUTOSCALE - i["counts"]["total_instances"]

    to_add = min(delta, max_add)

    if to_add > 0:
        add(to_add)
        return "Ok - added {}\n".format(to_add)

    return "Ok\n"


