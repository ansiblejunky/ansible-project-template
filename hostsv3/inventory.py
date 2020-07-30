#!/usr/bin/env python

import argparse
import json
import sys
import shelve
import ConfigParser

def parse_args():
    parser = argparse.ArgumentParser(description="Shelve inventory script")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--list', action='store_true')
    group.add_argument('--host')
    return parser.parse_args()

def get_shelve_groups(shelvefile):
    d = shelve.open(shelvefile)
    g = d["groups"]
    d.close()
    return g

def get_shelve_host_details(shelvefile, host):
    d = shelve.open(shelvefile)
    h = d["hostvars"][host]
    d.close()
    return h

def main():

    config = ConfigParser.RawConfigParser()
    config.read('shelve_inventory.ini')
    shelvefile = config.get('defaults', 'shelvefile')

    args = parse_args()
    if args.list:
        groups = get_shelve_groups(shelvefile)
        json.dump(groups, sys.stdout)
    else:
        details = get_shelve_host_details(shelvefile, args.host)
        json.dump(details, sys.stdout)

if __name__ == '__main__':
    main()

