#!/bin/bash

source /opt/app-root/src/healthcheck/base.sh

# verify mas namespace 
if [ -z "$1" ]; then 
    echo "Error: Missing the namespace"
    echo "Info: The command is mas-manage-db-metrics.sh <manage namespace name>"
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


# get db metrics into MHCJSON
if [ -z "${MHCJSON}" ]; then
    export MHCJSON="${TMPDIR}/dbmetric-${MAS_INSTANCE_NAME}-$(date +"%Y-%m-%d-%H-%M").json"
fi

# collect data
log_info "collect db metric for instance: ${MAS_INSTANCE_NAME}"
oc cp /opt/app-root/src/conf/maximocpi-db/maximocpi-db-client.sh ${MAS_MANAGE_NS}/${PODNAME}:/tmp/maximocpi-db-client.sh 2>/dev/null
oc exec -n ${MAS_MANAGE_NS} ${PODNAME} -- bash -c "bash /tmp/maximocpi-db-client.sh -cdf" > ${MHCJSON}


# output
bps="Review the contents of \e[32m${MHCJSON}\e[0m in the MAS Harmony Viewer \e[32m${MHC_VIEWER_URL}\e[0m.\n"

if [ "$(uname)" == "Darwin" ]; then
    printf "${bps}\n"
else
    # echo -e "${bps}"
    log_info "${bps}"
fi
