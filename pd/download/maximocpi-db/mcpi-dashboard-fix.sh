#!/bin/bash
# the script to fix mcpi-dashboard.json deployment issue for v2.1 release
# run command
# curl -L -v -o /tmp/mcpi-dashboard-fix.sh https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/mcpi-dashboard-fix.sh > /dev/null 2>&1
# bash /tmp/mcpi-dashboard-fix.sh

# fix the dashboard wrong directory issue
cp /opt/app-root/src/exporter/dashboard/mcpi-dashboard.json /opt/app-root/src/ansible/ibm/mas_autoscaling/roles/deploy_dashboards/files/dashboards/mcpi-dashboard.json
cp /opt/app-root/src/exporter/dashboard/mcpi-dashboard.json /opt/app-root/src/.ansible/collections/ansible_collections/ibm/mas_autoscaling/roles/deploy_dashboards/files/dashboards/mcpi-dashboard.json

# update the sample file with more flexible patterns
cp /opt/app-root/src/exporter/mas-http-lrq-exporter/rsyslog-http-lrq.sample /opt/app-root/src/exporter/mas-http-lrq-exporter/rsyslog-http-lrq.sample.orig
curl -L -v -o /opt/app-root/src/exporter/mas-http-lrq-exporter/rsyslog-http-lrq.sample https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/rsyslog-http-lrq.sample > /dev/null 2>&1
