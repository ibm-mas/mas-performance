# MAS IoT 

## IoT Deployment

- IoT CRD defines 3 default size deployments: **dev, small, medium** that controls the default settings for pod replics, cpu and memory. For production, **medium** is required.
Sample yaml for medium deployment in IoT CR 
```yaml  
apiVersion: iot.ibm.com/v1
kind: IoT
metadata:
  name: masinst1
  namespace: mas-masinst1-iot
spec:
  bindings:
    jdbc: system
    kafka: system
    mongo: system
  settings:
    deployment:
      size: medium
```
- If need to adjust the default setting for a deployment, go the iot-operator pod, then change the corresponding yaml files under `/opt/ansible/roles/<ibm-iot-operator>/vars` folder, e.g. `/opt/ansible/roles/ibm-iot-actions/vars/size_medium.yml`


## Connection and OpenShift Ingress Controllers

Openshift HAProxy supports 20k connection per pod. The total connection determinants how many end devices can connect to IoT MSProxy. 

- By default, **IBM ROKS** deploys 3 router members that supports 3x20k = 60K connection
- By default, **AWS ROSA** deploys 2 router members that supports 2x20k = 40K connection
    - use the below command to scale up to 3 router members:
    `oc patch -n openshift-ingress-operator ingresscontroller/default --patch '{"spec":{"replicas": 3}}' --type=merge`

## Kafka

IoT uses Kafka to process the messages. Follow the [Kafka Configuration Reference](https://docs.confluent.io/platform/current/installation/configuration/topic-configs.html#retention-ms) to configure best value for Kafka/Topics `retention.ms, retention.bytes, partitions, replics` to support the workload. 


## AWS MSK

- configuration details can be found at [https://docs.aws.amazon.com/msk/latest/developerguide/msk-default-configuration.html](https://docs.aws.amazon.com/msk/latest/developerguide/msk-default-configuration.html)
- [monitoring MSK](../aws/bestpractice.md#amazon-msk) is strongly recommended
- [monitoring classic load-balance](../aws/bestpractice.md#classic-load-balancer-idle-timeout) is strongly recommend 


## Message Rate and Ethernet Network Bandwidth

Depending on the cloud providers, worker node instance has different network bandwidth. It determines how fast the end devices can send the request. Message rate is limited by the message size and the bandwidth of ethernet network. To achieve higher rates and/or larger messages it will require a 10GB ethernet. The network bandwidth also impacts the response latency. The higher bandwidth, the lower latency.  

Below deployment configurations are recommended as starting value with medium and large workload. 

* MSProxy - 4 MSProxies with 1 CPU and 4GB
* MessageGateWay - 1 MGW 6 CPUs and 16GB along with 4 TcpIop threads

### Modify TcpThread in MessageGateWay(MGW) pod
- edit `/var/messagesight/data/config/server.cfg`
- add a line  `TcpThreads = 4`
- do the above changes on all MGW Pod, then restart the pods

