#! /bin/bash
case $1 in
"start")
	for host in hadoop-master hadoop-slave1 hadoop-slave2
	do
		echo "==========start $host zookeeper============"
		ssh $host "/usr/local/hadoop/zookeeper-3.6.3/bin/zkServer.sh start"
	done
;;

"stop")
	for host in hadoop-master hadoop-slave1 hadoop-slave2
	do
		echo "==========stop $host zookeeper============"
		ssh $host "/usr/local/hadoop/zookeeper-3.6.3/bin/zkServer.sh stop"
	done
;;

"status")
	for host in hadoop-master hadoop-slave1 hadoop-slave2
	do
		echo "==========status $host zookeeper============"
		ssh $host "/usr/local/hadoop/zookeeper-3.6.3/bin/zkServer.sh status"
	done
;;

esac

