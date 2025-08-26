#!/bin/bash

# verify the action parameter
if [ -z "$1" ]; then 
    echo "Error: Missing action parameter: -cdf|-cdm|-tl|-es|-h"
    echo "Info: The command is mas-manage-db-metrics.sh <action parameter>"
    exit
fi

# verify if /tmp/db-export exists
if [ ! -d /tmp/db-export ]; then 
    mkdir /tmp/db-export; cd /tmp/db-export
else
    cd /tmp/db-export
fi

# verify if maximocpi-db.jar exists
if [ ! -f /tmp/db-export/maximocpi-db.jar ]; then 
    curl -L -v -o /tmp/db-export/maximocpi-db.jar https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/maximocpi-db.jar > /dev/null 2>&1
fi

# prepare the execution 
IFS='=' read -r key value <<< $(cat /etc/database/operator/secret/maximo.properties |grep mxe.db.url=)
if [[ "${value}" == *"sslConnection=true"* ]]; then
    export DBURL="${value}sslTrustStoreLocation=${java_truststore};sslTrustStorePassword=${java_truststore_password};"
else
    export DBURL="${value}"
fi

IFS='=' read -r key value <<< $(cat /etc/database/operator/secret/maximo.properties |grep mxe.db.user=)
export DBUSERNAME="${value}"

IFS='=' read -r key value <<< $(cat /etc/database/operator/secret/maximo.properties |grep mxe.db.password=)
export DBPASSWORD="${value}"

IFS='=' read -r key value <<< $(cat /etc/database/operator/secret/maximo.properties |grep mxe.db.schemaowner=)
export DBSCHEMAOWNER="${value}"
if [[ "$1" == "-tl" ]]; then 
    if [ -z "$DBSCHEMAOWNER" ]; then
        export SQLQUERY="select * from maxattribute"
    else
        export SQLQUERY="select * from ${DBSCHEMAOWNER}.maxattribute"
    fi
fi

if [ -z "$2" ]; then 
    export SQLQUERY="$2"
fi

java -classpath /tmp/db-export/maximocpi-db.jar:/opt/IBM/SMP/maximo/applications/maximo/lib/* "${JAVA_TOOL_OPTIONS}" com.ibm.maximo.mcpi.DBHarmony $1

