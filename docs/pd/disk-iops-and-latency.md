# Python script for checking disk IOPS and write latency

Different Maximo components require different minimal disk performance abilities in order to see optimal performance. The [python script found here](https://ibm-mas.github.io/mas-performance/pd/download/disk-iops-and-latency-test.py) can be used to test important disk (ie, physical volume) characteristics on pods that contain python.

### Directions for using the disk-iops-and-latency-test.py script

- Make sure the pod that mounts the storage that you wish test has python installed in it:

```
oc -n <namespace> exec <pod_name> -- bash -c 'python V'
Python 3.12.13
```

- If python isn't available in the container (or not installed into the $PATH) you may receive the following error:

```
bash: line 1: python: command not found
command terminated with exit code 127
```

- If Python is available inside the container, download [this python script](https://ibm-mas.github.io/mas-performance/pd/download/disk-iops-and-latency-test.py) either via the browser or using curl, like this:

```
curl -L -v -o disk-iops-and-latency-test.py https://ibm-mas.github.io/mas-performance/pd/download/disk-iops-and-latency-test.py
```

- Make sure the script is executable:

```
chmod +x disk-iops-and-latency-test.py
```

- Copy the script to the /tmp directory inside the container:

```
oc -n <namespace> cp disk-iops-and-latency-test.py <pod_name>:/tmp/disk-iops-and-latency-test.py`
```

- Determine which file system inside the container is mounting the storage you wish to test:

```
oc -n <namespace> exec <pod_name> -- bash -c 'mount'
```
- Run the python script using oc exec specifying the following parameters:
    - The full path to the python script on the container; example:
    ```
    /tmp/disk-iops-and-latency-test.py
    ```

    - The file you wish to write to test the disk characteristics. This should be written to a directory in the file system that mounts the physical volume you wish to test. Example:
    ```
    /jms/write-test.out
    ```

    - The number of write iterations (default is 1000)
    - The size of data written per iteration (default is 4096 bytes)
    - Enable/disable Direct I/O: (optional): 1 or 0 whether you want to disable Direct I/O (some file systems don't support Direct I/O in which case you must pass in 0 for this parameter to make the script work).
    - Full example:

    ```
    oc -n <mas_manage_namespace> exec -it <manage_jms_pod_name> -- /tmp/disk-iops-and-latency-test.py /jms/write-test.out 1000 4096 1
    ```

    - When the script executes successfully, you should see output similar to this:

    ```
DISK WRITE PERFORMANCE RESULTS
============================================================

IOPS Metrics:
  Write IOPS:           2,076.37 ops/sec
  Throughput:           10.28 MB/s
  Total operations:     1,000
  Total time:           0.38 seconds
  Total data written:   3.91 MB

Latency Metrics (milliseconds):
  Average:              0.480 ms
  Median (P50):         0.499 ms
  Std Deviation:        0.064 ms
  Minimum:              0.342 ms
  Maximum:              1.054 ms

Latency Percentiles:
  P50 (median):         0.500 ms
  P95:                  0.549 ms
  P99:                  0.601 ms
  P99.9:                1.054 ms
============================================================
```
    - Fields to pay special attention are:
        - "Throughput" (under "IOPS Metrics")
        - "Average" and "Median" values under "Latency Metrics" (for JMS pods, for example)




