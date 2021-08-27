#!/bin/bash

source "/vagrant/scripts/common.sh"

function installLocalFlink {
    echo "install Flink from local file"
	FILE=/vagrant/resources/$FLINK_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteFlink {
	echo "install Flink from remote file"
	curl ${CURL_OPTS} -o /vagrant/resources/$FLINK_ARCHIVE -O -L $FLINK_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$FLINK_ARCHIVE -C /usr/local
}

function installFlink {
    if resourceExists $FLINK_ARCHIVE; then
        installLocalFlink
    else
        installRemoteFlink
    fi
    ln -s /usr/local/flink-${FLINK_VERSION} $FLINK_HOME
}


echo "setup Flink"

installFlink

echo "Flink setup complete"