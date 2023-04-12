# OpenShift Container Platform

## Cluster Insights Advisor

Highly recommend to use OpenShift cluster Insights Advisor that to check for any issue related to the current version, nodes and mis-configurations. It is the first step for the problem diagnosis. 

Steps:

- Login on OpenShift Console
- Go to Administration -> Cluster Settings
- Click OpenShift Cluster Manager in Subscription section. It redirects the url to RedHat Hybrid Cloud Console
- Click Insights Advisor

## PID limit for docker

This settings control how many processes can be run within one single container. If it is too small, it can cause folk bomb issue. E.g. db2w instance may be unavailable when there are thousands of connections/agents upcoming or Openshift Container Storage not behaving well with a large amount of PVCs. 


**OOB value for OCP platforms:**

| Platform Version       | Default Value |
|------------------------|---------------|
| IBM ROKS (4.8)         | 231239        |
| AWS ROSA               | 1024 (Not Specified) |
| Azure Self-Managed OCP | 1024          |

**Steps to check or update PID limit:**
```
$ oc debug node/$NODE_NAME
$ chroot /host
$ cat /etc/crio/crio.conf
# add / modify the line "pids_limit = <new value>"
# run belows commands to reboot services and worker nodes
$ systemctl daemon-reload
$ systemctl restart crio
$ shutdown -r now
```

## HAProxy Router

### Ingress Controller

Openshift HAProxy supports up to 20k connections per pod. Consider to scale up ingress pod for any app (like IoT) with a high volume connection workload. 

**Scale up ingress controller**

- **command:**  `oc patch -n openshift-ingress-operator ingresscontroller/default --patch '{"spec":{"replicas": 3}}' --type=merge`


### Max Connection

One of the most important tunable parameters for HAProxy scalability is the `maxconn` parameter. The router can handle a maximum number of 20k concurrent connections by using `oc adm router --max-connections=xxxxx `. This parameter will be impacted by node settings `sysctl fs.nr_open` and `sysctl fs.file-max`. HAproxy will not start if maxconn is high, but node setting is low. 


**Note:** OpenShift Container Platform **no longer** supports modifying Ingress Controller deployments by setting environment variables such as ROUTER_THREADS, ROUTER_DEFAULT_TUNNEL_TIMEOUT, ROUTER_DEFAULT_CLIENT_TIMEOUT, ROUTER_DEFAULT_SERVER_TIMEOUT, and RELOAD_INTERVAL. You can modify the Ingress Controller deployment, but if the Ingress Operator is enabled, the configuration is overwritten.



### Load Balance Algorithm

There are 3 load-balancing algorithms: **source, roundrobin, and leastconn** (default: leastconn). Set up annotations for each route to change the default algorithm. e.g. `haproxy.router.openshift.io/balance=roundrobin`

## Master and Worker Nodes Consideration

There are a wide selection instance types that comprise varying combinations of CPU, memory, disk and network. Below are a few considerations:

- Each worker node will reserve about 1 core for internal services. In order to avoid the side effect of overcommit, 16core/64G is a good starting type for a normal worker node. A 8-core instance may not have insufficent capacity while 32-core instance may lose a big cluster capacity due to an outage or failure.   
- Using balanced CPU-memory worder nodes typically fits our work load -the ratio of CPU to memory is 1 to 4.
- An instance with a higher memory/cpu ratio e.g. 8:1 is recommended for database nodes. 
- The number of worker nodes >=3. This will give a high availability needing a smaller built in redundant capacity.
- For the product env, a 8core/32G is recommended for master nodes to avoid any bottleneck for the internal services. 
- An instance with 10GB ethernet is strongly recommended for the production env. 
- Check the GPU chip type for gpu node selection. 

