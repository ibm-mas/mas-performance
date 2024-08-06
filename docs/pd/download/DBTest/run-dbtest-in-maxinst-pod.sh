#!/bin/bash
# curl -L -v -o run-dbtest-in-maxinst-pod.sh https://ibm-mas.github.io/mas-performance/pd/download/DBTest/run-dbtest-in-maxinst-pod.sh

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

IFS='=' read -r key value <<< $(cat /etc/database/operator/secret/maximo.properties |grep mxe.db.schemaowner=)
export DBSCHEMAOWNER="${value}"
if [ -z "$DBSCHEMAOWNER" ]; then
    export SQLQUERY="select * from maxattribute"
else
    export SQLQUERY="select * from ${DBSCHEMAOWNER}.maxattribute"
fi

java -classpath .:/opt/IBM/SMP/maximo/tools/maximo/lib/* "${JAVA_TOOL_OPTIONS}" DBTest