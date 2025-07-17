#!/bin/bash

# Create directories /holbies and /holbies/input in HDFS
hadoop fs -mkdir -p /holbies/input

echo "Created directories:"
hadoop fs -ls -R /
