#!/usr/bin/python2.7
"""
4-createdir.py

Defines a function `createdir(l)` which uses the Snakebite client
to create a list of directories in HDFS, printing out the result
for each path.
"""

from snakebite.client import Client

def createdir(paths):
    """
    Create each directory in `paths` on HDFS, with parents.

    :param paths: List of HDFS directory paths to create (e.g. ["/foo", "/foo/bar"])
    """
    # connect to NameNode on localhost:9000 (adjust port if your HDFS RPC port differs)
    client = Client('localhost', 9000)

    # Use create_parent=True to mimic `mkdir -p`
    for result in client.mkdir(paths, create_parent=True):
        print(result)
