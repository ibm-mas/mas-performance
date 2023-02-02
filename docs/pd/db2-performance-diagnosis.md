### DB2TOP

db2top can be used for a real-time diagnosis.

* Command: `db2top -db <dbname>`
    * press **h**: help screen 
    * press **I**: reset the interval time (default is 2 seconds) 
    * press **m**: memory screen 
    * press **B**: bottleneck screen 
    * press **b**: bufferpool screen 
    * press **T**: Table screen 
    * press **U**: locks screen
    * press **u**: utility screen to check if runstat is running
    * press **D**: Dynamic SQL screen 
    * Catch High CPU SQL in Dynamic SQL screen, do:
        - Press **z** and **5** to sort by cpu usage
        - Copy SQL Hashcode 
        - Press **L** and Paste SQL Hashcode
* Notes: Be cautions when taking any snapshot. 
* See more details on [User Manual](http://www-01.ibm.com/support/docview.wss?uid=swg27009542&aid=1) 

### Diagnosis Commands

- **list memory allocation:**
   
    ```
    db2mtrk -i -d –v
    ```

- **list long run query:**

    ```
    SELECT ELAPSED_TIME_MIN,SUBSTR(AUTHID,1,10) AS AUTH_ID, AGENT_ID,APPL_STATUS,SUBSTR(STMT_TEXT,1,20) AS SQL_TEXT FROM SYSIBMADM.LONG_RUNNING_SQL WHERE ELAPSED_TIME_MIN > 0 ORDER BY ELAPSED_TIME_MIN DESC;
    ```

- **list backup/restore status:**
    
    ```
    db2pd -barstats -d <dbname>
    ```

- **list most active tables:**
    
    ```
    SELECT SUBSTR(TABSCHEMA,1,10) AS SCHEMA,SUBSTR(TABNAME,1,20) AS NAME,TABLE_SCANS,ROWS_READ,ROWS_INSERTED,ROWS_DELETED FROM TABLE(MON_GET_TABLE('','',-1)) ORDER BY ROWS_READ DESC FETCH FIRST 5 ROWS ONLY
    ```

- **list most active indexes:**
    
    ```
    SELECT SUBSTR(TABSCHEMA,1,10) AS SCHEMA,SUBSTR(TABNAME,1,20) AS NAME,IID,NLEAF, NLEVELS,INDEX_SCANS,KEY_UPDATES,BOUNDARY_LEAF_NODE_SPLITS + NONBOUNDARY_LEAF_NODE_SPLITS AS PAGE_SPLITS FROM TABLE(MON_GET_INDEX('','',-1)) ORDER BY INDEX_SCANS DESC FETCH FIRST 5 ROWS ONLY
    ```

- **list db2 advise for the statement:**
    
    ```
    db2advis -database bludb  -s "select * from maximo.ahfactorhistory where ahdriverhistoryid = 123 for read only"  -n MAXIMO -q MAXIMO
    ```

- **list the query execution plan:**
    
    ```
    db2expln -database bludb -schema MAXIMO -package % -statement "select * from maximo.ahfactorhistory where ahdriverhistoryid = 123 for read only" -terminal -graph   > query1_access_plan.txt
    ```

- **list all indexes for a specific table:**
    
    ```
    select * from syscat.indexes i where TABNAME ='ITEMSTRUCT'
    ```

- **list insert/update/delete/tablescan stats for a specific table:**

    ```
    SELECT rows_read,rows_inserted,rows_updated,rows_deleted,table_scans FROM TABLE(MON_GET_TABLE('MAXIMO','ASSET',-2))
    ```

- **list insert/update/delete/tablescan stats for all tables:**
    
    ```
    SELECT SUBSTR(TABSCHEMA,1,10) AS SCHEMA,SUBSTR(TABNAME,1,20) AS NAME,TABLE_SCANS,ROWS_READ,ROWS_INSERTED,ROWS_DELETED FROM TABLE(MON_GET_TABLE('','',-1)) ORDER BY ROWS_READ DESC FETCH FIRST 5 ROWS ONLY"
    ```

- **list error message:**

    ```
    db2 ? <sqlerror>
    ```

 - **`db2pd`:** monitor and troubleshoot DB2 database command
 - **`db2diag`:** db2diag logs analysis tool command
 - **`db2set`:** db2 global settings
 - **`db2 get dbm cfg`:** db2 database manager configuration 
 - **`db2 get db cfg`:** db2 database configuration 

### IBM Data Server Manager (IBM DSM)

IBM DSM is useful to do both real-time/ historical data diagnosis, find out the expensive sql query, justify cpu spent on sql execution or other e.g. sorting, parsing, fetching, io and so on. It requires pre-configuration. 

A high-level set up:

* Download the latest version of Data Server Manager from [IBM developerWorks](https://www.ibm.com/services/forms/preLogin.do?source=swg-rddsm) or [IBM Passport Advantage Online](https://www.ibm.com/software/passportadvantage/pao_customer.html), then extract to /opt/ibm/dsm
* run setup.sh to set up and create admin user
* run start.sh to start the server, url is http://hostname:11080/console
* log on the console, select a time period (e.g. peak time) and then generate report. 


