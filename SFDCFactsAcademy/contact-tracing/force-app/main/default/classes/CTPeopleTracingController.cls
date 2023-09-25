public with sharing class CTPeopleTracingController {
    Public Static List<People_Tracing__c> getTraces(String RecordId){
        List<People_Tracing__c> trace = [Select Contact_Date__c,Contact_Type__c,Person_1__r.Health_Status__c,
        Person_2__r.Health_Status__c,Person_1__r.Token__c,Person_2__r.Token__c,Person_1__c,Person_2__c 
        From People_Tracing__c
        Where  Person_1__c =: RecordId
        OR Person_2__c =: RecordId
        ORDER BY Contact_Date__c DESC];
        Return trace;
    }

Public Static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTraces){
    Set<Id> person1 = new Set<Id>;
    
    for(List<People_Tracing__c> trace : peopleTraces){
        person1.add(trace.Person_1__c);
        person1.add(trace.Person_2__c);
        }
        Map<Id,Set<Id>> mapOfExitingRecords = new Map<Id,Set<Id>>();

        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
    
        List<People_Tracing__c> existingRecords = [Select Person_1__c,Person_2__c
                                               From People_Tracing__c
                                               Where Person_1__c IN:person1
                                               OR Person_2__c IN:person1];
    if(existingRecords!=Null && existingRecords.size()>0){
        for(People_Tracing__c trace: existingRecords){
            If(!mapOfExitingRecords.containsKey(trace.Person_1__c)){
                mapOfExitingRecords.put(trace.Person_1__c , new Set<Id>);
            }
            mapOfExitingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

            If(!mapOfExitingRecords.containsKey(trace.Person_2__c)){
                mapOfExitingRecords.put(trace.Person_2__c , new Set<Id>);
            }
            mapOfExitingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
        }
    

            For(People_Tracing__c trace : peopleTraces){
                if(
                (mapOfExitingRecords.containsKey(trace.Person_1__c) && mapOfExitingRecords.get(trace.Person_1__c).contains(trace.Person_2__c))
                ||
                  (mapOfExitingRecords.containsKey(trace.Person_2__c) && mapOfExitingRecords.get(trace.Person_2__c).contains(trace.Person_1__c))) {
                
                    duplicates.add(trace);
                }
                
            }
                
        }                                           
    return duplicates;
    }
}