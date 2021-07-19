#!/bin/bash

source "/vagrant/scripts/common.sh"

function installLocalKafka {
    echo "install Kafka from local file"
	FILE=/vagrant/resources/$KAFKA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteKafka {
	echo "install Kafka from remote file"
	curl ${CURL_OPTS} -o /vagrant/resources/$KAFKA_ARCHIVE -O -L $KAFKA_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$KAFKA_ARCHIVE -C /usr/local
}

function installKafka {
    if resourceExists $KAFKA_ARCHIVE; then
        installLocalKafka
    else
        installRemoteKafka
    fi
    ln -s /usr/local/${KAFKA_RELEASE} $KAFKA_HOME
}


echo "setup Kafka"

installKafka

echo "Kafka setup complete"