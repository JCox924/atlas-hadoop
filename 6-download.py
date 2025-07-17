#!/usr/bin/python2.7
"""
6-download.py

Defines a function `download(l)` which uses the Snakebite client
to fetch files from HDFS and place them in the local /tmp directory.
"""

from snakebite.client import Client

def download(paths):
    """
    Download each HDFS path in `paths` into /tmp, printing a status dict.

    :param paths: List of HDFS file paths to download (e.g. ["/holbies/input/lao.txt"])
    """
    # connect to NameNode on localhost:9000 (adjust host/port if needed)
    client = Client('localhost', 9000)

    # fetch each file; client.get returns a generator of status dicts
    for result in client.get(paths, '/tmp'):
        print(result)
