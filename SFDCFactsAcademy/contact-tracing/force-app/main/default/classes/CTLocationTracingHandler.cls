public with sharing class CTLocationTracingHandler {
    public static void beforeInsert(List<Location_Tracing__c> newInsertedRecords){
        List<Location_Tracing__c> duplicates = CTLocationTracingContoller.checkDuplicates(newInsertedRecords);
        for(Location_Tracing__c trace : duplicates){
            trace.adderror('duplicate record found . Person  : '+trace.person__c+' Location :' +trace.Location__c);
        }
    }
}