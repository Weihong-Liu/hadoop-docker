#!/bin/bash

##帮助文档
openresty_service_help() {
  echo "input command parameter: {start | stop | reload }"
}


### Nginx服务开启 #################################################################
openresty_start() {
  openresty -p /usr/local/openresty/
  echo "openresty service starting..."
}



### Nginx服务停止 #################################################################
openresty_stop() {
  openresty -p /usr/local/openresty/ -s stop
  echo "openresty service stoping..."
}


### Nginx服务重启 #################################################################
openresty_reload() {
  openresty -p /usr/local/openresty/ -s reload
  echo "openresty service reloading..."
}


### main #################################################################

main() {
  #echo "Welcome to Openresty services"

  case "${1:-}" in

    start)
      openresty_start
      ;;

    stop)
      openresty_stop
      ;;

    reload)
      openresty_reload
      ;;


    help)
      openresty_service_help
      ;;

    *)
      openresty_service_help
      ;;
  esac
}


main "$@"

