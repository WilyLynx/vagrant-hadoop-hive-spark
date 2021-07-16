#!/bin/bash

source "/vagrant/scripts/common.sh"

${NIFI_HOME}/bin/nifi.sh start --wait-for-init 180