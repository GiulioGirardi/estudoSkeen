#!/bin/bash
numCli=2
duration=1
locality=80

USERNAME="root"

SCRIPT=$(java -cp "bin/*:lib/*" MainClient -c "${numCli}" -i 0  -d "${duration}" -t -l "${locality}" -w 0 >> logs/cli0.txt &
         java -cp "bin/*:lib/*" MainClient -c "${numCli}" -i 1  -d "${duration}" -t -l "${locality}" -w 0 >> logs/cli1.txt &)

((START = "${numCli}"))
for ((i = START; i > 0; i-=1)) ; do
    sudo ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -l ${USERNAME} "node${i}" "${SCRIPT}"
done