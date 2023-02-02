# AWS

## Instance Type

There are many instance types available in AWS. Based on the benchmark, recommend **M5, M6** instances (e.g.M5.4xlarge) as master or worker nodes and **P3, P4** as GPU nodes. 

!!!note
    - Depending on the regions, some instances may not be available. Use [AWS Pricing Calculator](https://calculator.aws/#/) to check the instance availability and cost. 
    - **g4dn** can be used as GPU node for test/dev env, but not recommended for production env.
    - If the application requires a good network performance, check [Amazon EC2 instance network bandwidth site](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/general-purpose-instances.html#general-purpose-network-performance) for more details. For production env, an instance with 10GB ethernet is recommended. 

## Classic Load Balancer Idle Timeout

Each OCP cluster creates 1 class load balancer and 2 network load balancers in AWS. AWS classic load balancer has a default idle time **60** seconds. In some cases, this value is not enough for a long time transaction (e.g. asset health check notebook). Consider to adjust this value to what the application needs (e.g. 300 seconds).

Also, monitoring classic load-balance performance is strongly recommend, particularly with IoT related app. (Note: Surge Queue Length's defaults to a hardcoded limit of **1024**. When queue is fully, the tcp handshake will fail)


## Amazon DocumentDB

 DocumentDB is a fully managed MongoDB compatibility database. It can be used by both IBM Suite License Service (SLS) and MAS Core. However, there are functional differences between DocumentDB and MongoDB. Check [this link](https://docs.aws.amazon.com/documentdb/latest/developerguide/functional-differences.html) for more details.
 
 **Note:** When using DocumentDB, it requires to set `RetryWrite=false` in SLS and Suite CRs. 

## Amazon MSK 

MAS supports MSK which is a fully managed apache Kafka service. 

!!!note
    - monitor MSK performance via CloudWatch is strongly recommended. Key metrics include **Disk usage by broker, CPU (User) usage by broker, Active Controller Count, Network RX packets by broker, Network TX packets by broker**.
    - define an appropriate config for Kafka, MSK and topics. e.g. retention.ms, retention.bytes, partitions and replics to support the workload.



## AWS Storage

**EBS storages** like gp2, gp3 are supported by OCP in AWS. **Note:** EBS storage is ReadWriteOnce. The volume can be mounted as read-write by a single node. **io1** and **io2** are SSD-based EBS that provides the higher performance. Check [Amazon EBS volume types](https://aws.amazon.com/ebs/volume-types/) for extra info like throughput, tuning and cost. 

Below is a **sample yaml** to create io1 storageclass with **100 iopsPerGB**. 

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: io1
provisioner: kubernetes.io/aws-ebs
parameters:
  encrypted: 'true'
  iopsPerGB: '100'
  type: io1
reclaimPolicy: Delete
allowVolumeExpansion: true
volumeBindingMode: Immediate
```


**EFS Storage** can be used as **ReadWriteMany** storageclass. EFS has different metered throughput modes.
    
- Bursting Throughput mode is the default. It is inexpensive, but does **NOT** perform well if all burst credits are used. Monitor **BurstCreditBalance** metric in CloudWatch. 
- Provisioned Throughput mode is relatively expensive. It can drive up to 3 GiBps for read operations and 1 GiBps for write operations per file system
- More info can be found at [Amazon EFS performance](https://docs.aws.amazon.com/efs/latest/ug/performance.html)

## Self-managed OCP vs AWS ROSA 

A self-managed OCP Cluster can be created by the installer cli tool that supports both IPI and UPI mode. It requires self maintenance and upgrades. Alternatively, ROSA is a managed Red Hat OpenShift Service. Each ROSA cluster comes with a fully managed control plane and compute nodes. Installation, management, maintenance, and upgrades are performed by Red Hat site reliability engineers (SRE) with joint Red Hat and Amazon support.



