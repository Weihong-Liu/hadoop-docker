#!/bin/bash

# 执行jps命令查询每台服务器上的节点状态
echo ======================集群节点状态====================

for i in hadoop-master hadoop-slave1 hadoop-slave2
do
        echo ====================== $i ====================
        ssh $i '/usr/local/hadoop/jdk1.8/bin/jps'
done
echo ======================执行完毕====================