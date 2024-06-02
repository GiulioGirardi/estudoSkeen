#!/bin/bash
numCli=2
numServer=2
duration=120

USERNAME="root"
#>> logs/node{i}.txt & sleep .05 &)
((START=$numServer))
for ((i=START; i>0; i-=1)) ; do
        SCRIPT=$(sudo java -cp "bin/*:lib/*" MainServer -i ${i} -d $duration -c ${numCli})
        #sudo ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "root@node1" ${SCRIPT}
        sudo ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "root@node${i}" "${SCRIPT}"
#$(sudo java -cp "bin/*:lib/*" MainServer -i "${i}" -d $duration -c "${numCli}" sleep .05 &)"
        echo "passo aqui!"
        #sudo ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${USERNAME} "node${i}" "$(sudo java -cp "bin/*:lib/*" MainServer -i "${i}" -d $duration -c "${numCli}" sleep .05 &)"
done

while :
do
    sleep 1;
    nodeFiles=`find ./files -name 'NodeFinished*' | wc -l`
    if [ "$nodeFiles" -ge $numServer ]; then sleep 1; break; fi
done
echo "all nodes done"  >> logs/executions.log; pkill -f 'java.*Main*'; echo "processes killed"  >> logs/executions.log