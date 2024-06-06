# MAS Manage Oil and Gas/HSE

## Best Practice for Performance

1. Archive or clean historical records of "Permit to Work", "Isolation Certificate", "Work Order" and "Operator Log/LogEntry" will help a lot on performance.  
<br>  
2. Adding below indexes which we identified in internal benchmark test will help a lot on performance.  
   Please do remember to update table statistics after adding any new index, since new index will only be effective after updating table statistics.

## Indexes Identified in Internal Benchmark Test
| Table Name        | Columns                                                                   | Comments                                                              |
| ----------------- | ------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| plusgpermitwork   | "ptwclass" ASC,"siteid" ASC,"orgid" ASC,"permitworknum" ASC               |                                                                       |
| plusgpermitwork   | "ptwclass" ASC,"status" ASC,"plusgpertypeid" ASC,"permitworknum" ASC      |                                                                       |
| plusgpermitwork   | "ptwclass" ASC                                                            |                                                                       |
| plusgpermitwork   | "status" ASC,"ptwclass" ASC,"description" ASC                             |                                                                       |
| plusgpertype      | "pertypenum" ASC,"plusgpertypeid" ASC                                     |                                                                       |
| workorder         | "description" ASC                                                         | Add it if search on description field, create as text index is better |
| workorder         | "status" ASC,"historyflag" ASC,"istask" ASC,"wonum" ASC                   | Add it if search on status field                                      |
| plusgoperaction   | "recordid" ASC,"class" ASC                                                |                                                                       |
| plusgshftlogentry | "recordkey" ASC,"orgid" ASC,"siteid" ASC,"createdate" ASC                 |                                                                       |
| plusgshiftlog     | "shiftnum" ASC,"isshiftlog" ASC,"startdate" ASC                           |                                                                       |
| plusgrelatedrec   | "relatedreckey" ASC,"relatedrecclass" ASC,"recordkey" ASC                 |                                                                       |
| plusgrelatedrec   | "recordkey" ASC,"class" ASC,"relatedrecclass" ASC                         |                                                                       |
| plusgincperson    | "ticketid" ASC                                                            |                                                                       |
| maxsession        | "issystem" ASC, "userid" ASC, "clienthost" ASC                            |                                                                       |
| ticket            | "globalticketid" ASC,"globalticketclass" ASC                              |                                                                       |
| report            | "reportname" ASC,"appname" ASC,"reportnum" ASC,"runtype" ASC,"userid" ASC |                                                                       |
| reportrunqueue    | "running" ASC,"priority" ASC,"submittime" DESC                            |                                                                       |
