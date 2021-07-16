#!/bin/bash

source "/vagrant/scripts/common.sh"

function installLocalNifi {
    echo "install NiFi from local file"
	FILE=/vagrant/resources/$NIFI_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteNifi {
	echo "install NiFi from remote file"
	curl ${CURL_OPTS} -o /vagrant/resources/$NIFI_ARCHIVE -O -L $NIFI_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$NIFI_ARCHIVE -C /usr/local
}

function installNifi {
    if resourceExists $NIFI_ARCHIVE; then
        installLocalNifi
    else
        installRemoteNifi
    fi
    ln -s /usr/local/nifi-$NIFI_VERSION $NIFI_HOME
}

function setupNifi {
    echo "creating deafult user"
    # cp -f $NIFI_RES_DIR/nifi.properties $NIFI_CONF
    # sudo ${NIFI_TOOLKIT_HOME}/bin/tls-toolkit.sh standalone -n 0.0.0.0 -o ${NIFI_CONF} -O
    # ${NIFI_HOME}/bin/nifi.sh set-single-user-credentials mini mini-big-data-nifi
    # cp ${NIFI_CONF}/0.0.0.0/nifi.properties ${NIFI_CONF}
    # cp ${NIFI_CONF}/0.0.0.0/keystore.jks ${NIFI_CONF}
    # cp ${NIFI_CONF}/0.0.0.0/truststore.jks ${NIFI_CONF}
    sed -i 's/nifi.remote.input.secure=true/nifi.remote.input.secure=false/' $NIFI_CONF/nifi.properties
    sed -i 's/nifi.web.http.port=/nifi.web.http.port=9443/' $NIFI_CONF/nifi.properties
    sed -i 's/nifi.web.https.host=127.0.0.1/nifi.web.https.host=/' $NIFI_CONF/nifi.properties
    sed -i 's/nifi.web.https.port=8443/nifi.web.https.port=/' $NIFI_CONF/nifi.properties
}

function setupEnvVars {
	echo "creating NiFi environment variables"
	cp -f $NIFI_RES_DIR/nifi.sh /etc/profile.d/nifi.sh
	. /etc/profile.d/nifi.sh
}

function installLocalNifiToolkit {
    echo "install NiFi Toolkit from local file"
	FILE=/vagrant/resources/$NIFI_TOOLKIT_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteNifiToolkit {
	echo "install NiFi Toolkit from remote file"
	curl ${CURL_OPTS} -o /vagrant/resources/$NIFI_TOOLKIT_ARCHIVE -O -L $NIFI_TOOLKIT_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$NIFI_TOOLKIT_ARCHIVE -C /usr/local
}

function installNifiToolkit {
    if resourceExists $NIFI_TOOLKIT_ARCHIVE; then
        installLocalNifiToolkit
    else
        installRemoteNifiToolkit
    fi
    ln -s /usr/local/nifi-toolkit-$NIFI_VERSION $NIFI_TOOLKIT_HOME
}

function startNifi {
    echo "starting Nifi with default config"
    ${NIFI_HOME}/bin/nifi.sh start --wait-for-init 180
}

function stopNifi {
    echo "stop Nifi"
    ${NIFI_HOME}/bin/nifi.sh stop
}

echo "setup NiFi"

installNifi
installNifiToolkit
startNifi
stopNifi
setupNifi
setupEnvVars

echo "NiFi setup complete"