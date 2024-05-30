#!/bin/bash
numCli=2
numServer=2
duration=1

USERNAME="root"

((START = "${numServer}"))
for ((i = START; i > 0; i-=1)) ; do
    sudo ssh -l ${USERNAME} "node${i}" "$(java -cp "bin/*:lib/*" MainServer -i "${i}" -d $duration -c "${numCli}" >> logs/node"${i}".txt & sleep .05)"
done

while :
do
    sleep 1;
    nodeFiles=`find ./files -name 'NodeFinished*' | wc -l`
    if [ "$nodeFiles" -ge $numServer ]; then sleep 1; break; fi
done
echo "all nodes done"  >> logs/executions.log; pkill -f 'java.*Main*'; echo "processes killed"  >> logs/executions.log