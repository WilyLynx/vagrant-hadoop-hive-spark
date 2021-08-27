#!/bin/bash

source "/vagrant/scripts/common.sh"

function stopFlink {
    echo "stop Flink"
    ${FLINK_HOME}/bin/stop-cluster.sh
}

stopFlink
