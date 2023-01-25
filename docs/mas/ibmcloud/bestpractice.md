# IBM Cloud

## IBM Storage

IBM Cloud provides both block and file storages for OCP. Both storages support ReadWriteMany access. If the app requires a high-performance disks, consider to setup custom performance storageclass as blow:


**block storage sample yaml**

```yaml
allowVolumeExpansion: true
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: block100p
parameters:
  billingType: hourly
  classVersion: "2"
  fsType: ext4
  sizeIOPSRange: |-
    [20-1999]Gi:[100-100]
  type: Performance
provisioner: ibm.io/ibmc-block
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

**file storage sample yaml**

```yaml
allowVolumeExpansion: true
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: file100p
parameters:
  billingType: hourly
  classVersion: "2"
  fsType: ext4
  sizeIOPSRange: |-
    [20-1999]Gi:[100-100]
  type: Performance
provisioner: ibm.io/ibmc-file
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

## IBM External Load Balancer

If the [built-in ingress load balancer](../ocp/bestpractice.md#ingress-controller) in OCP is unable to scale to handle with "large" workloads (100K+ concurrent device connections), consider to provision an instance of IBM cloud NLB2.0 (IPVS/KeepAlived) load balancer. 

## IBM ROKS

IBM ROKS is a managed Red Hat OpenShift Service in IBM Cloud. Each ROKS cluster comes with a fully managed control plane and compute nodes. Installation, management, maintenance, and upgrades are performed by Red Hat site reliability engineers (SRE) with joint Red Hat and IBM Cloud support.