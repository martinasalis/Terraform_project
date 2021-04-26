#!/bin/bash

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# Update and install packages
sudo apt-get -y update > /dev/null
sudo apt-get -y dist-upgrade > /dev/null
sudo apt-get -y install git > /dev/null
sudo apt-get -y install python3 > /dev/null
sudo apt-get -y install python3-pip > /dev/null

pip3 install numpy > /dev/null

sudo apt-get -y install openjdk-8-jdk > /dev/null

echo 'StrictHostKeyChecking no
UserKnownHostsFile /dev/null' | sudo tee --append /etc/ssh/ssh_config > /dev/null

# Download Hadoop
wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz > /dev/null
sudo tar zxvf hadoop-2.7.7.tar.gz > /dev/null
sudo mv ./hadoop-2.7.7 /home/ubuntu/hadoop
rm hadoop-2.7.7.tar.gz

# Set paths
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export HADOOP_HOME=/home/ubuntu/hadoop
export PATH=$PATH:$HADOOP_HOME/bin
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PYSPARK_PYTHON=python3' | sudo tee --append /home/ubuntu/.profile > /dev/null

source /home/ubuntu/.profile

# Define hosts name
echo "Host namenode
HostName namenode
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode1
HostName datanode1
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode2
HostName datanode2
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode3
HostName datanode3
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode4
HostName datanode4
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode5
HostName datanode5
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode6
HostName datanode6
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode7
HostName datanode7
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1

Host datanode8
HostName datanode8
User ubuntu
IdentityFile /home/ubuntu/.ssh/$1" | sudo tee /home/ubuntu/.ssh/config > /dev/null

# Define hosts ip
echo '172.31.67.1 namenode
172.31.67.2 datanode1
172.31.67.3 datanode2
172.31.67.4 datanode3
172.31.67.5 datanode4
172.31.67.6 datanode5
172.31.67.7 datanode6
172.31.67.8 datanode7
172.31.67.9 datanode8' | sudo tee --append /etc/hosts > /dev/null

# Create public key
sudo chmod 700 /home/ubuntu/.ssh
ssh-keygen -f /home/ubuntu/.ssh/id_rsa -t rsa -P ''
sudo touch /home/ubuntu/.ssh/authorized_keys
sudo chmod 600 /home/ubuntu/.ssh/authorized_keys
cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
ssh datanode1 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode2 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode3 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode4 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode5 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode6 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode7 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode8 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub

sudo sed -i -e 's/export\ JAVA_HOME=\${JAVA_HOME}/export\ JAVA_HOME=\/usr\/lib\/jvm\/java-8-openjdk-amd64/g' $HADOOP_CONF_DIR/hadoop-env.sh

# Hadoop configuration
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
<value>hdfs://namenode:9000</value>
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
<value>namenode</value>
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
<value>namenode:54311</value>
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

sudo mkdir -p $HADOOP_HOME/data/hdfs/namenode
sudo mkdir -p $HADOOP_HOME/data/hdfs/datanode

# Define Hadoop hosts
echo 'namenode' | sudo tee $HADOOP_CONF_DIR/masters > /dev/null

echo 'datanode1
datanode2
datanode3
datanode4
datanode5
datanode6
datanode7
datanode8' | sudo tee $HADOOP_CONF_DIR/slaves > /dev/null

sudo chown -R ubuntu $HADOOP_HOME

# Download Spark
wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz > /dev/null
tar xvzf spark-3.0.1-bin-hadoop2.7.tgz > /dev/null
sudo mv ./spark-3.0.1-bin-hadoop2.7 /home/ubuntu/spark
rm spark-3.0.1-bin-hadoop2.7.tgz

# Spark configuration
echo '
export SPARK_HOME=/home/ubuntu/spark
export PATH=$PATH:$SPARK_HOME/bin' | sudo tee --append /home/ubuntu/.profile > /dev/null

source /home/ubuntu/.profile

sudo cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh

echo 'export SPARK_MASTER_HOST=namenode
export HADOOP_HOME=/home/ubuntu/hadoop
export HADOOP_CONF_DIR=/home/ubuntu/hadoop/etc/hadoop
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' | sudo tee --append $SPARK_HOME/conf/spark-env.sh > /dev/null

echo 'datanode1
datanode2
datanode3
datanode4
datanode5
datanode6
datanode7
datanode8' | sudo tee --append $SPARK_HOME/conf/slaves > /dev/null

sudo cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf

# Stark Hadoop and Spark
hdfs namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

$SPARK_HOME/sbin/start-master.sh
