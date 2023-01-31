# Performance Diagnosis

!!!info
    A monitoring system is strongly recommended to track the environment health and the quality of services.

### Diagnostic Utility

| Scope                   | Name                      | Used for                                           |
| ------------------------|-------------------------- | ----------------------------------------------------- |
|OCP | [OpenShift Monitoring Service](../mas/monitoring/guidance.md)  | OpenShift Cluster and MAS  |
|DB2 | [IBM DSM](../../misc/db2-performance-insight/#ibm-data-server-manager-ibm-dsm) | DB2 Historical and Realtime Troubleshooting|
|DB2 | [db2top](../../misc/db2-performance-insight/#db2top) | DB2 Realtime Troubleshooting|
|Oracle | AWR, StatsPack| Historical Troubleshooting |
|JVM | IBM Support Assistant| Heap Dump and GC Log Analysis |
|JVM | [MAT](http://wiki.eclipse.org/MemoryAnalyzer)| JVM Dump Analysis |
|Maximo | [PerfMon](https://www.ibm.com/developerworks/community/blogs/a9ba1efe-b731-4317-9724-a181d6155e3a/entry/performance_maximo_activity_dashboard_perfmon?lang=en) | - Maximo UI Activity Tracing<br/> - **Note**: Enabling PerfMon may significantly degrade server performance. <br/> - Recommend for a single user with Dev/Test env only|
|MongoDB | mongotop | MongoDB Realtime Troubleshooting | 
|HAR | [HTTP Archive Viewer](https://chrome.google.com/webstore/detail/http-archive-viewer/ebbdbdmhegaoooipfnjikefdpeoaidml?hl=en) | HAR Analysis - for web page and client side (browser) performance |
|SQL | [Poor SQL](http://poorsql.com) | Online SQL Formatter | 
|SQL | [Squirrl](http://squirrel-sql.sourceforge.net) | Universal SQL Client |
|SSL | [SSL Shopper](https://www.sslshopper.com)| Online certificate decode tool |
|OS  | [top](https://www.redhat.com/sysadmin/interpret-top-output) | Process and thread level analysis, hotspot analysis - top is available in most containers and on OCP worker nodes|
|OCP | oc debug node/<node name> | Worker node debugging |

## Factors in system performance

System performance depends on more than the applications and the database. The network architecture affects performance. Application server configuration can hurt or improve performance. The way that you deploy Maximo across servers affects the way the products perform. Many other factors come into play in providing the end-user experience of system performance.
Subsequent sections in this paper address the following topics:

* System architecture setup including OCP, Instance Type, Storage
* App and DB server configuration
* Network issues
* Bandwidth
* Load balancing
* Database tuning
* SQL tuning
* Scheduled tasks (cron tasks)
* Reporting
* Integration with other systems using the integration framework
* Troubleshooting


## Performance Check List

- check node status. e.g. any NOT Ready worker nodes
- if there is any pod or node cpu, memeory usage approaching to the limit?
- if there is any pod restarted many time recently?
- if there is any JVM Heapdump dump?
- if there is any JVM Hung Thread 
- if there is any node or pod with a high system or IO wait (20%)?
- if there is any node memory, disk or pid pressure?
- if the response time is high (over 2 sec)?
- if any long running (over 2 sec) or high cpu cost query?
- if there is network bottleneck (e.g. load-balancer)
- is app server or db server busy?
    - if app server is busy
        - check the request, limit value for cpu, memory
        - should replic memebers be increased?
    - if db server is busy
        - check cpu, memory, disk current usage and limit value
        - check any utility in the background. e.g. backup
        - check db lock
        - check if there is any high cost query
        - check disk performance




