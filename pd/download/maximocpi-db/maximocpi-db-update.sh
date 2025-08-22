#!/bin/bash
# the script to update maximocpi-db util script for v2.1 release
# run command
# curl -L -v -o /tmp/maximocpi-db-update.sh https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/maximocpi-db-update.sh > /dev/null 2>&1
# bash /tmp/maximocpi-db-update.sh

mkdir /opt/app-root/src/conf/maximocpi-db
curl -L -v -o /opt/app-root/src/conf/maximocpi-db/maximocpi-db-client.sh https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/maximocpi-db-client.sh > /dev/null 2>&1
chmod 755 /opt/app-root/src/conf/maximocpi-db/maximocpi-db-client.sh 
curl -L -v -o /opt/app-root/src/healthcheck/get-manage-db-metrics.sh https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/get-manage-db-metrics.sh > /dev/null 2>&1
chmod 755 /opt/app-root/src/healthcheck/get-manage-db-metrics.sh
curl -L -v -o /opt/app-root/src/healthcheck/get-manage-db-tl.sh https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/get-manage-db-tl.sh > /dev/null 2>&1
chmod 755 /opt/app-root/src/healthcheck/get-manage-db-tl.sh