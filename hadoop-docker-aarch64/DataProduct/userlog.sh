#!/bin/bash

url=localhost:8802/data/userlogs
sleep=10

/usr/local/hadoop/jdk1.8/bin/java -jar /usr/local/openresty/bin/logData.jar \
--url $url \
--sleep $sleep
