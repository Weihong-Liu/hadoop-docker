#!/bin/bash
# $HADOOP_HOME/sbin/start-all.sh
# echo -e "\n"

# $HADOOP_HOME/sbin/start-dfs.sh

# echo -e "\n"

# $HADOOP_HOME/sbin/start-yarn.sh

# echo -e "\n"

#!/bin/bash
 
if [ $# -lt 1 ]
then
    echo "No Args Input..."
    exit ;
fi
 
case $1 in
"start")
        echo " =================== 启动 hadoop集群 ==================="
 
        echo " --------------- 启动 hdfs ---------------"
        ssh hadoop-master "/usr/local/hadoop/hadoop/sbin/start-dfs.sh"
        echo " --------------- 启动 yarn ---------------"
        ssh hadoop-slave2 "/usr/local/hadoop/hadoop/sbin/start-yarn.sh"
#        echo " --------------- 启动 historyserver ---------------"
 #       ssh hadoop-master "/usr/local/hadoop/hadoop/bin/mapred --daemon start historyserver"
;;
"stop")
        echo " =================== 关闭 hadoop集群 ==================="
 
  #      echo " --------------- 关闭 historyserver ---------------"
  #     ssh hadoop-master "/usr/local/hadoop/hadoop/bin/mapred --daemon stop historyserver"
        echo " --------------- 关闭 yarn ---------------"
        ssh hadoop-slave2 "/usr/local/hadoop/hadoop/sbin/stop-yarn.sh"
        echo " --------------- 关闭 hdfs ---------------"
        ssh hadoop-master "/usr/local/hadoop/hadoop/sbin/stop-dfs.sh"
;;
*)
    echo "Input Args Error..."
;;
esac
