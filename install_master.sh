#!/bin/bash

# sostituisci i nomi della variabile
PRIVATE_KEY=$1

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo apt-get -y update && sudo apt-get -y dist-upgrade

sudo apt-get -y install git
sudo apt-get -y install python3
sudo apt-get -y install python3-pip

sudo apt-get -y install openjdk-8-jdk

wget https://www-us.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz
sudo tar zxvf hadoop-2.7.7.tar.gz
sudo mv ./hadoop-2.7.7 /home/ubuntu/hadoop
rm hadoop-2.7.7.tar.gz

echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export HADOOP_HOME=/home/ubuntu/hadoop
export PATH=$PATH:/home/ubuntu/hadoop/bin
export HADOOP_CONF_DIR=/home/ubuntu/hadoop/etc/hadoop' | sudo tee --append /home/ubuntu/.profile

source /home/ubuntu/.profile

echo 'Host namenode
HostName namenode
User ubuntu
IdentityFile /home/ubuntu/.ssh/$PRIVATE_KEY

Host datanode1
HostName namenode
User ubuntu
IdentityFile /home/ubuntu/.ssh/$PRIVATE_KEY

Host datanode2
HostName datanode2
User ubuntu
IdentityFile /home/ubuntu/.ssh/$PRIVATE_KEY' | sudo tee /home/ubuntu/.ssh/config

echo '172.31.67.1 namenode
172.31.67.2 datanode1
172.31.67.3 datanode2' | sudo tee --append /etc/hosts

ssh-keygen -f /home/ubuntu/.ssh/id_rsa -t rsa -P ''
cat /home/ubuntu/.ssh/id_rsa.pub »/home/ubuntu/.ssh/authorized_keys
ssh datanode1 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub
ssh datanode2 'cat >> /home/ubuntu/.ssh/authorized_keys' < /home/ubuntu/.ssh/id_rsa.pub

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
</configuration>' | sudo tee $HADOOP_CONF_DIR/core-site.xml

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
</configuration>' | sudo tee $HADOOP_CONF_DIR/yarn-site.xml

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
</configuration>' | sudo tee $HADOOP_CONF_DIR/mapred-site.xml

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
<value>file:///opt/hadoop-2.7.7/hadoop_data/hdfs/namenode</value>
</property>
<property>
<name>dfs.datanode.data.dir</name>
<value>file:///opt/hadoop-2.7.7/hadoop_data/hdfs/datanode</value>
</property>
</configuration>' | sudo tee $HADOOP_CONF_DIR/hdfs-site.xml

sudo mkdir -p $HADOOP_HOME/data/hdfs/namenode
sudo mkdir -p $HADOOP_HOME/data/hdfs/datanode

echo 'namenode' | sudo tee $HADOOP_CONF_DIR/masters

echo 'datanode1
datanode2' | sudo tee $HADOOP_CONF_DIR/slaves

sudo chown -R ubuntu $HADOOP_HOME

wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz
tar xvzf spark-3.0.1-bin-hadoop2.7.tgz
sudo mv ./spark-3.0.1-bin-hadoop2.7 /home/ubuntu/spark
rm spark-3.0.1-bin-hadoop2.7.tgz

sudo cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh

echo 'export SPARK_MASTER_HOST="ip-172-31-67-1.ec2.internal"
export HADOOP_CONF_DIR="/home/ubuntu/hadoop/conf"' | sudo tee --append spark/conf/spark-env.sh

hdfs namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

./spark/sbin/start-master.sh

ssh datanode1 'bash -s' < install_slaves.sh $PRIVATE_KEY $IPMASTER $IPSLAVE1 $IPSLAVE2 $DNSMASTER
ssh datanode2 'bash -s' < install_slaves.sh $PRIVATE_KEY $IPMASTER $IPSLAVE1 $IPSLAVE2 $DNSMASTER
