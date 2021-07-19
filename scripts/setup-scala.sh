#!/bin/bash

source "/vagrant/scripts/common.sh"

function installLocalScala {
    echo "install scala from local file"
	FILE=/vagrant/resources/$SCALA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteScala {
    echo "insatll scala from remote file"
    curl ${CURL_OPTS} -o /vagrant/resources/$SCALA_ARCHIVE -O -L $SCALA_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$SCALA_ARCHIVE -C /usr/local
}

function installScala {
    if resourceExists $SCALA_ARCHIVE; then
        installLocalScala
    else
        installRemoteScala
    fi
    ln -s /usr/local/${SCALA_RELEASE} ${SCALA_HOME}
}

function setupEnvVars {
	echo "creating Scala environment variables"
	cp -f $SCALA_RES_DIR/scala.sh /etc/profile.d/scala.sh
	. /etc/profile.d/scala.sh
}

echo "setup scala ${SCALA_VERSION}"

installScala
setupEnvVars

echo "scala setup complete"