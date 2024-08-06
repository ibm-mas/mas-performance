# Ping test Utility

When trying to diagnose a request timeout problem it is helpful to rule out gateways/load balancers outside the OCP cluster. Sometimes these external
gateways can have short timeouts which are resetting a connection before the request is completed. The Ping test Utility is designed to help
diagnose this issue.  

!!! info "**IMPORTANT**"
    As of this writing the Ping test utility is not part of the base server bundle code and needs to be loaded via a customization archive. 
    This means that the ManageWorkspace CR needs to be updated and will require a restart of the server bundles (i.e. it will cause a disruption
    while the server bundle pod is restarted).

### Updating the ManageWorkspace CR

- Edit the ManageWorkspace CR in the MAS Manage namespace

Single Customization Archive
```
spec:
  settings:
    customization:
      customizationArchive: https://ibm.box.com/shared/static/oj9z062b7x8hcywndnv6n57gya7e1ypz.zip
```

In case you already have a customization archive add to the `customizationList`
```
spec:
  settings:
    customizationList:
    - customizationArchiveName: archiveAlias1
      customizationArchiveUrl: https://ibm.box.com/shared/static/oj9z062b7x8hcywndnv6n57gya7e1ypz.zip
```

- Wait for the MAS Manage worspace operator to update the server bundle pods with the Ping servlet class and restart the server bundle pods

### Using the Ping servlet utility to test request timeouts outside the OCP cluster

- Run the following curl command outside the OCP cluster using the external hostname of the MAS Manage server bundle pod.  The command below will send
  a request to the Ping servlet which will wait for 1 second before responding.  If a response is returned it means no timeout occurred.

```
$ curl https://tenant1.manage.masperf4.ibmmas.com/maximo/ping?timeout=1
{"thread wait time":"1 seconds","status":"ok"}
$
```

- Change the timeout value to match the timeout that you are observing in problematic request.  For example, the Ping request below sets a timeout of 300
  seconds. If no response is received it means the request timed out and the same request should be attempted from inside the OCP cluster using the private 
  IP address of the server bundle pod (see `Using the Ping servlet utility to test request timeouts inside the OCP cluster` below).

```
$ curl https://tenant1.manage.masperf4.ibmmas.com/maximo/ping?timeout=300

```

### Using the Ping servlet utility to test request timeouts inside the OCP cluster

- Obtain the internal IP address of the MAS Manage UI server bundle pod.
- Go to maxinst pod in the MAS Manage namespace -> terminal tab, then execute below commands:

```
$ curl --insecure https://172.30.237.166:443/maximo/ping?timeout=300
{"thread wait time":"300 seconds","status":"ok"}
$
```

If you receive a response from the request issued to the internal pod IP, but do not receive a response issued externally from outside the cluster it could be the
case that an external gateway service or load balancer is closing the connection due to a shorter timeout set on the gateway. Check is a network administrator.