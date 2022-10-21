#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop hadoop-master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 9870:9870 \
				-p 4040:4040 \
				-p 8802:8802 \
				-p 28080:28080 \
				-p 8888:8888 \
                --name hadoop-master \
                --hostname hadoop-master \
                puppets/hadoop:3.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	if [ $i eq 2];then
		sudo docker run -itd \
						--net=hadoop \
						-p 8088:8088 \
						--name hadoop-slave$i \
						--hostname hadoop-slave$i \
						puppets/hadoop:3.0 &> /dev/null
	else
		sudo docker run -itd \
						--net=hadoop \
						--name hadoop-slave$i \
						--hostname hadoop-slave$i \
						puppets/hadoop:3.0 &> /dev/null
	fi
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash


# docker run -itd --net=hadoop --name hadoop-slave1 --hostname hadoop-slave1 puppets/hadoop:1.0
# docker run -itd --net=hadoop --name hadoop-slave2 --hostname hadoop-slave2 puppets/hadoop:1.0



# docker run --restart always -p 3306:3306 --name mysql8 \
# --net=hadoop \
# --hostname mysql8 \
# -v /mnt/sda1/zrb/docker/mysql/conf/my.cnf:/etc/mysql/my.cnf \
# -v /mnt/sda1/zrb/docker/mysql/logs:/logs \
# -v /mnt/sda1/zrb/docker/mysql/mysql:/var/lib/mysql \
# -e MYSQL_ROOT_PASSWORD=123456 \
# -d mysql/mysql-server:latest 


"PortBindings":{}