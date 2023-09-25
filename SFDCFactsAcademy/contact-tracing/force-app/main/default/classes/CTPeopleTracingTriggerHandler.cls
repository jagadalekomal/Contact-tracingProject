public with sharing class CTPeopleTracingTriggerHandler {
    public static void beforeInsert(List<People_Tracing__c> newInsertedRecords){
        List<People_Tracing__c> duplicateRecords = CTPeopleTracingController.checkDuplicates(newInsertedRecords);
        for(People_Tracing__c trace : duplicateRecords){
            trace.adderror('Duplicate record found. person 1 : ' +trace.Person_1__c + ' person 2 :' + trace.Person_2__c);
        }
    }
}