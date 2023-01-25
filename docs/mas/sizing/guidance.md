# Sizing Guidance

!!! warning "The sizing number in this page is based on a standard workload. Used as reference only. "

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


## MAS Resource Statistics

| Namespace                    	| CPU Request 	| CPU Limits 	| Memory   Request(GB) 	| Memory   Limits(GB) 	|
|------------------------------	|-------------	|-----------	|----------------------	|---------------------	|
|            mas-masinst1-core 	| 0.71        	| 18.95     	| 6.18                 	| 32.50               	|
|          mas-masinst1-manage 	| 2.5         	| 11.1      	| 4.04                 	| 17.00               	|
|       mas-innovation-monitor 	| 3.5          	| 19.25       	| 12.84                	| 32.57               	|
|           mas-innovation-iot 	| 19.66        	| 214.649      	| 57.08                	| 269.00               	|
|                        mongo 	| 3           	| 9         	| 2.24                 	| 6.98                	|
|                      ibm-sls 	| 0.12        	| 2.6       	| 0.56                 	| 4.50                	|
|                        kafka 	| 9.2         	| 31        	| 30.38                	| 30.38               	|
|          ibm-common-services 	| 0.81        	| 1.92      	| 1.30                 	| 2.73                	|
|                   OpenShift  	| 3.2         	|           	| 28                   	|                     	|
|                     Subtotal 	| 42.7(core)    | 308.469(core) | 142.62(GB)            | 395.66 (GB)           |
|        **Additional cost**    |  - - - - - - -| - - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - |
|                         ocs* 	|  14 	        |  32 	        |14 	                | 32 	                |
| cp4d (with 2 db2w instances)* | 31.59       	| 40.7      	| 235.39               	| 249.70              	|
|   each additional manage pod* | 1           	| 6         	| 2                    	| 10                  	|
