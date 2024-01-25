As a result of architectural modifications, Maximo 8.x (MAS Manage app) now operates on WebSphere Liberty Base 21.0.0.5 with OpenJ9 within the OpenShift Container Platform (OCP). It's essential to note that JVM arguments outlined in the 7.x Best Practice documentation may not be relevant or applicable to the Maximo 8.x environment. Here are additional details:

### WebSphere Liberty

As of WebSphere Liberty 18.0.0.1, the thread growth algorithm is enhanced to grow thread capacity more aggressively so as to react more rapidly to peak loads. For many environments, this autonomic tuning provided by the Open Liberty thread pool works well with no configuration or tuning by the operator. If necessary, you can adjust `coreThreads` and `maxThreads` value. 

### Generic JVM Arguments

* **-Xgcpolicy:gencon**

    Gencon is the default policy in OpenJ9, this parameter works in both 7.x and 8.x

* **-Xmx or -XX:MaxRAMPercentage** (maximum heap size)
    
    If not specifying -Xmx value, JVM uses 75% of total container memory when -XX:+UseContainerSupport is set. When -Xmx is set, -XX:MaxRAMPercentage will be ignored. 
    
* **-XX:+UseContainerSupport/-XX:-UseContainerSupport** 
    
    If -XX:+UseContainerSupport is set, it allows to change the InitialRAMPercentage and MaxRAMPercentage values. -Xms and -Xmx can overwrite the limits.
    
* **-Xmn** (Nursery Space)
    
    Setting the size of the nursery when using this policy can be very important to optimize performance. 25 - 33% of total heap is recommended. Please note manage pod limited memory is 10G that is not Total heap size. Heap size is based on (-Xmx or -XX:MaxRAMPercentage) setting. 10G also includes memory used by websphere for cache, compilation as well maximo mmi container. 

* **-Xgcthreads4**
    
    This parameter is used to set the number of threads that the Garbage Collector uses for parallel operations. By default, it is set to n -1 in OpenJ9 where n is the number of reported cpu on the node. You might want to restrict the number of GC threads used by each VM to reduce some overhead. 

* **-XcompilationThreads4**
    
    This parameter is used to specify the number of compilation threads that are used by the JIT compiler. Same as gcthread, you might want to restrict the number of compilation threads used by each VM to reduce some overhead. 

* **-Xshareclasses**
    
    this parameter is used to share class data between running VMs, which can reduce the startup time for a VM once the cache has been created. 

* **‑Xdisableexplicitgc (Recommended)**
    
    This parameter is used to disabling explicit garbage collection disables any System.gc() calls from triggering garbage collections. For optimal performance, disable explicit garbage collection.

* **-Djava.net.preferIPv4Stack=true/-Djava.net.preferIPv6Addresses=false**
    
    For performance reasons, Maximo recommends to set this property to true. Note: this parameter can not be applied on the hosts that only communicate with ipv6. 

* **-XX:PermSize and -XX:MaxPermSize**
    Maximo 7.x BP recommends 320m. If seeing an OOM for PermSize, consider to increase to 512MI or higher. 

* **-Xcodecache32m**
    The maximum value you can specify for -Xcodecache is 32 MB. JIT compiler might allocate more than one code cache. It is controlled by -Xcodecachetotal which default value is 256MB. 

* **-Xverbosegclog**

    Enable verbose gc log for the garbage collection analysis

* **-Xtune:virtualized (under review)**
    
    Optimizes OpenJ9 VM function for virtualized environments, such as a cloud, by reducing OpenJ9 VM CPU consumption when idle.