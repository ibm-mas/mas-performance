# DBTest Utility

## notes:

- This utility needs **Java version 11 or higher**.

## Test DB latency in Maximo UI Pod

- go to maximo ui pod -> terminal tab, then execute below commands:

```bash
# change to /tmp
cd /tmp

# download DBTest
curl -L -v -o DBTest.class https://ibm-mas.github.io/mas-performance/pd/download/DBTest.class

# set DBURL. If this utility is in maximo UI pod, set DBURL="$MXE_DB_URL"
export DBURL='<jdbc url>' or export DBURL="$MXE_DB_URL"
export DBUSERNAME='<username>'
export DBPASSWORD='<password>'
export SQLQUERY='select * from maximo.maxattribute'
java -classpath .:$(dirname "$(find /opt/ibm | grep oraclethin | head -n 1)")/* DBTestjava
```

