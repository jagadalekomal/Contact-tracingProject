public with sharing class CTLocationTriggerHandler {
    public static void beforeInsert(List<Location__c> newLocationRecords){
        for(Location__c location : newLocationRecords){
            location.Status__c = 'Green';
        }
    }
    public static void beforeupdate(List<Location__c> newLocationRecords , map<id, Location__c> mapOfExistingRecords){
        for(Location__c location : newLocationRecords){
           if(location.Status__c != mapOfExistingRecords.get(location.id).Status__c) {
               location.Status_Update_Date__c = System.today();
           }
        }

    }
    public static void afterUpdate(List<Location__c> newLocationRecords , map<id, Location__c> mapOfExistingRecords){
        set<id> locationId = new set<id>();
        for(Location__c location : newLocationRecords){
            if(location.Status__c == 'Red' && mapOfExistingRecords.get(location.id).Status__c != 'Red'){
                locationId.add(location.id);
               }
            }
        List<Location_Tracing__c> getvisitors = CTLocationTracingContoller.getLocationByLocationIds(locationId);
        set<id> personsids = new set<id>();
        for(Location_Tracing__c trace : getvisitors){
            personsids.add(trace.person__c);
        }
        list<person__c> listToUpdate = new list<person__c>();
        for(id pid: personsids){
            listToUpdate.add(new person__c(id=pid, Health_Status__c='yellow'));
        }
        update listToUpdate;
        }
    
}