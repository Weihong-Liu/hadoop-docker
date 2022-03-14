#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop hadoop-master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 9870:9870 \
                -p 8088:8088 \
				-p 4040:4040 \
                --name hadoop-master \
                --hostname hadoop-master \
                puppets/hadoop:1.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
					--net=hadoop \
					--name hadoop-slave$i \
					--hostname hadoop-slave$i \
					puppets/hadoop:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash


# docker run -itd --net=hadoop --name hadoop-slave1 --hostname hadoop-slave1 puppets/hadoop:1.0
# docker run -itd --net=hadoop --name hadoop-slave2 --hostname hadoop-slave2 puppets/hadoop:1.0