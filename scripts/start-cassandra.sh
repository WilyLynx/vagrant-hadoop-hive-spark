#!/bin/bash

source "/vagrant/scripts/common.sh"

function startCassandra {
    echo "start Cassandra"
    ${CASSANDRA_HOME}/bin/cassandra
}

startCassandra
