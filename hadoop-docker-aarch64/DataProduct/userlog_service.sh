#!/bin/bash


##帮助文档
ulogs_service_help() {
  echo "input command parameter: {start | stop | restart }"
}


### 服务开启：用户行为日志数据模拟制造 服务  #################################################################

##服务开启
ulogs_start() {
  /usr/local/openresty/bin/userlog.sh
  echo "ulogs service starting..."
}



### 服务停止：用户行为日志数据模拟制造 服务 #################################################################

##服务停止
ulogs_stop() {
  ps -ef | grep 'hkData*' | grep -v grep | awk '{print $2}'| xargs kill -9 
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
