## 大数据架构

### 1.Hadoop集群 (hadoop-master)

```shell
~/myhadoop.sh start
```

### 2.zookeeper (hadoop-master)
初始化各个节点id
```shell
bash /root/init_zookeeper_myid.sh
```
启动zookeeper
```shell
bash /root/bin/zk.sh start
```
停止zookeeper
```shell
bash /root/bin/zk.sh stop
```
zookeeper状态
```shell
bash /root/bin/zk.sh status
```

### 3.Hive (hadoop-master)
```shell
$HIVE_HOME/bin/hive --service metastore
$HIVE_HOME/bin/hiveserver2
$HIVE_HOME/bin/beeline -u jdbc:hive2://hadoop-master:10000 -n root
```

### 4.flume (hadoop-slave2)
```shell
# 使用openresty生成数据
bash /usr/local/openresty/bin/userlog.sh
# 使用flume采集数据
$FLUME_HOME/bin/flume-ng agent --conf conf/ --name a3 --conf-file job/flume-ulogs-hdfs.conf -Dflume.root.logger=INFO,console
```

（2）在hive上访问HDFS的数据
```shell
#1.查看指定目录下的文件列表
hive> dfs -ls /flume/ulogs/20220508/21;
# 输出结果
/flume/ulogs/20220508/21/ulog-.1652070131638

#2. 查看指定文件内容
dfs -cat /flume/ulogs/20220508/21/ulog-.1652070131638;
#输出结果：
{"user_ip":"58.134.129.229","os":"1","lonitude":"118.22166999999999","latitude":"31.113","user_region":"340222","user_device":"110103197901118888","manufacturer":"04","duration":0,"ct":1639988348000,"carrier":"1","event_type":"02","action":"05","network_type":"0","exts":"{\"target_page\":\"010007\",\"target_source\":\"01\",\"event_target\":\"105\"}"
```



(3) 在Hive上创建数据库  userlogs

```shell
create database if not exists userlogs;
use userlogs;
```

(4)在数据库userlogs中创建用户行为日志表

```shell
--用户行为日志数据
create external table if not exists ulogs(
  action string comment '行为类型',
  event_type string comment '行为类型',
  user_device string comment '设备号',
  os string comment '手机系统',
  manufacturer string comment '手机制造商',
  carrier string comment '电信运营商',
  network_type string comment '网络类型',
  user_region string comment '所在区域',
  user_ip string comment '所在区域IP',
  longitude string comment '经度',
  latitude string comment '纬度',
  exts string comment '扩展信息(json格式)',
  duration int comment '停留时长',
  ct bigint comment '创建时间'
) partitioned by (dt string)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE;
```

查看所有数据表

```shell
hive> show tables;
OK
ulogs
Time taken: 0.545 seconds, Fetched: 1 row(s)
```

查询数据-目前无数据

```shell
hive> select * from ulogs;
OK
Time taken: 0.755 seconds
```

（5）给数据表添加分区：

```shell
--查看表分区
show partitions userlogs.ulogs;

--增加数据分区(随后这里增加统一调度增加分区)
alter table userlogs.ulogs add partition(dt='2021-09-11');
```

（6）将数据加载到表中，上传时指定分区

```shell
#加了local，将centos上的文件加载到hive
load data local inpath '/flume/ulogs/20220508/21/ulog-.1652070131638' overwrite into table ulogs partition(dt='2021-09-11');  

#不加local,将HDFS上的文件加载到hive【我们已经将数据上传到HDFS上，因此这里不加local】
load data  inpath '/flume/ulogs/20220508/21/ulog-.1652070131638' overwrite into table ulogs partition(dt='2021-09-11');  
```

### 5.zeppelin (hadoop-master)
```shell
# Zeppelin服务启动
${ZEPPELIN_HOME}/bin/zeppelin-daemon.sh start
# Zeppelin服务停止
${ZEPPELIN_HOME}/bin/zeppelin-daemon.sh stop
```