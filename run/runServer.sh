#!/bin/bash
ID=$1
echo id: $ID
duration=$2
echo duration: $duration
numCli=$3
echo numCli: $numCli
cd /opt/estudoSkeen
java -cp "bin/*:lib/*" MainServer -i $ID -d $duration -c $numCli