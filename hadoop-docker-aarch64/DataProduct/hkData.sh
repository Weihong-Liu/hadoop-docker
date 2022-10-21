#!/bin/bash
##这里的nginx端口要和上面配置的一致
url=http://localhost:8802/data/userlogs
sleep=5000
begin=`date -d "0 day" +"%Y%m%d"`
end=`date -d "+1 day" +"%Y%m%d"`

java -jar /usr/local/openresty/bin/logData.jar  \
-- --url $url   \
--sleep $sleep \
-- --begin $begin \
-- --end $end
