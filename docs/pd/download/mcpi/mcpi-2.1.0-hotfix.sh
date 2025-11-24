#!/bin/bash
# maximo-cpi v2.1 hotfix
# run command
# curl -L -v -o /tmp/mcpi-2.1.0-hotfix.sh https://ibm-mas.github.io/mas-performance/pd/download/mcpi/mcpi-2.1.0-hotfix.sh > /dev/null 2>&1
# bash /tmp/mcpi-2.1.0-hotfix.sh

# add collect-node-description.sh
curl -L -v -o /opt/app-root/src/healthcheck/collect-node-description.sh https://ibm-mas.github.io/mas-performance/pd/download/mcpi/collect-node-description.sh > /dev/null 2>&1

# fix mcpi dashboard bug
curl -L -v -o /tmp/mcpi-dashboard-fix.sh https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/mcpi-dashboard-fix.sh > /dev/null 2>&1
bash /tmp/mcpi-dashboard-fix.sh
