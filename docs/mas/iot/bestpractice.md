# MAS IoT 

## MQTT vs HTTP Messaging
The MQTT protocol is the preferred messaging protocol for data ingest in to the MAS IoT service. HTTP messaging support was added to MAS IoT for low volume scenarios and is not designed to be used for message rates greater than 1K msgs/sec.

MQTT message ingest rates are 2-3 orders of magnitude faster than HTTP. The primary reason being that HTTP messaging requires a TLS handshake and authentication on every message published. The authentication requires a database lookup for the device authentication token.  As such, HTTP messaging puts a strain on the authentication service and the IoT database.

In order to achieve high data ingest rates with MAS IoT service, use the MQTT protocol and keep the device connection open while publishing messages.  

### Best practice messaging pattern

```
MQTT CONNECT
MQTT PUBLISH (in loop until all messages are published)
```

### Messaging Anti-pattern

```
MQTT CONNECT
MQTT PUBLISH
MQTT DISCONNECT
MQTT CONNECT
MQTT PUBLISH
MQTT DISCONNECT
...
```

## Data Ingest rates, devices, and connections
The MQTT service in MAS IoT was designed to handle many device connections, each publishing at low rates. As such, when designing a data ingest application for MAS IoT it should distribute the load over many MQTT devices or applications in order to maximize message rates. Single device or application connections will be throttled based on the IoT Fair use policy (see below).

## IoT Fair Use Policy
IoT data ingest throttling limits are per device and are based on the device class (i.e. Device, Gateway, Application).  These limits are in place to prevent DoS attacks from rogue (i.e. badly behaving) devices. The throttling limits do not scale with the MAS IoT deployment size. For more information on MAS IoT messaging quotas see [https://www.ibm.com/docs/en/mapms/1_cloud?topic=features-quotas](https://www.ibm.com/docs/en/mapms/1_cloud?topic=features-quotas)


## Messaging QoS
The messaging QoS specified when publishing an MQTT message also has a strong impact on messaging rates.

QoS in order of fastest to slowest:

- QoS 0 - at most once (data loss possible, no message persistence or ACKs)
- QoS 1 - at least once (duplicates are possible, messages persisted and ACKed)
- QoS 2 - exactly once (application client required to maintain state, messages persisted and two phase commit between client/server)

QoS >0 performance considerations

- requires disk persistence in MAS IoT messaging components and therefore disk I/O performance becomes critical with QoS >0.
- the MQTT specification provides a kind of protocol level flow control negotiation between client and server. The number of unacked messages allowed on the session is negotiated between client and server and if the client has no more available msg ids it must pause publishing until msg IDs become available. Msg IDs become available when messages ACKs are received. See MQTT spec for details: [https://docs.oasis-open.org/mqtt/mqtt/v5.0/os/mqtt-v5.0-os.html#_QoS_1:_At](https://docs.oasis-open.org/mqtt/mqtt/v5.0/os/mqtt-v5.0-os.html#_QoS_1:_At)

## Summary of factors that influence data ingestion rate

- Choice of messaging protocol: MQTT (high volume) vs HTTP (low volume)
- Messaging Pattern: do NOT close MQTT sessions after each message published. leave connections open.
- Number of devices: Higher message rates are possible when the load is distributed over more connections
- Choice of device class: Fair use quotas are based on device class (https://www.ibm.com/docs/en/mapms/1_cloud?topic=features-quotas)[https://www.ibm.com/docs/en/mapms/1_cloud?topic=features-quotas]
- Choice of QoS: high levels of messaging guarantees come with higher costs 

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


