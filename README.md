# hadoop-docker

本项目主要是通过docker搭建Hadoop分布式集群

[hadoop-docker-aarch64](https://github.com/Weihong-Liu/hadoop-docker/tree/main/hadoop-docker-aarch64) => 适配MacOS M1芯片 以及 arm64架构

[hadoop-docker-x86_64](https://github.com/Weihong-Liu/hadoop-docker/tree/main/hadoop-docker-x86_64) => 适配x86架构

## X86架构
```
docker push puppets/hadoop:1.0

./start-container.sh # 创建容器（默认3个，hadoop-master、hadoop-slave1、hadoop-slave2）
```

## ARM64架构
```
docker push puppets/hadoop_arm64:1.0

./start-container.sh # 创建容器（默认3个，hadoop-master、hadoop-slave1、hadoop-slave2）
```

## 文件说明

`start-docker-hadoop.sh`启动容器并进入hadoop-master主机节点

`stop-docker-hadoop.sh`停止运行容器
