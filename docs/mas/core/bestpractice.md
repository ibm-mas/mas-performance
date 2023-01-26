# MAS Core

## Workload Scaling ConfigMap

Since 8.10, MAS core allows users to customize resource settings for cpu, memory and replica counts per component. By default MAS ships with three default configmaps for workload scaling:

- {mas_instance_id}-wl-cust-small
- {mas_instance_id}-wl-cust-medium
- {mas_instance_id}-wl-cust-large

You can modify the default configmaps or create a custom one if needed. Should you decide to create a custom workload scaling configmap, it must be specified using the [MAS Suite CR](https://github.com/ibm-mas/ansible-devops/blob/master/ibm/mas_devops/roles/suite_install/templates/core_v1_suite.yml.j2#L41). Below is a snippet of a custom configmap for workload scaling. You should understand what you are doing before you change the default values, as decreasing resources can have undesirable effects.

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
    - check the health of [mongodb](../mongodb/bestpractice.md) and sls api-licensing pods (in the SLS namespace) if any performance issue is detected
