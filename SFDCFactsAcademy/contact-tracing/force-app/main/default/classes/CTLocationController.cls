public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges(){
        List<Location__c> Loc = [Select Address__c,Name,Pincode__c,Red_Score__c,Status__c,Status_Update_Date__c
        From Location__c ORDER BY Status_Update_Date__c DESC LIMIT 100];
        return Loc;
    }

    public static List<Location__c> searchLocations(String searchTerm){
        searchTerm = searchTerm + '%';  
        List<Location__c> Locsearch = [Select Address__c , Name , Pincode__c , Red_Score__c, Status__c, Status_Update_Date__c
                                       From Location__c 
                                       where Address__c Like : searchTerm
                                       OR Name Like : searchTerm
                                       OR Pincode__c Like : searchTerm
                                       ORDER BY Status_Update_Date__c DESC NULLS LAST];
        return Locsearch;
    }

    public static Location__c getLocationById(String locationId){
         
        List<Location__c> LocsearchbyId = [Select Id, Address__c , Name , Pincode__c , Red_Score__c,Status__c, Status_Update_Date__c
        From Location__c Where Id =: locationId ];
        if(LocsearchbyId!=Null && LocsearchbyId.size()>0){
            return LocsearchbyId[0];
        }
        return null;
    }
    Public Static Map<String,Integer> getStatusCount(){
        Map<String,Integer> mapOfHealthStatus = new Map<String,Integer>();
        for(AggregateResult trace : [select count(Id) total,Status__c From Location__c group By Status__c]){
            String HealthStatus = String.valueof(trace.get('Status__c'));
            Integer count = Integer.valueof(trace.get('total'));
            mapOfHealthStatus.put(HealthStatus,count);
            return mapOfHealthStatus;
        }
    }

    public static void updateRedScore(Set<id> locationids){
        List<Location__c> locationToUpdate = new List<Location__c>();
        AggregateResult[] redPeoplePerLocation = [Select Location__c , Count(id) total from Location_Tracing__c
                                                 where Person__r.Health_Status__c = 'Red'
                                                 AND Visit_Date__c = LAST_N_DAYS:10
                                                 AND Location__c IN: locationids
                                                 GROUP BY Location__c];
         for(AggregateResult ar : redPeoplePerLocation){
            String locationId = String.Valueof(ar.get('Location__c'));
            integer redScore = integer.valueof(ar.get('total'));
            String locationStatus = getStatus(redScore);
            locationToUpdate.add(new Location__c(id=locationId , Red_Score__c = redScore , Status__c = locationStatus));
         }
         if(locationToUpdate != Null && locationToUpdate.size()>0){
            update locationToUpdate;
         }                                        
    }
    public static string getStatus(integer redscore){
        if(redscore == 0){
            return 'Green';
        }
        else if(redscore <= 5){
            return 'Yellow';
        }
        else if(redscore <= 10){
            return 'Orange';
        }
        else{
            return 'Red';
        }
    }
    
}