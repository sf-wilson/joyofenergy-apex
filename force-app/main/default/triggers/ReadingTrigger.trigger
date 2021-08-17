trigger ReadingTrigger on Reading__c (after insert, after update, after delete, after undelete) {
    // publish platform event
    if (Trigger.isAfter) {
        Database.SaveResult sr = EventBus.publish(new CustomEvent__e(
            sObject__c = 'Reading__c',
            Message__c = 'refreshView'
        ));
        
        if(!sr.isSuccess()) {
            String errors = '';
            for(Database.Error e : sr.getErrors()) 
                errors += e.statusCode + ': ' + e.message + '\n';

            System.debug('logs=> ' + errors);
        }
    }
}