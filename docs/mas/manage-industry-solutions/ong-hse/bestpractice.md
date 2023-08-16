# MAS Manage Oil and Gas

## Best Practice for Performance

1. If you want to search "Permit to Work" or "Isolation Certificate" or "Work Order" on description field, need to check if there is index on description column. Due to the back end SQL of Maximo will upper(description), the combined index which includes description and other column will not be used by DB2 at most time, had better create index only have 1 column "description" and had better create it as a text index. If some DB2 edition doesn't support text index, create a normal index on description column (1 column index) also help a lot on performance, but need to save description as upper case to use that normal index.

2. If you want to search on other field, please also double check if there is index on corresponding column you searched. Search by other column usually is faster than search on description field.

3. Archive or clean historical records of "Permit to Work", "Isolation Certificate", "Work Order" and "Operator Log/LogEntry" will help a lot on performance.

4. Adding below indexes which we identified in internal benchmark test will help a lot on performance.
   Please remember to update table statistics after adding any new index.

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
