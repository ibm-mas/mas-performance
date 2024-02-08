# MAS Core
The MAS core namespace contains several important services required for user login and authentication, application management, MAS adoption metrics, licensing, etc. To understand the insight of each service/pod functionality in MAS core, check [MAS Pods Explained](https://ibm-mas.github.io/cli/guides/mas-pods-explained/) .

## Scaling MAS core for large number of concurrent users
The following are the key components/dependencies that require scaling as the number of concurrent MAS users grows.

- MongoDB (used extensively by coreidp, api-licensing, adoptionusage, and other MAS/SLS microservices)
- MAS core namespace:
    - coreidp pods
    - licencing-mediator pods
    - coreapi pods (if users directly login to a MAS application, bypassing the Suite navigator page, this decreases the load on coreapi pods)
- SLS namespace:
    - api-licensing pods
- k8s apiserver pods (coreapi pods issue k8s api calls to retrieve information from MAS application CRs, configmaps, etc.)

!!!Caveat
    The scaling guidance described below is provided from lab benchmark testing and may vary based on the differences in workload, environment, or configuration settings.

### MongoDB
MongoDB is a crucial dependency for MAS core services, if not scaled properly MongoDB can quickly become bottleneck as the number of concurrent users increases. A common symptom of an undersized MongoDB cluster is liveness probe timeouts and pod restarts of the MAS core services which depend on MongoDB (e.g. coreidp).

For useful MongoDB troubleshooting commands see [MongoDB Troubleshooting](../mongodb/bestpractice.md)

#### Key MongoDB metrics to monitor
The following MongoDB metrics are important to monitor

- Memory utilization: by default MongoDB will attempt to cache the active data set in memory (in the WiredTiger cache). If there are a large number of cache evictions or the mongod servers are oomkilled these can be indicators that the memory allocation is too small.  Consider increasing the memory allocated to mongod server.
- CPU utilization: check that the mongod servers have not reached their allocated cpu limit
- Average read/write latency: average read and write latency should be under 50 milliseconds. If not it could be due to an undersized MongoDB cluster. Check that the MongoDB cluster has sufficient memory allocation and check disk performance.
- Lock waiters: a large number of lock waiters indicates contention on collections/documents in MongoDB

!!!tip
    When using the ibm.mas_devops collection to install MAS you can optionally install Grafana with the [cluster_monitoring ansible role](https://github.com/ibm-mas/ansible-devops/blob/master/ibm/mas_devops/roles/cluster_monitoring/README.md). Once Grafana is installed via the cluster_monitoring ansible role you can then install MongoDB using the [mongodb ansible role](https://github.com/ibm-mas/ansible-devops/blob/master/ibm/mas_devops/roles/mongodb/README.md). The mongodb ansible role includes a Grafana dashboard for monitoring the MongoDB cluster.

    If your using a MongoDB cluster hosted by a cloud provider uses the monitoring dashboards provided by the cloud provider. 

#### Important MongoDB databases and collections
The following databases and collections in MongoDB are accessed frequently during user login and authentication.

- Database: mas_{{mas-instance-id}}_core
    - Collection: User (user lookup during authentication)
    - Collection: OauthToken (token creation/deletion)
- Database: {{sls-id}}_sls_licensing
    - Collection: licenses (checkin/checkout licenses)
- Database: mas_{{mas-instance-id}}_adoptionusage
    - Collection: users (daily adoption usage statistics)
    - Collection: users_hourly (hourly adoption usage statistics)

#### Scaling MongoDB community
The table below provides some general guidance on scaling MongoDB based on number of concurrent users and login rate. To scale MongoDB community edition you should specify the desired cpu/mem limits in the MongoDBCommunity CR.

```
spec:
  statefulset:
    spec:
      template:
        spec:
          containers:
          - name: mongod
            resources:
              limits:
                cpu: <cpu limit>
                memory: <mem limit>
```

|Login rate (logins/minute)| MongoDB CPU limit | MongoDB Memory limit |
|--------------------------|-------------------|----------------------|
|75                        |2                  |4                     |
|150                       |2                  |4                     |
|300                       |4                  |8                     |
|600                       |6                  |12                    |
|1200                      |8                  |16                    |


### Scaling coreidp service (MAS core namespace)
The table below provides some general guidance on scaling the coreidp service based on number of concurrent users and login rate. To scale the coreidp service use the [podTemplates workload customization](https://www.ibm.com/docs/en/mas-cd/continuous-delivery?topic=workloads-supported-pods) feature in MAS.

|Login rate (logins/minute)| coreidp replicas |coreidp CPU limit | coreidp Memory limit |
|--------------------------|------------------|------------------|----------------------|
|75                        |1                 |6                 |1                     |
|150                       |1                 |6                 |1                     |
|300                       |1                 |6                 |1                     |
|600                       |2                 |6                 |2                     |
|1200                      |4                 |6                 |3                     |

### Scaling licensing-mediator service (MAS core namespace)
The table below provides some general guidance on scaling the licensing-mediator service based on number of concurrent users and login rate. The coreidp service calls the licensing-mediator service which in turn calls the api-licensing service in the SLS namespace for license checkin/checkout operations. To scale the licensing-mediator service use the [podTemplates workload customization](https://www.ibm.com/docs/en/mas-cd/continuous-delivery?topic=workloads-supported-pods) feature in MAS.

|Login rate (logins/minute)| licensing-mediator replicas |licensing-mediator CPU limit |licensing-mediator Memory limit |
|--------------------------|-----------------------------|-----------------------------|--------------------------------|
|75                        |1                            |1                            |1                               |
|150                       |1                            |1                            |1                               |
|300                       |2                            |2                            |1                               |
|600                       |4                            |3                            |1                               |
|1200                      |6                            |3                            |1                               |

### Scaling api-licensing service (SLS namespace)
The table below provides some general guidance on scaling the api-licensing service based on number of concurrent users and login rate. To scale the api-licensing service use the [podTemplates workload customization](https://www.ibm.com/docs/en/mas-cd/continuous-delivery?topic=workloads-supported-pods) feature in MAS.

|Login rate (logins/minute)| api-licensing replicas |api-licensing CPU limit |api-licensing Memory limit |
|--------------------------|------------------------|------------------------|---------------------------|
|75                        |1                       |1                       |2                          |
|150                       |1                       |2                       |2                          |
|300                       |2                       |2                       |2                          |
|600                       |2                       |2                       |2                          |
|1200                      |2                       |2                       |2                          |
