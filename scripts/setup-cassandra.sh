#!/bin/bash

source "/vagrant/scripts/common.sh"

function installLocalCassandra {
    echo "install Cassandra from local file"
	FILE=/vagrant/resources/$CASSANDRA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteCassandra {
	echo "install Cassandra from remote file"
	curl ${CURL_OPTS} -o /vagrant/resources/$CASSANDRA_ARCHIVE -O -L $CASSANDRA_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$CASSANDRA_ARCHIVE -C /usr/local
}

function installCassandra {
    if resourceExists $CASSANDRA_ARCHIVE; then
        installLocalCassandra
    else
        installRemoteCassandra
    fi
    ln -s /usr/local/apache-cassandra-${CASSANDRA_VERSION} $CASSANDRA_HOME
}

function createDirectories {
    echo "create required directories"
    mkdir ${CASSANDRA_HOME}/data
    chmod o+w ${CASSANDRA_HOME}/data
    mkdir ${CASSANDRA_HOME}/data/data
    chmod o+w ${CASSANDRA_HOME}/data/data
    mkdir ${CASSANDRA_HOME}/data/commitlog
    chmod o+w ${CASSANDRA_HOME}/data/commitlog
    mkdir ${CASSANDRA_HOME}/logs
    chmod o+w ${CASSANDRA_HOME}/logs
}

function setupEnvVars {
    echo "creating cassandra environment variables"
	cp -f $CASSANDRA_RES_DIR/cassandra.sh /etc/profile.d/cassandra.sh
	. /etc/profile.d/cassandra.sh
}


echo "setup Cassandra"

installCassandra
createDirectories
setupEnvVars

echo "Cassandra setup complete"