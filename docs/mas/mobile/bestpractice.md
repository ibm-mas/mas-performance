# MAS Manage Mobile


### Tips and Tricks:


- Strongly recommend creating a mobile database for supporting data downloads. Online support downloading can significantly impact the performance of Mobile Pods, databases, and networks.

- To mitigate download failures, consider increasing the timeout value for the ingressor. The default server/client timeout is set too low, affecting the pass rate. Use the following commands to raise the default value:

    `oc -n openshift-ingress-operator patch ingresscontroller/default --type=merge -p '{"spec":{"tuningOptions": {"clientTimeout": "300s"}}}'`

    `oc -n openshift-ingress-operator patch ingresscontroller/default --type=merge -p '{"spec":{"tuningOptions": {"serverTimeout": "300s"}}}'`
    

- Scaling up the coreapi pod can enhance the downloading experience for the mobile app.

- Consider scaling up the mobile pods when the CPU usage of a pod exceeds 4.

- Optimal disk throughput for the database is crucial for a smooth app downloading experience.

- Observations from lab tests suggest that balanced node resource utilization is crucial for optimal performance. It is worth noting that the default topology spread constraints in the ManageWorkspace Custom Resource (CR) are set to "topologyKey: topology.kubernetes.io/zone". However, in a single-zone cluster, if the pod is not being evenly distributed across worker nodes, considerto be set to "topologyKey: topology.kubernetes.io/hostname" instead. 
