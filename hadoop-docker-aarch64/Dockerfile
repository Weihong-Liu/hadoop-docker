FROM ubuntu:20.04

LABEL maintainer="puppets"

WORKDIR /root

# 换源
# RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf
# mirrors.aliyun.com
RUN  sed -i s@/ports.ubuntu.com/@/mirrors.ustc.edu.cn/@g /etc/apt/sources.list
RUN apt-get clean all
RUN apt-get update


# install openssh-server, openjdk and wget
RUN apt-get autoremove openssh-client openssh-server
RUN apt-get  install -y openssh-client openssh-server wget vim net-tools 
RUN apt install -y iputils-ping
# installl mysql8
RUN apt-get install -y mysql-server mysql-client
RUN service mysql restart
# https://blog.csdn.net/yorickjun/article/details/121138160 mysql 配置

# install openresty
RUN apt-get -y install --no-install-recommends gnupg ca-certificates
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN echo "deb http://openresty.org/package/arm64/ubuntu $(lsb_release -sc) main" \
    | tee /etc/apt/sources.list.d/openresty.list
RUN apt-get update
RUN apt-get -y install openresty

# openresty 配置
RUN mkdir -p /usr/local/openresty/logs/user_logs/ /usr/local/openresty/conf/vhost
COPY nginx-config/nginx.conf /usr/local/openresty/conf/
COPY nginx-config/userlogs.conf /usr/local/openresty/conf/vhost/
RUN touch /usr/local/openresty/conf/mime.types
RUN mkdir /root/bin
COPY bin/* /root/bin/

# 数据生产脚本
COPY DataProduct/hkData.sh /usr/local/openresty/bin/
COPY DataProduct/logData.jar /usr/local/openresty/bin/
COPY DataProduct/userlog_service.sh /usr/local/openresty/bin/
COPY DataProduct/userlog.sh /usr/local/openresty/bin/
## 数据生产文件夹
RUN mkdir /opt/data 


# install hadoop 3.3.1
# RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1-aarch64.tar.gz && \
#     tar -xzvf hadoop-2.7.2.tar.gz && \
#     mv hadoop-2.7.2 /usr/local/hadoop && \
#     rm hadoop-2.7.2.tar.gz

# install jdk 1.8
# RUN wget https://gitee.com/Bric666/java/attach_files/803375/download/jdk-8u301-linux-aarch64.tar.gz && \
#     tar -xzvf jdk-8u301-linux-aarch64.tar.gz && \
#     mv jdk1.8.0_301 /usr/local/hadoop/ && \
#     rm jdk-8u301-linux-aarch64.tar.gz

ADD resources/hadoop-3.3.1-aarch64.tar.gz /usr/local/hadoop
ADD resources/jdk-8u301-linux-aarch64.tar.gz /usr/local/hadoop
ADD resources/scala-2.12.14.tgz /usr/local/hadoop
ADD resources/spark-3.2.1-bin-hadoop3.2.tgz /usr/local/hadoop
ADD resources/apache-zookeeper-3.6.3-bin.tar.gz /usr/local/hadoop
ADD resources/apache-hive-2.3.9-bin.tar.gz /usr/local/hadoop
ADD resources/apache-flume-1.9.0-bin.tar.gz /usr/local/hadoop
ADD resources/zeppelin-0.10.1-bin-all.tgz /usr/local/hadoop

RUN mv /usr/local/hadoop/hadoop-* /usr/local/hadoop/hadoop && \
    mv /usr/local/hadoop/jdk* /usr/local/hadoop/jdk1.8 && \
    mv /usr/local/hadoop/scala* /usr/local/hadoop/scala2.12 && \
    mv /usr/local/hadoop/spark* /usr/local/hadoop/spark3.2.1 &&\
    mv /usr/local/hadoop/apache-zookeeper* /usr/local/hadoop/zookeeper-3.6.3 &&\
    mv /usr/local/hadoop/apache-hive* /usr/local/hadoop/hive-2.3.9 &&\
    mv /usr/local/hadoop/apache-flume* /usr/local/hadoop/flume-1.9.0 &&\
    mv /usr/local/hadoop/zeppelin* /usr/local/hadoop/zeppelin-0.10.1

COPY zookeeper-config/zoo.cfg /usr/local/hadoop/zookeeper-3.6.3/conf/
COPY zookeeper-config/zkEnv.sh /usr/local/hadoop/zookeeper-3.6.3/bin/
COPY zookeeper-config/init_zookeeper_myid.sh /root/
RUN mkdir /usr/local/hadoop/zookeeper-3.6.3/data
COPY zeppelin-config/* /usr/local/hadoop/zeppelin-0.10.1/conf/
# RUN sed -i '30i\JAVA_HOME=/usr/loacl/hadoop/jdk1.8' /usr/local/hadoop/zookeeper-3.6.3/bin/zkEnv.sh


# set environment variable
ENV JAVA_HOME=/usr/local/hadoop/jdk1.8
RUN echo "export JAVA_HOME=/usr/local/hadoop/jdk1.8" >> ~/.bashrc
ENV JRE_HOME=$JAVA_HOME/jre
RUN echo "export JRE_HOME=\$JAVA_HOME/jre" >> ~/.bashrc
ENV CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib
RUN echo "export CLASSPATH=.:\$CLASSPATH:\$JAVA_HOME/lib:\$JRE_HOME/lib" >> ~/.bashrc
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
RUN echo "export PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin" >> ~/.bashrc

ENV HADOOP_HOME=/usr/local/hadoop/hadoop
RUN echo "export HADOOP_HOME=/usr/local/hadoop/hadoop" >> ~/.bashrc
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin 
RUN echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin " >> ~/.bashrc

ENV SCALA_HOME=/usr/local/hadoop/scala2.12
RUN echo "export SCALA_HOME=/usr/local/hadoop/scala2.12" >> ~/.bashrc
ENV PATH=$PATH:$SCALA_HOME/bin
RUN echo "export PATH=\$PATH:\$SCALA_HOME/bin" >> ~/.bashrc

ENV SPARK_HOME=/usr/local/hadoop/spark3.2.1
RUN echo "export SPARK_HOME=/usr/local/hadoop/spark3.2.1" >> ~/.bashrc
ENV PATH=$PATH:$SPARK_HOME/bin
RUN echo "export PATH=\$PATH:\$SPARK_HOME/bin" >> ~/.bashrc

ENV ZOOKEEPER_HOME=/usr/local/hadoop/zookeeper-3.6.3
RUN echo "export ZOOKEEPER_HOME=/usr/local/hadoop/zookeeper-3.6.3" >> ~/.bashrc
ENV PATH=$PATH:$ZOOKEEPER_HOME/bin
RUN echo "export PATH=\$PATH:\$ZOOKEEPER_HOME/bin" >> ~/.bashrc

ENV HIVE_HOME=/usr/local/hadoop/hive-2.3.9
RUN echo "export HIVE_HOME=/usr/local/hadoop/hive-2.3.9" >> ~/.bashrc
ENV PATH=$PATH:$HIVE_HOME/bin
RUN echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> ~/.bashrc
# hive 解决日志Jar包冲突
RUN mv $HIVE_HOME/lib/log4j-slf4j-impl-2.6.2.jar $HIVE_HOME/lib/log4j-slf4j-impl-2.6.2.bak
# jdbc.jar
COPY hive-config/mysql-connector-java-5.1.49.jar $HIVE_HOME/lib
# hive-site.xml
COPY hive-config/hive-site.xml $HIVE_HOME/conf
# hive 初始化元数据库
# RUN $HIVE_HOME/bin/schematool -initSchema -dbType mysql -verbose

ENV FLUME_HOME=/usr/local/hadoop/flume-1.9.0
RUN echo "export FLUME_HOME=/usr/local/hadoop/flume-1.9.0" >> ~/.bashrc
ENV PATH=$PATH:$FLUME_HOME/bin
RUN echo "export PATH=\$PATH:\$FLUME_HOME/bin" >> ~/.bashrc
RUN apt-get -y install netcat-traditional
RUN mkdir $FLUME_HOME/job
COPY flume-config/* $FLUME_HOME/job

ENV ZEPPELIN_HOME=/usr/local/hadoop/zeppelin-0.10.1
RUN echo "export ZEPPELIN_HOME=/usr/local/hadoop/zeppelin-0.10.1" >> ~/.bashrc
ENV PATH=$PATH:$ZEPPELIN_HOME/bin
RUN echo "export PATH=\$PATH:\$ZEPPELIN_HOME/bin" >> ~/.bashrc


# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs && \
    mkdir $HADOOP_HOME/tmp

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers && \
    mv /tmp/myhadoop.sh ~/myhadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/*.sh && \
    chmod +x ~/bin/*.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x /usr/local/openresty/bin/*.sh

RUN sed -i 1a\HDFS_DATANODE_USER=root $HADOOP_HOME/sbin/start-dfs.sh && \
    sed -i 2a\HDFS_NAMENODE_USER=root $HADOOP_HOME/sbin/start-dfs.sh && \
    sed -i 3a\HDFS_SECONDARYNAMENODE_USER=root $HADOOP_HOME/sbin/start-dfs.sh && \
    sed -i 4a\YARN_RESOURCEMANAGER_USER=root $HADOOP_HOME/sbin/start-dfs.sh && \
    sed -i 5a\YARN_NODEMANAGER_USER=root $HADOOP_HOME/sbin/start-dfs.sh && \
    sed -i 1a\HDFS_DATANODE_USER=root $HADOOP_HOME/sbin/stop-dfs.sh && \
    sed -i 2a\HDFS_NAMENODE_USER=root $HADOOP_HOME/sbin/stop-dfs.sh && \
    sed -i 3a\HDFS_SECONDARYNAMENODE_USER=root $HADOOP_HOME/sbin/stop-dfs.sh && \
    sed -i 4a\YARN_RESOURCEMANAGER_USER=root $HADOOP_HOME/sbin/stop-dfs.sh && \
    sed -i 5a\YARN_NODEMANAGER_USER=root $HADOOP_HOME/sbin/stop-dfs.sh && \
    sed -i 1a\YARN_RESOURCEMANAGER_USER=root $HADOOP_HOME/sbin/start-yarn.sh && \
    sed -i 2a\HADOOP_SECURE_DN_USER=yarn $HADOOP_HOME/sbin/start-yarn.sh && \
    sed -i 3a\YARN_NODEMANAGER_USER=root $HADOOP_HOME/sbin/start-yarn.sh && \
    sed -i 1a\YARN_RESOURCEMANAGER_USER=root $HADOOP_HOME/sbin/stop-yarn.sh && \
    sed -i 2a\HADOOP_SECURE_DN_USER=yarn $HADOOP_HOME/sbin/stop-yarn.sh && \
    sed -i 3a\YARN_NODEMANAGER_USER=root $HADOOP_HOME/sbin/stop-yarn.sh

RUN cat /tmp/profile >> /etc/profile && \
    rm -rf $HADOOP_HOME/share/doc

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]



