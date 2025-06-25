#!/bin/bash

workload=$(oc project db2u >/dev/null;oc rsh c-db2wh-manage-db2u-0 bash -c "su - db2inst1 -c 'db2pd -db bludb -transactions member|grep commits'" 2>/dev/null | awk -F ': ' '{print $2}'| sed 's/[[:space:]]*$//')
echo "# HELP db2_transaction_committed_total Count of db2 committed transactions"
echo "# TYPE db2_transaction_committed_total counter"
echo "db2_transaction_committed_total{} ${workload}"