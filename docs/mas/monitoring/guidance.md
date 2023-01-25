# Monitoring

Monitoring your OpenShift clusters is critical for the environment health, the quality of services. It helps ensure that all deployed workloads are running smoothly and that the environment is properly scoped. 

## OpenShift Monitoring Service (Promethus/Grafana)

OpenShift Container Platform includes a pre-installed monitoring stack that is based on the Prometheus/Grafana. **MAS** also provides app-level promethus metrics and a set of Grafana dashboards for application health. 

!!!tip "Best practice for OpenShift Monitoring Service"
    - enable User Workload: `enableUserWorkload: false`
    - consider to increase the promethus retention policy whose default value is 24h and add persistent volumes
    - consider to change Alert Manager's storage class and size

Below is the sample for configmap cluster-monitoring-config

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    enableUserWorkload: true
    prometheusK8s:
      retention: 90d
      volumeClaimTemplate:
        spec:
          storageClassName: nfs-client
          resources:
            requests:
              cpu: 200m
              storage: 300Gi
              memory: 2Gi
            limits:
              cpu: 2
              memory: 4Gi
    alertmanagerMain:
      volumeClaimTemplate:
        spec:
          storageClassName: nfs-client
          resources:
            requests:
              storage: 20Gi
```

!!!note 
    - Except OpenShift Monitoring Service (Promethus/Grafana), there are other paid solutions like  **IBM Instana**, **New Relic**, **Data Dog** that also support OCP. 
    - If the cluster is cloud based, consider to use cloud provider's monitoring tool for additional info like network, disk, managed services. e.g. AWS CloudWatch, IBM Log Analysis...