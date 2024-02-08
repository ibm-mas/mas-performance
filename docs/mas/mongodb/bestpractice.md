# MongoDB 

## MongoDB Troubleshoot:

  * mongostat:  `mongostat --username admin --password <password> --authenticationDatabase admin --ssl --sslAllowInvalidCertificates 2`
  * mongotop: `mongotop --username admin --password <password> --authenticationDatabase admin --ssl --sslAllowInvalidCertificates 2`
  * check mongod log for slow queries (MongoDB community): `oc logs -n <mongo namespace> <mongo pod name> -c mongod | grep -iE 'Slow query'`
  * long connection over 3 seconds: `db.currentOp({"active" : true,"secs_running" : { "$gt" : 3 },"ns" : /^msg/})`
  * kill long running connection: `db.killOp("opid")`
  * locking: `db.serverStatus().globalLock`
  * mem: `db.serverStatus().mem`
  * wiredTiger cache: `db.serverStatus().wiredTiger.cache`
  * concurrent: `db.serverStatus().connections`
