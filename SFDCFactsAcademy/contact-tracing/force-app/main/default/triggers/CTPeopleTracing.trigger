trigger CTPeopleTracing on People_Tracing__c (before insert , After insert) {
     switch on trigger.OperationType{
        when BEFORE_INSERT{
            CTPeopleTracingTriggerHandler.beforeInsert(trigger.new);
        }
     }
}