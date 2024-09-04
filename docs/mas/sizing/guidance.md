# Sizing Guidance

!!! danger "Critical Note"
    The sizing number in this page is based on a standard workload. Used as reference only.
    The current calculator lacks information about the storage size for worker nodes. We are working on an update now. A minimum of 300GB of storage per worker node is strongly recommended to meet the requirements of the MAS app build process. 


## Sizing Calculation Sheet 

Use [Sizing Calculation Sheet](https://ibm.seismic.com/Link/Content/DC8bqDGgWfRpJ8QF8qd3m2WqG9D8) for MAS sizing. 


## Factors that impact the sizing consideration

* storage operator: e.g. ocs, odf...
* cp4d services: e.g. db2w, watson studio...
* mongodb service
* kafka service

### OCS (OpenShift Container Storage)

If using OCS to manage the storage class, OCS service itself requires minimum 3 nodes with 14 core / 32G (Note: this is the total request amount, not per node).

### ODF (OpenShift Data Foundation)

3 OCP nodes will run ODF services. (NOTE: OCP clusters often contain additional OCP worker nodes which do not run ODF services.)
Each OCP node running ODF services has:16 core / 64 GB memory

### CP4D/DB2W Minimum Resource Requirement

* When running CP4D/DB2W on OpenShift's worknode, each instance requires at least **6.1 core and 18G ram**. Note: an instance pod cannot be scheduled if the node's (total capacity - total limit) is less than 6.1 core or 18G ram,
* a dedicated worker node or external db is recommended. 
* db2 operator is an alternative. 

## MAS Manage

Based on the benchmark results, for sizing we recommend 50 - 75 user load per MAS Manage UI server bundle pod, which is equivalent to a JVM with 2 core on Maximo 7.6.x.

## MAS Resource Statistics

* use below values as reference only. 
* the footprint is based on the loads and spec settings. e.g. IoT T-shirt size, Manage bundle and replic #
* the value below is based on IoT small T-shirt size and Manage with only all-in-one bundle and replic =1

| App                   | CPU Request (core) |  CPU   Limits (core) | Memory Rquest (GB) |  Memory Limits(GB)  |
|-----------------------|--------------------|----------------------|-------------------|---------------------|
| Add                   | 6                  | 12                   | 13                | 26                  |
| Assist                | 12.4               | 57.7                 | 19.46             | 62.38              |
| Core                  | 1.5                | 18.95                | 6.27              | 32.5                |
| Health                | 2.9                | 15.6                 | 7.12              | 30.84         |
| HPU                   | 0.9                | 5.5                  | 0.92              | 6.5                 |
| IoT                   | 19.66              | 214.65               | 57.08             | 269                 |
| Manage                | 2.9                | 11.1                 | 4.04              | 17                  |
| Monitor               | 5.4                | 32.4                 | 12.84             | 55.5                |
| Optimizer             | 7.4                | 19.3                 | 25.57             | 117                 |
| Predict               | 3.1                | 12.5                 | 6.13              | 24.5                |
|        **Additional cost**    |  - - - - - - -| - - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - |
|                         ocs* 	|  14 	        |  32 	        |14 	                | 32 	                |
| cp4d (with 2 db2w instances)* | 31.59       	| 40.7      	| 235.39               	| 249.70              	|
|   each additional manage pod* | 1           	| 6         	| 2                    	| 10                  	|
