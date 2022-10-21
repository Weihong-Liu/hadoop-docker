#!/bin/bash
# 数据收集脚本

##集群节点数量(节点名称规则：bigdata2sparkX,X为机器编号,如01,02,03等)
nodeNums=2


##帮助文档
ulogs_service_help() {
  echo "input command parameter: {start | stop | restart }"
}


### 服务开启：用户行为日志数据模拟制造 服务  #################################################################

##服务开启
ulogs_start() {
    ssh root@hadoop-master "/usr/local/openresty/bin/userlog.sh"
    for((i=1; i<=nodeNums; i++));
    do
        nodeName="hadoop-slave"$i
        ssh root@$nodeName "/usr/local/openresty/bin/userlog.sh"
    done
    echo "ulogs service starting..."
}



### 服务停止：用户行为日志数据模拟制造 服务 #################################################################

##服务停止
ulogs_stop() {
    ssh root@hadoop-master "ps -ef | grep 'hkData*' | grep -v grep | awk '{print $2}'| xargs kill -9 "
  for((i=1; i<=nodeNums; i++));
  do
	nodeName="hadoop-slave"$i
	ssh root@$nodeName "ps -ef | grep 'hkData*' | grep -v grep | awk '{print $2}'| xargs kill -9 "
  done
  echo "ulogs service stoping..."
}



### main #################################################################

main() {
  #echo "Welcome to data services"

  case "${1:-}" in

    start)
      ulogs_start
      ;;

    stop)
      ulogs_stop
      ;;

    restart)
      ulogs_stop
      ulogs_start
      ;;


    help)
      ulogs_service_help
      ;;

    *)
      ulogs_service_help
      ;;
  esac
}


main "$@"

