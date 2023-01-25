# MAS Core

## Workload Scaling ConfigMap

Since MAS 8.10, a configmap  `custom-wl-scaling` is used to set the resource settings for cpu, memory and replic. Modify the default value or create a custom one if needed. Below is the sample of `workloadScaling.yaml`.
```yaml
coreidpcfg:
  replicas: 1
  resources:
    requests:
      cpu: 10m
      memory: 64Mi
    limits:
      cpu: 200m
      memory: 512Mi
slscfg:
  replicas: 1
  resources:
    requests:
      cpu: 10m
      memory: 64Mi
    limits:
      cpu: 200m
      memory: 512Mi
```

!!!tip
    - high workload impact pods: **core-ipd, core-api, license-mediator**
    - check [MAS Pods Explained](https://ibm-mas.github.io/cli/guides/mas-pods-explained/) to understand the insight of each pod functionality 
    - check the health of [mongodb](../mongodb/bestpractice.md) and sls pods if any performance issue is detected
