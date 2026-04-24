#!/bin/bash

# set TMPDIR if not set
if [ -z "${TMPDIR}" ]; then
   export TMPDIR=/tmp
fi

if [ ! -d "${TMPDIR}/nodelog" ]; then
   mkdir -p "${TMPDIR}/nodelog"
else
   rm -rf "${TMPDIR}/nodelog"/*
fi

# get all nodes
NODES=$(oc get nodes -o jsonpath='{.items[*].metadata.name}')
 
# loop
for NODE in $NODES; do
    echo "collect node description for ${NODE}"
    oc describe node "$NODE" > "${TMPDIR}/nodelog/${NODE}_describe.log" 2>&1
done

# show list
echo -e " The node descriptions are stored in ${TMPDIR}/nodelog.\n If you need to create a zip file, use zip like this:\n zip /tmp/nodelog.zip ${TMPDIR}/nodelog/*"