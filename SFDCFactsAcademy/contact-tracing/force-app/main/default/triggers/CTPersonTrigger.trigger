trigger CTPersonTrigger on Person__c (before insert,before update,before delete,after insert,After update,After delete ,After Undelete) {
   switch on trigger.OperationType{
    when before_Insert {
        CTPersonTriggerHandler.beforeInsertHandler(trigger.new);//passing new list of records
        }
    when before_update{
        CTPersonTriggerHandler.beforeUpdate(trigger.new,trigger.oldmap);//passing new list of records and old records map
    }
    when after_update{
        CTPersonTriggerHandler.AfterUpdate(trigger.new,trigger.oldmap);
    }
    }
    
   }
   

