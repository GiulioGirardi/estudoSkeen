numCli=12
numServer=6
duration=1
locality=80
rm -f -r logs/*  files/*; kill -l "java.*Main*"; ant clean; ant;

LOG_FILE="logs/teste.txt"
HOST_MAIN="node0"
echo $HOST_MAIN

#Monta comando SSH
SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

COMMAND="screen -d -m -L -Logfile $LOG_FILE -S a0.$HOST_MAIN"
COMMAND+=" $SSH_COMMAND "node1" java -cp "bin/*:lib/*" MainServer -i 1 -d $duration -c $numCli >> logs/node1.txt & sleep .05"

$COMMAND

# Start clients
java -cp "bin/*:lib/*" MainClient -c $numCli -i 0  -d $duration -t -l $locality -w 0 >> logs/cli0.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 1  -d $duration -t -l $locality -w 1 >> logs/cli1.txt &

echo started $numCli clients >> logs/executions.log

echo "waiting..."  >> logs/executions.log;
while :
do
    sleep 1;
    nodeFiles=`find files/ -name 'NodeFinished*' | wc -l`
    if [ "$nodeFiles" -ge $numServer ]; then sleep 1; break; fi
done
echo "all nodes done"  >> logs/executions.log; kill -l "java.*Main*"; echo "processes killed"  >> logs/executions.log
