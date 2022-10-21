#!/bin/bash
i=1
for host in hadoop-master hadoop-slave1 hadoop-slave2
	do
		echo "==========start $host initzookeeper============"
		ssh $host "touch /usr/local/hadoop/zookeeper-3.6.3/data/myid;echo $i > /usr/local/hadoop/zookeeper-3.6.3/data/myid"
        i=$(( $i + 1 ))
	done