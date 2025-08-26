#!/bin/bash

source /opt/app-root/src/healthcheck/base.sh

# verify mas namespace 
if [ -z "$1" ]; then 
    echo "Error: Missing the namespace"
    echo "Info: The command is mas-manage-db-tl.sh <manage namespace name>"
    exit
fi

# get mas instance name
get_mas_instance_name() {
  echo "$1" | sed -E 's/^mas-(.+)-(core|manage)$/\1/'
}

# retreive mas instance name
MAS_MANAGE_NS=$1
MAS_INSTANCE_NAME=$(get_mas_instance_name $1)

# get maxinst pod
PODNAME=$(oc get pods -n ${MAS_MANAGE_NS}|grep Running|grep maxinst|awk '{print $1}')
#echo ${PODNAME}

# collect data
log_info "maxiomcpi-db: latency test mode, Instance: ${MAS_INSTANCE_NAME}"
oc cp /opt/app-root/src/conf/maximocpi-db/maximocpi-db-client.sh ${MAS_MANAGE_NS}/${PODNAME}:/tmp/maximocpi-db-client.sh 2>/dev/null
if [ -z "$2" ]; then 
  oc exec -n ${MAS_MANAGE_NS} ${PODNAME} -- bash -c "bash /tmp/maximocpi-db-client.sh -tl"
else
  log_info "maxiomcpi-db: latency test mode, SQLQUERY: $2"
  oc exec -n ${MAS_MANAGE_NS} ${PODNAME} -- bash -c "bash /tmp/maximocpi-db-client.sh -tl \"$2\""
fi

