# Azure

## Azure Storage

For OCP cluster, it recommends Premium File Storage, because MAS and its components need RWX (Read/Write/Many permission) storage to support a certain level high availability as well as doclink, jms storage…

For External DB VM, it recommends a high-performance storage like **Premium SSD or v2 or Ultra Disk**. More performance metric can be found in https://learn.microsoft.com/en-us/azure/virtual-machines/disks-types.

