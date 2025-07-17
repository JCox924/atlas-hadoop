#!/usr/bin/python2.7
"""
5-deletedir.py

Defines a function `deletedir(l)` which uses the Snakebite client
to remove a list of directories in HDFS, deleting children before parents.
"""

from snakebite.client import Client

def deletedir(paths):
    """
    Remove each directory in `paths` on HDFS.

    :param paths: List of HDFS directory paths to delete (e.g. ["/foo", "/foo/bar"])
    """
    # connect to NameNode on localhost:9000 (adjust host/port if needed)
    client = Client('localhost', 9000)

    # delete deeper paths first so parents are empty when we remove them
    for path in sorted(paths, key=lambda p: p.count('/'), reverse=True):
        # recursive=True in case directory is non-empty
        for result in client.delete([path], recursive=True):
            print(result)
