public with sharing class CTPersonController {
   public static string getToken(String mobileNo){
    Blob Value = Blob.valueof(mobileNo); //took reference from MD5 Hashing in Apex..Ctrypto class
    Blob hash = Crypto.generateDigest('MD5',value);//took reference from MD5 Hashing in Apex..Ctrypto class
    //get the string value of hash blob
    return EncodingUtil.base64Encode(hash); //took reference from EncodingUtil Methods Apex *base64Encode(inputBlob)*
   }
   // getRecentHealthChanges method t get 100 contacts with recent health status change 
   public static List<Person__c> getRecentHealthChanges(){
      List<Person__c> Per = [Select Name , Health_Status__c ,Mobile__c, Status_Update_Date__c,Token__c from Person__c ORDER BY Status_Update_Date__c Desc NULLS LAST LIMIT 100];
      return per;
   }

   Public Static List <Person__c> searchPeople(String searchTerm){
      searchTerm = searchTerm + '%';

      List <Person__c> perRecord = [Select  Name , Health_Status__c ,Mobile__c, Status_Update_Date__c,Token__c From 
      Person__c Where Name  Like: searchTerm  OR Mobile__c Like: searchTerm OR Token__c Like: searchTerm  
      ORDER BY Status_Update_Date__c Desc NULLS LAST];
      return perRecord;
   }

   Public Static Person__c searchPeopleById(String PersonId){
     List<Person__c> personRecordId = [Select Id, Name , Health_Status__c ,Mobile__c, Status_Update_Date__c,Token__c From Person__c Where Id =: PersonId ];
     if(personRecordId!=Null && personRecordId.size()>0){
     return personRecordId[0];
   }
   return null;
   
}
   public static Map<String,Integer> getHealthStatusCount(){
      Map<String,Integer> mapOfHealthStatus = new Map<String,Integer>();
      for(AggregateResult trace : [Select Count(Id) total ,Health_Status__c from Person__c Group by  Health_Status__c]) {
        String HealthStatus = String.valueof(trace.get('Health_Status__c'));
        Integer count = Integer.valueof(trace.get('total'));
         mapOfHealthStatus.put(HealthStatus,count);
      }
      return mapOfHealthStatus;
   }

   public static set<Id> getCohabitant(Set<Id> personIds , Set<Id> AlreadyProcessed){
      List<String> healthStatus = new List<String>{'Green','Yellow'};
      List<People_Tracing__c> cohabitantsResult = [Select Person_1__c,Person_2__c from People_Tracing__c 
                                             where (Person_1__c IN : personIds OR Person_2__c IN : personIds)
                                             AND Contact_Type__c = 'Cohabitant'
                                             AND (Person_1__r.Health_Status__c IN : healthStatus 
                                             OR Person_2__r.Health_Status__c IN : healthStatus)];
      set<Id> Cohabitant = new set<Id>();
      for(People_Tracing__c Result : cohabitantsResult) {
         if(!AlreadyProcessed.contains(Result.Person_1__c)){
            Cohabitant.add(Result.Person_1__c);
            AlreadyProcessed.add(Result.Person_1__c);
         }
         if(!AlreadyProcessed.contains(Result.Person_2__c)){
            Cohabitant.add(Result.Person_2__c);
            AlreadyProcessed.add(Result.Person_2__c);
         }
         
       }  
       return Cohabitant;                                  
   }

   public static set<Id> getneighbours(Set<Id> personIds , Set<Id> AlreadyProcessed){
      
      List<People_Tracing__c> neighboursResult = [Select Person_1__c,Person_2__c from People_Tracing__c 
                                             where (Person_1__c IN : personIds OR Person_2__c IN : personIds)
                                             AND Contact_Type__c = 'Neighbour'
                                             AND (Person_1__r.Health_Status__c = 'Green' 
                                             OR Person_2__r.Health_Status__c = 'Green')];
      set<Id>   Neighbour = new set<Id>();
      for(People_Tracing__c Result : neighboursResult) {
         if(!AlreadyProcessed.contains(Result.Person_1__c)){
            Neighbour.add(Result.Person_1__c);
            AlreadyProcessed.add(Result.Person_1__c);
         }
         if(!AlreadyProcessed.contains(Result.Person_2__c)){
            Neighbour.add(Result.Person_2__c);
            AlreadyProcessed.add(Result.Person_2__c);
         }
         
       }  
       return Neighbour;                                  
   }

   public static set<Id> getPrimaryContacts(Set<Id> personIds , Set<Id> AlreadyProcessed){
      List<String> healthStatus = new List<String>{'Green','Yellow'};
      List<People_Tracing__c> PrimaryContactResult = [Select Person_1__c,Person_2__c from People_Tracing__c 
                                             where (Person_1__c IN : personIds OR Person_2__c IN : personIds)
                                             AND Contact_Type__c = 'Other'
                                             AND (Person_1__r.Health_Status__c IN : healthStatus 
                                             OR Person_2__r.Health_Status__cCT IN : healthStatus)
                                             AND Contact_Date__c = LAST_N_DAYS:10];
      set<Id>   PrimaryContacts = new set<Id>();
      for(People_Tracing__c Result : PrimaryContactResult) {
         if(!AlreadyProcessed.contains(Result.Person_1__c)){
            PrimaryContacts.add(Result.Person_1__c);
            AlreadyProcessed.add(Result.Person_1__c);
         }
         if(!AlreadyProcessed.contains(Result.Person_2__c)){
            PrimaryContacts.add(Result.Person_2__c);
            AlreadyProcessed.add(Result.Person_2__c);
         }
         
       }  
       return PrimaryContacts;                                  
   }
   public static set<Id> getSecondaryContact(Set<Id> primaryConIds , Set<Id> AlreadyProcessed){
      
      List<People_Tracing__c> SecondaryContactResult = [Select Person_1__c,Person_2__c from People_Tracing__c 
                                             where (Person_1__c IN : primaryConIds OR Person_2__c IN : primaryConIds)
                                             AND Contact_Type__c = 'Other'
                                             AND Contact_Date__c = LAST_N_DAYS:10
                                             AND (Person_1__r.Health_Status__c = 'Green' 
                                             OR Person_2__r.Health_Status__c = 'Green')];
      set<Id> SecondaryContact = new set<Id>();
      for(People_Tracing__c Result : SecondaryContactResult) {
         if(!AlreadyProcessed.contains(Result.Person_1__c)){
            SecondaryContact.add(Result.Person_1__c);
            AlreadyProcessed.add(Result.Person_1__c);
         }
         if(!AlreadyProcessed.contains(Result.Person_2__c)){
            SecondaryContact.add(Result.Person_2__c);
            AlreadyProcessed.add(Result.Person_2__c);
         }
         
       }  
       return SecondaryContact;                                  
   }


}