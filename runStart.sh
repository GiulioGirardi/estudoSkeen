#!/bin/bash
numCli=2
numServer=2
duration=1
locality=80
#Monta comando SSH
#SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
#
#COMMAND="screen -d -m -L -Logfile $LOG_FILE -S node0"
#COMMAND+=" $SSH_COMMAND node1" java -cp "bin/*:lib/*" MainServer -i 1 -d $duration -c $numCli
#echo $COMMAND
USERNAME="root"

#HOSTS="node1"
#SCRIPT=$(java -cp "bin/*:lib/*" MainServer -i 1 -d $duration -c $numCli >> logs/node1.txt & sleep .05)
#ssh -o UserKnownHostsFile=/dev/null -l ${USERNAME} ${HOSTS} "${SCRIPT}"

((START = "${numServer}"))
for ((i = START; i > 0; i-=1)) ; do
    ssh -o UserKnownHostsFile=/dev/null -l ${USERNAME} "node${i}" "$(java -cp "bin/*:lib/*" MainServer -i "${i}" -d $duration -c "${numCli}" >> logs/node$i.txt & sleep .05)"
done

echo started $numServer servers >> logs/servers.log

java -cp "bin/*:lib/*" MainClient -c $numCli -i 0  -d $duration -t -l $locality -w 0 >> logs/cli0.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 1  -d $duration -t -l $locality -w 0 >> logs/cli1.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 2  -d $duration -t -l $locality -w 0 >> logs/cli2.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 3  -d $duration -t -l $locality -w 0 >> logs/cli3.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 4  -d $duration -t -l $locality -w 0 >> logs/cli4.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 5  -d $duration -t -l $locality -w 0 >> logs/cli5.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 6  -d $duration -t -l $locality -w 0 >> logs/cli6.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 7  -d $duration -t -l $locality -w 0 >> logs/cli7.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 8  -d $duration -t -l $locality -w 0 >> logs/cli8.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 9  -d $duration -t -l $locality -w 0 >> logs/cli9.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 10 -d $duration -t -l $locality -w 0 >> logs/cli10.txt &
java -cp "bin/*:lib/*" MainClient -c $numCli -i 11 -d $duration -t -l $locality -w 0 >> logs/cli11.txt &

echo started $numCli clients >> logs/executions.log


while :
do
    sleep 1;
    nodeFiles=`find ./files -name 'NodeFinished*' | wc -l`
    if [ "$nodeFiles" -ge $numServer ]; then sleep 1; break; fi
done
echo "all nodes done"  >> logs/executions.log; pkill -f 'java.*Main*'; echo "processes killed"  >> logs/executions.log