trigger CTLocation on Location__c (before insert , before update , after update) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
            CTLocationTriggerHandler.beforeInsert(trigger.new);
        }
        when before_update{
            CTLocationTriggerHandler.beforeupdate(trigger.new , trigger.oldmap);
        }
        when after_update{
            CTLocationTriggerHandler.afterUpdate(trigger.new , trigger.oldmap);
        }
    }

}