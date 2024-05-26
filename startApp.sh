numCli=12
numServer=6
duration=1
locality=80
rm -f -r logs/*  files/*; kill -l "java.*Main*"; ant clean; ant;

EID=$(date +%s)
echo "+Experiment ID: $EID"
LOGS_DIR="./logs/$EID"
mkdir -p $LOGS_DIR

# Start servers
ID=1
((START = $numServer-1))
for ((i = START; i >= 0; i-=1)) ; do
    HOST_TARGET="node.$i"
    SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
    LOG_FILE="$LOGS_DIR/a.$ID"
    COMMAND="screen -d -m -L -Logfile $LOG_FILE -S a$ID.node0"
    COMMAND+=" $SSH_COMMAND $HOST_TARGET bin/*;lib/*  MainServer -i $i -d $duration -c $numCli " 
# screen -d -m -L -LogFile <nome_arq_log> -S a<ID>.<ENDEREÇO>
#  ssh -o StrictHostKeyChecking=no <endereço_maquina_alvo> <binário com todas as flags>
    java -cp "bin/*;lib/*" MainServer -i $i -d $duration -c $numCli >> logs/node$i.txt & sleep .05

# Run the command
        echo "+Starting agent p$ID at $HOST_TARGET , log at: $LOG_FILE"
        echo $ $COMMAND
        $COMMAND

        ID=$((ID + 1))
done
# echo started $numServer servers >> logs/executions.log





# Start clients
java -cp "bin/*;lib/*" MainClient -c $numCli -i 0  -d $duration -t -l $locality -w 0 >> logs/cli0.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 1  -d $duration -t -l $locality -w 1 >> logs/cli1.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 2  -d $duration -t -l $locality -w 2 >> logs/cli2.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 3  -d $duration -t -l $locality -w 3 >> logs/cli3.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 4  -d $duration -t -l $locality -w 4 >> logs/cli4.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 5  -d $duration -t -l $locality -w 5 >> logs/cli5.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 6  -d $duration -t -l $locality -w 0 >> logs/cli6.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 7  -d $duration -t -l $locality -w 1 >> logs/cli7.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 8  -d $duration -t -l $locality -w 2 >> logs/cli8.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 9  -d $duration -t -l $locality -w 3 >> logs/cli9.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 10 -d $duration -t -l $locality -w 4 >> logs/cli10.txt &
java -cp "bin/*;lib/*" MainClient -c $numCli -i 11 -d $duration -t -l $locality -w 5 >> logs/cli11.txt &

echo started $numCli clients >> logs/executions.log

echo "waiting..."  >> logs/executions.log;
while :
do
    sleep 1;
    nodeFiles=`find files/ -name 'NodeFinished*' | wc -l`
    if [ "$nodeFiles" -ge $numServer ]; then sleep 1; break; fi
done
echo "all nodes done"  >> logs/executions.log; kill -l "java.*Main*"; echo "processes killed"  >> logs/executions.log
