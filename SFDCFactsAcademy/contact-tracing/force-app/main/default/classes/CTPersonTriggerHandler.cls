public with sharing class CTPersonTriggerHandler {
    public static void beforeInsertHandler(List<Person__c> newpersonRecords){
        for(Person__c person : newpersonRecords){
            person.Health_Status__c = 'Green'; //changing health status to green for all new records which is getting inserted
            person.Token__c = CTPersonController.getToken(person.Mobile__c);//assigning new token to new records
        }
        
    }
    public static void beforeUpdate(List<Person__c> newRecords , Map<id,Person__c> mapOfExistingRecord){
        for(Person__c person : newRecords){
            if(person.Health_Status__c != mapOfExistingRecord.get(person.id).Health_Status__c){
                person.Status_Update_Date__c = System.today();//if new health status not equals old health status then change the update date
            }
        }
    }
    public static void AfterUpdate(List<Person__c> newRecords , Map<id,Person__c> mapOfExistingRecord){
        set<Id> StatusChange = new set<Id>();
        set<Id> RedStatus = new set<Id>();
        for(Person__c person : newRecords){
            if(person.Health_Status__c != mapOfExistingRecord.get(person.id).Health_Status__c){
                StatusChange.add(person.Id);
            }
            if(person.Health_Status__c == 'Red' && mapOfExistingRecord.get(person.id).Health_Status__c != 'Red'){
                RedStatus.add(person.Id);
            }
        }
        set<Id> Alreadyprocessed = new set<Id>();
        Alreadyprocessed.addAll(RedStatus);

        set<Id> orangeStatus = new set<Id>();
        set<Id> yellowStatus = new set<Id>();
        
        List<person__c> personToUpdate = new List<person__c>();

        orangeStatus.addAll(CTPersonController.getCohabitant(RedStatus , Alreadyprocessed));//adding cohabitants
        set<Id> PrimaryContacts = CTPersonController.getPrimaryContacts(RedStatus , Alreadyprocessed);
        orangeStatus.addAll(PrimaryContacts);//adding primarycontact
        yellowStatus.addAll(CTPersonController.getneighbours(RedStatus , Alreadyprocessed));//adding neighbour
        
        yellowStatus.addAll(CTPersonController.getSecondaryContact(PrimaryContacts , Alreadyprocessed));//adding Secondarycontact

        for(Id pid : orangeStatus){
            personToUpdate.add(new person__c(id=pid, Health_Status__c='Orange'));
        }
        for(Id pid : yellowStatus){
            personToUpdate.add(new person__c(id=pid, Health_Status__c='yellow'));
        }
        if(personToUpdate.size()>0){
            update personToUpdate;
        }

        List<Location_Tracing__c> locationtraces = CTLocationTracingContoller.getLocationByPersonIds(StatusChange);
        
        if(locationtraces!=Null && locationtraces.size()>0){
            set<id> locids = new set<id>();
            for(Location_Tracing__c loc : locationtraces){
                locids.add(loc.Location__c);
            }
            CTLocationController.updateRedScore(locids);
        }
        }
       
}
