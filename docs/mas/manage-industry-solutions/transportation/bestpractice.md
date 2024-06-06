# MAS Manage Transportation

## Best Practice for Performance

1. Due to some Transportation applications execute SQLs contain "Like" clause, turn off DB2 Statement Concentrator can make CPU utilization much lower on database server (db2 update db cfg for database_name using stmt_conc off).  
<br>   
2. Adding below indexes which we identified in internal benchmark test will help a lot on performance.  
   If not specified, all columns are ASC by default.  
   Please do remember to update table statistics after adding any new index, since new index will only be effective after updating table statistics.

## Indexes Identified in Internal Benchmark Test
| Table Name        | Columns                                                                   | 
| ----------------- | ------------------------------------------------------------------------- | 
| PLUSTWARRTRANS    | CONTRACTTYPE,CLAIMID,ASSETNUM,CONTRACTNUM,SITEID                          | 
| PLUSTWARRTRANS    | CONTRACTTYPE,CLAIMID,TRANSDATE,PLUSTWARRTRANSID                           | 
| maxuser           | status,userid                                                             | 
| logintracking     | "userid" ASC,"attemptresult" ASC,"attemptdate" DESC                       |
| craftrate         | orgid                                                                     |
| SYNONYMDOMAIN     | MAXVALUE,DOMAINID,VALUE                                                   | 
| CONTLINEASSET     | "PLUSTNEWEXTENDEDREASON" ASC, "LOCATION" DESC                             | 
| CONTRACT          | CONTRACTTYPE,STATUS,ORGID,CONTRACTNUM                                     | 
| LOCHIERARCHY      | LOCATION,SYSTEMID,SITEID,PARENT                                           |  
| MULTIASSETLOCCI   | ISPRIMARY,RECORDKEY,WORKSITEID,RECORDCLASS                           |
| PLUSTASSETALIAS   | ISACTIVE,ALIAS,PLUSTASSETALIASID,DESCRIPTION,ORGID,LANGCODE,ISDEFAULT,ISASSETNUM,HASLD,SITEID,ASSETNUM | 
| INVOICELINE       | PLUSTCONTRACTNUM,SITEID,INVOICELINENUM,INVOICENUM                         | 
| INVOICE           | INVOICENUM,SITEID,STATUS                                                  |
| INVOICELINE       | INVOICENUM,SITEID,INVOICELINENUM                                          | 
| INVOICECOST       | "INVOICENUM" ASC, "SITEID" ASC, "ASSETNUM" ASC, "INVOICELINENUM" ASC      | 
| ASSET             | "ASSETNUM" ASC, "SITEID" ASC, "ASSETID" ASC                               | 
| inspectionform    | inspformnum,status,orgid                                                  | 
| inspectionresult  | "siteid" ASC, "referenceobject" ASC, "referenceobjectid" ASC              | 
| PLUSTWARRTRANS    | "CONTRACTTYPE" ASC, "CLAIMID" ASC, "PLUSTWARRTRANSID" ASC                 | 
| propertydefault   | contracttypeid,orgid                                                      | 
| plustitemwarr     | itemnum,plustpos,orgid,assetid,matusetransid,plustitemwarrid              |
| plustitemwarrmtr  | plustitemwarrid                                                           |
| plustassetalias   | assetnum,siteid,isdefault                                                 | 
| PLUSTWARRTRANS    | "CLAIMID" ASC, "SITEID" ASC                                               | 
| countbookline     | itemnum,countbooknum,siteid                                               | 
| countbookline     | countbooknum,siteid,orgid                                                 |  
| countbookline     | match,countbooknum,siteid,orgid                                           |
| countbookline     | recon,countbooknum,siteid,orgid                                           | 
| countbookline     | physcnt,countbooknum,siteid,orgid                                         | 
| countbook         | storeroom,countbooknum,siteid                                             |
| item              | itemsetid,itemnum                                                         | 
| warrantyasset     | contractnum,revisionnum,orgid,assetid                                     | 
| contractline      | CONTRACTNUM,REVISIONNUM,ORGID,CONTRACTLINENUM,contracttype                | 
| invbalances       | "PHYSCNTDATE" DESC, "SITEID" ASC, "ITEMNUM" ASC                           |
| countbookline     | countbooknum,siteid,rotating,itemnum                                      | 
| invbalances       | location,nextphycntdate                                                   | 
| inventory         | location,siteid,orgid,itemnum                                             | 
| countbooksel      | countbooknum,siteid                                                       |
| mafappdata        | ismobile,status                                                           |
| asset             | assetnum,siteid,status,plustisconsist,plustalias,orgid                    | 
| plustassetalias   | assetnum,siteid,isactive                                                  | 
| invoicecost       | assetnum,siteid                                                           | 
| plustclaim        | orgid,contractnum,status                                                  |  
| plustclaim        | assetnum,siteid                                                           |
| asset             | assetid,moved,plustisconsist,description                                  | 
| invoice           | siteid,invoicenum,status,orgid                                            | 
| wplabor           | wplaborid,orgid                                                           |
| joblabor          | orgid,siteid,jobplanid,jptask                                             | 
| workorder         | plustcmpnum,siteid,status                                                 | 
| plustitemwarr     | matusetransid                                                             | 
| contlineasset     | assetid,location,locationsite,warrantystartdate,warrantyenddate,contractnum |
| CONTRACT          | contractnum,revisionnum,orgid,contracttype,status                         | 
| contlineasset     | assetid,orgid,plustfullcoverage,contractnum,revisionnum,contractlinenum   | 
| plustwpserv       | wpservid,orgid                                                            | 
| plustwarrtrans    | matusetransid,covereditemnum                                              |
| contractline      | itemnum,conditioncode,linestatus                                          |
| warrantyline      | plustcoverservices,plustcovermaterials                                    | 
| pm                | siteid,status,pmnum,assetnum                                              | 
| workorder         | siteid,pmnum,status                                                       | 
| plustwpserv       | wonum,siteid                                                              |  
| plustwarrtrans    | servrectransid                                                            |
| plustwarrtrans    | parentwonum,refwonum,claimid,siteid,linecost                              | 
| plustwpserv       | invoicenum,invoicesite                                                    | 
| invoice           | status,invoicenum,siteid                                                  |
| maxvars           | varname,orgid,varvalue                                                    | 
| inspectionresult  | inspformnum,revision,orgid,siteid,status,asset,location,resultnum         | 
| plustwpserv       | wonum,invoicenum,complete                                                 | 
