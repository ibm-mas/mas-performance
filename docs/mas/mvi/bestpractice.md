# Vision dataset pod autoscaling via HPA

The vision dataset pod(s) handle the dataset related operations from the Visual Inspection application, and as such are often the busiest pods in the Visual Inspection namespace. A kubernetes horizontal pod autoscaler [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) is used to scale the vision dataset pods based on cpu usage relative to the pod cpu requests.

!!! Important
    As of this writing, the default max replicas value in the vision dataset HPA is 2. For most workloads 2 vision dataset pods is sufficient, but in some large workloads (e.g. many hundreds of concurrent users) it might be necessary to increase the max replicas on the vision dataset HPA to 3 or 4.

# PVC and Cloud Object Storage performance
For I/O intensive operations, for example, the operations listed below, disk performance is critical. 

- DataSet migration: training to inspection and inspection to training
- DataSet export

Recommend a persistent volume with at least

- 250 MB/s disk throughput
- IOPS: 10 IOPS/GB to 100/IOPS/GB (depending on the volume size)

It is also recommended to provision the bucket used for Object Storage in the same region as the OCP cluster used to host MAS Visual Inspection, for optimal network latency.