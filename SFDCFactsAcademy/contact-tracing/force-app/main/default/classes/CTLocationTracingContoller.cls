public with sharing class CTLocationTracingContoller {
    //get last 30 days visitors
    public static List<Location_Tracing__c> getVisitors(String LocationId){
        List<Location_Tracing__c> LocTrace = [Select Id,Location__c,Person__c,Visit_Date__c , 
        Person__r.Token__c, Person__r.Health_Status__c
        from Location_Tracing__c
        where  Id =: LocationId
        ORDER BY Visit_Date__c DESC];
        Return LocTrace; 
          }
    //get all location ids for visitors
    public static List<Location_Tracing__c> getLocationByPersonIds(Set<Id> personIds){
        List<Location_Tracing__c> LocTraceByPersonId = [Select Id,Location__c,Person__c
        from Location_Tracing__c
        where Person__c IN : personIds AND Visit_Date__c= Last_N_DAYS:10];
        Return LocTraceByPersonId; 
          }   
    //get all visitors id for location 
    public static List<Location_Tracing__c> getLocationByLocationIds(Set<Id> locationIds){
            List<Location_Tracing__c> LocTraceByLocationId = [Select Id,Location__c,Person__c
            from Location_Tracing__c
            where Location__c IN:locationIds 
            AND Person__r.Health_Status__c = 'Green' 
            AND Visit_Date__c = Last_N_DAYS:10];
            Return LocTraceByLocationId; 
              } 
              
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        //store unique location ids
        set<id> locationIds = new set<id>();
        //store unique person ids
        set<id> personIds = new set<id>();
        for(Location_Tracing__c trace : newLocationTraces){
            locationIds.add(trace.Location__c) ;
            personIds.add(trace.Person__c);
        }
        //map of location id and set of person id
        Map<Id,Set<Id>> mapOfExistingRecords = new Map<Id,Set<Id>>();
        //query existing location tracing records
        List<Location_Tracing__c> existingRecords = [Select Id,Location__c,Person__c
        from Location_Tracing__c
        where Location__c IN:locationIds 
        AND Person__c IN:personIds];
        //list of duplicaate records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

        if(existingRecords!=Null && existingRecords.size()>0){
            for(Location_Tracing__c trace :existingRecords){
        //check if map already have location Id key
        if(!mapOfExistingRecords.containsKey(trace.Location__c)){
            //map does not have this key
            //add this new item in map using location id as key
            //and blank set <id> as value
            mapOfExistingRecords.put(trace.Location__c,new Set<id>());
        }
        //add person id to map set
            mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
        
        }
        //loop over new location tracing record
        for(Location_Tracing__c trace : newLocationTraces){
            //first check for loc id
            //if item found in map, then check for person in set
            if(mapOfExistingRecords.containsKey(trace.Location__c)
            && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                duplicates.add(trace);
            }
        }
    }
    return duplicates;
   }
}