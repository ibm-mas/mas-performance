# DBTest Utility on Maximo 7.6

### Running DBTest on the app server

- In a terminal on the app server, execute the commands below:

```bash
# change to /tmp
cd /tmp

# download DBTest
curl -L -v -o DBTest.class https://ibm-mas.github.io/mas-performance/pd/download/DBTest/DBTest.class

# download required libraries
curl -L -v -o lib.zip https://ibm-mas.github.io/mas-performance/pd/download/maximocpi-db/lib.zip

# unzip the library zip file
unzip lib.zip

# set the following env variables
export DBURL="<maximo jdbc url>"
export DBUSERNAME='<username>'
export DBPASSWORD='<password>'
export SQLQUERY='<the query you want to test>' (e.g. 'select * from maximo.maxattribute')

# execute the utility in benchmark mode
java -classpath .:/tmp/maximocpi-db.jar:/tmp/lib/* DBTest -q
```

**Result Samples:**

Given optimal network latency and a healthy database status, the expected data fetching time is less than 10 milliseconds.

**Output Sample:**

```text
(base) [/tmp]$ java -classpath .:/tmp/maximocpi-db.jar:/tmp/lib/* DBTest -q
Dec. 06, 2023 11:49:47 A.M. DBTest getConnection
INFO: Loading Class took: 0.029 seconds
Dec. 06, 2023 11:49:53 A.M. DBTest getConnection
INFO: DB Connecting took: 6.55 seconds
Dec. 06, 2023 11:49:53 A.M. DBTest printResult
INFO: Query Execution took: 0.099 seconds
APP, OPTIONNAME, DESCRIPTION, ESIGENABLED, VISIBLE, ALSOGRANTS, ALSOREVOKES, PREREQUISITE, SIGOPTIONID, LANGCODE, HASLD, ROWSTAMP
---------------------------------------------------------------------------------------------------------------------------------
APIKEY, READ, Access to API Keys application, 0, 1, null, ALL, null, 200004204, EN, 0, 290874862
Dec. 06, 2023 11:49:54 A.M. DBTest printResult
INFO: Fetching Record took: 0.058 seconds
```