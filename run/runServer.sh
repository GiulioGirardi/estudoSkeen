#!/bin/bash

ID=$1
shift 1
duration=$1
shift 1
numCli=$1
shift 1

java -cp "bin/*:lib/*" MainServer -i "${ID}" -d "${duration}" -c "${numCli}" >> logs/node"${ID}".txt & sleep .05