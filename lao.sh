#!/bin/bash

# Upload lao.txt to /holbies/input on HDFS
hadoop fs -put -f lao.txt /holbies/input/

echo "Uploaded file:"
hadoop fs -ls /holbies/input
