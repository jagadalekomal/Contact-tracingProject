trigger CTLocationTracing on Location_Tracing__c (before insert , after insert) {
     switch on trigger.operationtype {
        when BEFORE_INSERT {
            CTLocationTracingHandler.beforeInsert(trigger.new);
        }
        
     }
}