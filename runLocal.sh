numCli=12
numServer=6
duration=60
locality=80
rm -f -r logs/*  files/*; pkill -f 'java.*Main*'; ant clean; ant;

i=0
while [ "$i" -lt $numServer ]
do
  #sudo ssh -o StrictHostKeyChecking=no "root@node${i}" "$(java -cp "bin/*:lib/*" MainServer -i "${i}" -d $duration -c $numCli >> logs/node"${i}".txt & sleep .05)"
  sudo ssh "root@node${i}" java -cp "bin/*:lib/*" MainServer -i "${i}" -d $duration -c $numCli >> logs/node"${i}".txt & sleep .05
  i=$((i + 1))
done
## Start servers
#((START = "${numServer}"-1))
#for ((i = START; i >= 0; i-=1)) ; do
#  sudo ssh -o StrictHostKeyChecking=no "root@node${i}" "$(java -cp "bin/*:lib/*" MainServer -i "${i}" -d $duration -c $numCli >> logs/node"${i}".txt & sleep .05)"
#done
echo started $numServer servers >> logs/executions.log

# Start clients
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 0  -d $duration -t -l $locality -w 0 >> logs/cli0.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 1  -d $duration -t -l $locality -w 1 >> logs/cli1.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 2  -d $duration -t -l $locality -w 2 >> logs/cli2.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 3  -d $duration -t -l $locality -w 3 >> logs/cli3.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 4  -d $duration -t -l $locality -w 4 >> logs/cli4.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 5  -d $duration -t -l $locality -w 5 >> logs/cli5.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 6  -d $duration -t -l $locality -w 0 >> logs/cli6.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 7  -d $duration -t -l $locality -w 1 >> logs/cli7.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 8  -d $duration -t -l $locality -w 2 >> logs/cli8.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 9  -d $duration -t -l $locality -w 3 >> logs/cli9.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 10 -d $duration -t -l $locality -w 4 >> logs/cli10.txt &
sudo java -cp "bin/*:lib/*" MainClient -c $numCli -i 11 -d $duration -t -l $locality -w 5 >> logs/cli11.txt &

echo started $numCli clients >> logs/executions.log

echo "waiting..."  >> logs/executions.log;
while :
do
    sleep 1;
    nodeFiles=`find ./files -name 'NodeFinished*' | wc -l`
    if [ "$nodeFiles" -ge $numServer ]; then sleep 1; break; fi
done
echo "all nodes done"  >> logs/executions.log; pkill -f 'java.*Main*'; echo "processes killed"  >> logs/executions.log