#!/bin/bash

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo apt-get -y update > /dev/null
sudo apt-get -y dist-upgrade > /dev/null

sudo apt-get -y install git > /dev/null
sudo apt-get -y install python3 > /dev/null
sudo apt-get -y install python3-pip > /dev/null

pip3 install numpy > /dev/null

sudo apt-get -y install openjdk-8-jdk > /dev/null

wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz > /dev/null
sudo tar zxvf hadoop-2.7.7.tar.gz > /dev/null
sudo mv ./hadoop-2.7.7 /home/ubuntu/hadoop
rm hadoop-2.7.7.tar.gz

echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export HADOOP_HOME=/home/ubuntu/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PYSPARK_PYTHON=python3' | sudo tee --append /home/ubuntu/.profile > /dev/null

source /home/ubuntu/.profile

echo '172.31.67.1 namenode
172.31.67.2 datanode1
172.31.67.3 datanode2' | sudo tee --append /etc/hosts > /dev/null

sudo sed -i -e 's/export\ JAVA_HOME=\${JAVA_HOME}/export\ JAVA_HOME=\/usr\/lib\/jvm\/java-8-openjdk-amd64/g' $HADOOP_CONF_DIR/hadoop-env.sh

echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->
<configuration>
<property>
<name>fs.defaultFS</name>
<value>hdfs://172.31.67.1:9000</value>
</property>
</configuration>' | sudo tee $HADOOP_CONF_DIR/core-site.xml > /dev/null

echo '<?xml version="1.0"?>
<!--
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->
<configuration>
<property>
<name>yarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>
<property>
<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
<value>org.apache.hadoop.mapred.ShuffleHandler</value>
</property>
<property>
<name>yarn.resourcemanager.hostname</name>
<value>172.31.67.1</value>
</property>
</configuration>' | sudo tee $HADOOP_CONF_DIR/yarn-site.xml > /dev/null

sudo cp $HADOOP_CONF_DIR/mapred-site.xml.template $HADOOP_CONF_DIR/mapred-site.xml

echo '<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->
<configuration>
<property>
<name>mapreduce.jobtracker.address</name>
<value>172.31.67.1:54311</value>
</property>
<property>
<name>mapreduce.framework.name</name>
<value>yarn</value>
</property>
</configuration>' | sudo tee $HADOOP_CONF_DIR/mapred-site.xml > /dev/null

echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->
<configuration>
<property>
<name>dfs.replication</name>
<value>2</value>
</property>
<property>
<name>dfs.namenode.name.dir</name>
<value>file:///home/ubuntu/hadoop/data/hdfs/namenode</value>
</property>
<property>
<name>dfs.datanode.data.dir</name>
<value>file:///home/ubuntu/hadoop/data/hdfs/datanode</value>
</property>
</configuration>' | sudo tee $HADOOP_CONF_DIR/hdfs-site.xml > /dev/null

sudo mkdir -p $HADOOP_HOME/data/hdfs/datanode

sudo chown -R ubuntu $HADOOP_HOME

wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz > /dev/null
tar xvzf spark-3.0.1-bin-hadoop2.7.tgz > /dev/null
sudo mv ./spark-3.0.1-bin-hadoop2.7 /home/ubuntu/spark
rm spark-3.0.1-bin-hadoop2.7.tgz

sudo cp /home/ubuntu/spark/conf/spark-env.sh.template /home/ubuntu/spark/conf/spark-env.sh

echo 'export SPARK_MASTER_HOST="ip-172-31-67-1.ec2.internal"
export HADOOP_CONF_DIR="/home/ubuntu/hadoop/etc/hadoop"' | sudo tee --append /home/ubuntu/spark/conf/spark-env.sh > /dev/null

/home/ubuntu/spark/sbin/start-slave.sh spark://ip-172-31-67-1.ec2.internal:7077
