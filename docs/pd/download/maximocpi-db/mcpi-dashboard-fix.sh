#!/bin/bash
# the script to fix mcpi-dashboard.json deployment issue for v2.1 release
# run command
# curl -L -v -o /tmp/mcpi-dashboard-fix.sh https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/mcpi-dashboard-fix.sh > /dev/null 2>&1
# bash /tmp/mcpi-dashboard-fix.sh

cp /opt/app-root/src/exporter/dashboard/mcpi-dashboard.json /opt/app-root/src/ansible/ibm/mas_autoscaling/roles/deploy_dashboards/files/dashboards/mcpi-dashboard.json
cp /opt/app-root/src/exporter/dashboard/mcpi-dashboard.json /opt/app-root/src/.ansible/collections/ansible_collections/ibm/mas_autoscaling/roles/deploy_dashboards/files/dashboards/mcpi-dashboard.json
