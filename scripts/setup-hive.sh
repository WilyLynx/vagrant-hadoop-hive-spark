#!/bin/bash

# http://www.cloudera.com/content/cloudera/en/documentation/cdh4/v4-2-0/CDH4-Installation-Guide/cdh4ig_topic_18_4.html

source "/vagrant/scripts/common.sh"

function installLocalHive {
	echo "install hive from local file"
	FILE=/vagrant/resources/$HIVE_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteHive {
	echo "install hive from remote file"
	curl ${CURL_OPTS} -o /vagrant/resources/$HIVE_ARCHIVE -O -L $HIVE_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$HIVE_ARCHIVE -C /usr/local
}

function installHive {
	if resourceExists $HIVE_ARCHIVE; then
		installLocalHive
	else
		installRemoteHive
	fi
	ln -s /usr/local/apache-hive-$HIVE_VERSION-bin /usr/local/hive
	mkdir /usr/local/hive/logs /usr/local/hive/derby/
}

function setupHive {
	echo "copying over hive configuration file"
	cp -f $HIVE_RES_DIR/* $HIVE_CONF
}

function setupEnvVars {
	echo "creating hive environment variables"
	cp -f $HIVE_RES_DIR/hive.sh /etc/profile.d/hive.sh
	. /etc/profile.d/hive.sh
}

function runHiveServices {
	echo "running hive metastore"
    nohup hive --service metastore < /dev/null > /usr/local/hive/logs/hive_metastore_`date +"%Y%m%d%H%M%S"`.log 2>&1 &

	echo "running hive server2"
    nohup hive --service hiveserver2 < /dev/null > /usr/local/hive/logs/hive_server2_`date +"%Y%m%d%H%M%S"`.log 2>&1 &
}

function createExampleTables {
	echo "Create data folder"
	mkdir /home/vagrant/data || true
	hdfs dfs -mkdir /data

	echo "Coping employees.csv"
	gzip -dk /vagrant/data/employees.csv.gz
	mv /vagrant/data/employees.csv /home/vagrant/data
	hdfs dfs -put /home/vagrant/data/employees.csv /data

	echo "Coping salaries.csv"
	gzip -dk /vagrant/data/salaries.csv.gz
	mv /vagrant/data/salaries.csv /home/vagrant/data
	hdfs dfs -put /home/vagrant/data/salaries.csv /data

	echo "Create Hive tables"
	/usr/local/hive/bin/hive -f /vagrant/resources/hive/create_salaries.sql
	/usr/local/hive/bin/hive -f /vagrant/resources/hive/create_employees.sql
}

echo "setup hive"

installHive
setupHive
setupEnvVars
runHiveServices
createExampleTables

echo "hive setup complete"
