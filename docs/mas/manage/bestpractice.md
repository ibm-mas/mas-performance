# MAS Manage

## App Server

MAS Manage has different bundle types e.g. All, UI, MEA, Report and CRON to configure app server. Adjust the resource settings like cpu, memory, replic to match the workload. The setting is in ManageWorkspaces CR. Below is the sample. 

```yaml
apiVersion: apps.mas.ibm.com/v1
kind: ManageWorkspace
...
spec:
 settings:
    deployment:
      serverBundles:
        - bundleType: mea
          isDefault: false
          isMobileTarget: false
          isUserSyncTarget: true
          name: mea
          replica: 1
          routeSubDomain: all
        - bundleType: cron
          isDefault: false
          isMobileTarget: false
          isUserSyncTarget: false
          name: cron
          replica: 1
...
```

## DB Server

Follow [Maximo 7 Best Practice](../../maximo-7/bestpractice.md) for db configuration and tuning. 

## Manage Pod Functionality

Follow [this page](https://ibm-mas.github.io/cli/guides/mas-pods-explained/#manage-pods) to understand the manage pod functionality. 

## LTPA timeout

Using IBM Maximo Application Suite (MAS), Manage users will receive an error message saying to reload the application after 2 hours, even while actively working. This 2-hour timeout default is when the LTPA token in Manage expires, and is redirecting the user back to the login page for MAS. Follow [Updating LTPA timeout in Manage](https://www.ibm.com/support/pages/node/6841623) to increase the default value. 

## WebSphere Liberty

Due to the architecture change, Maximo 8.x (MAS Manage app) is deployed on WebSphere Liberty Base 21.0.0.5 with OpenJ9. As of WebSphere Liberty 18.0.0.1, the thread growth algorithm is enhanced to grow thread capacity more aggressively so as to react more rapidly to peak loads. For many environments, this autonomic tuning provided by the Open Liberty thread pool works well with no configuration or tuning by the operator. If necessary, you can adjust `coreThreads` and `maxThreads` value. Follow [this page](https://www.ibm.com/docs/en/was-liberty/core?topic=tuning-liberty) for tuning liberty

### Configure JVM options in Manage app
Follow [this page](https://www.ibm.com/docs/en/maximo-manage/continuous-delivery?topic=application-configuring-jvm-options) to configure JVM options
Fo