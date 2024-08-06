#!/bin/bash

cd /tmp

curl -L -v -o DBTest.class https://ibm-mas.github.io/mas-performance/pd/download/DBTest/DBTest.class


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

export SQLQUERY="select * from maximo.maxattribute"
java -classpath .:/opt/IBM/SMP/maximo/tools/maximo/lib/* "${JAVA_TOOL_OPTIONS}" DBTest