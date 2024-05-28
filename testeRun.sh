#!/bin/bash
numCli=1
numServer=1
duration=1
locality=80
#rm -f -r logs/*  files/*; kill -l "java.*Main*"; ant clean; ant;

#Monta comando SSH
SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

COMMAND="screen -d -m -L -Logfile $LOG_FILE -S node0"
COMMAND+=" $SSH_COMMAND node1" java -cp "bin/*:lib/*" MainServer -i 1 -d $duration -c $numCli
echo $COMMAND

# Start clients
java -cp "bin/*:lib/*" MainClient -c $numCli -i 0  -d $duration -t -l $locality -w 0 >> logs/cli0.txt &

echo started $numCli clients >> logs/executions.log

echo "waiting..."  >> logs/executions.log;
while :
do
    sleep 1;
    nodeFiles=`find files/ -name 'NodeFinished*' | wc -l`
    if [ "$nodeFiles" -ge $numServer ]; then sleep 1; break; fi
done
echo "all nodes done"  >> logs/executions.log; kill -l "java.*Main*"; echo "processes killed"  >> logs/executions.log
