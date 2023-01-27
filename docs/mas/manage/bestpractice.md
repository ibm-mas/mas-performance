# MAS Manage

## App Server

MAS Manage has different bundle types e.g. All, UI, MEA, Report and CRON to configure app server. Adjust the resource settings like cpu, memory, replic to match the workload. The settings are in ManageWorkspaces CR. Below is the sample. 

```yaml
apiVersion: apps.mas.ibm.com/v1
kind: ManageWorkspace
...
spec:
 settings:
    deployment:
      serverBundles:
        - bundleType: mea
          isDefault: false
          isMobileTarget: false
          isUserSyncTarget: true
          name: mea
          replica: 1
          routeSubDomain: all
        - bundleType: cron
          isDefault: false
          isMobileTarget: false
          isUserSyncTarget: false
          name: cron
          replica: 1
...
```

## Load-Balancer

Lab test shows **roundrobin** has more stable and better performance than **leastconn** policy which is the default. Follow [this link](../ocp/bestpractice.md#load-balance-algorithm) to update load balancer policy. 

## Manage Pod Functionality

Follow [this link](https://ibm-mas.github.io/cli/guides/mas-pods-explained/#manage-pods) to understand the manage pod functionality. 

## LTPA timeout

Using IBM Maximo Application Suite (MAS), Manage users will receive an error message saying to reload the application after 2 hours, even while actively working. This 2-hour timeout default is when the LTPA token in Manage expires, and is redirecting the user back to the login page for MAS. Follow [Updating LTPA timeout in Manage](https://www.ibm.com/support/pages/node/6841623) to increase the default value. 

## WebSphere Liberty

Due to the architecture change, Maximo 8.x (MAS Manage app) is deployed on WebSphere Liberty Base 21.0.0.5 with OpenJ9. As of WebSphere Liberty 18.0.0.1, the thread growth algorithm is enhanced to grow thread capacity more aggressively to react more rapidly to peak loads. For many environments, this autonomic tuning provided by the Open Liberty thread pool works well with no configuration or tuning by the operator. If necessary, you can adjust `coreThreads` and `maxThreads` value by [tuning liberty](https://www.ibm.com/docs/en/was-liberty/core?topic=tuning-liberty).

### Configure JVM options in Manage app
Follow [this link](https://www.ibm.com/docs/en/maximo-manage/continuous-delivery?topic=application-configuring-jvm-options) to configure JVM options


## DB

### Disk

disk performance is critial for db performance. Recommend a storage or disk with

* disk throughput > 200 MB/s
* storage class: a storage with 100+ IOPS

### DB - DB2/DB2wh

DB2 Tuning in [Maximo 7.6.x Best practice](../../maximo-7/download/Maximo%20Best%20Practices%20for%20System%20Performance%207.6.x%20v1.3.pdf) is applicable. 

**Highlights:**

- increase maxsequence cache to 50
- run runstats and/or reorg to update index periodically
- separate system storage, user storage, backup storage, transaction logs storage, temporary tablespace storage on as different disks if possible. 
- Use [DB2 Performance Diagnosis](../../pd/db2-performance-diagnosis.md) to troubleshoot and tuning the db and SQL.
- Manage requires **row-organized** tables. Check db2w db setting (by default it uses column based) and update the setting by `db2 update db cfg using DFT_TABLE_ORG ROW`
- **Manage** does **NOT** support MMP or table partition in the current version, but consider to archive records over 1-year old. Optim is the one of the tools can be used for archiving. see [this guide](https://www.ibm.com/support/pages/installing-ibm-maximo-archiving-751-ibm-maximo-asset-management-v76) and [this video](https://www.youtube.com/watch?v=qr_0SpWrabc) for details. 
- Increase the concurrently running statements allowed for a DB2 application. This issue occcurs when loading a large amount of data via MIF or api call. See [this link](https://www.ibm.com/support/pages/how-many-concurrently-running-statements-allowed-db2-java-application-and-how-increase-it) for the tuning. 
- **storageclass**
    - for ibm cloud:  performance(Custom) block storage with 100+ IOPS for data storage, block gold for system and block silver for backup
    - for aws cloud: if using EFS for db, consider Provisioned mode to have a constant throughput. For more disk options, see details in this [page](https://docs.aws.amazon.com/efs/latest/ug/performance.html)


### DB - Oracle   

- [Maximo 7.6.x Best practice](../../maximo-7/download/Maximo%20Best%20Practices%20for%20System%20Performance%207.6.x%20v1.3.pdf) is applicable
    
### DB - MSSQL

- [Maximo 7.6.x Best practice](../../maximo-7/download/Maximo%20Best%20Practices%20for%20System%20Performance%207.6.x%20v1.3.pdf) is applicable

- additional settings for MSSQL Server 2019
    - compatibility level: if maximo db is upgraded from the old version and the performance degradtation is observed after the upgrade, consider to set compatibility level to the old version to keep the execution plan same.
    - isolation level: 
```sql
        ALTER DATABASE <DB NAME>  
        SET ALLOW_SNAPSHOT_ISOLATION ON  

        ALTER DATABASE <DB NAME> 
        SET READ_COMMITTED_SNAPSHOT ON  
```

