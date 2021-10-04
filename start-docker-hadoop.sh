#!/bin/bash
docker start hadoop-master hadoop-slave1 hadoop-slave2
docker exec -it hadoop-master bash
