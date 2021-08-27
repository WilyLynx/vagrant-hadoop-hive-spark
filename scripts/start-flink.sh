#!/bin/bash

source "/vagrant/scripts/common.sh"

function startFlink {
    echo "start Flink"
    ${FLINK_HOME}/bin/start-cluster.sh
}

startFlink
