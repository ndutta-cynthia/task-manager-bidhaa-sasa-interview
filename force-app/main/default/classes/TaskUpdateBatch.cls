global class TaskUpdateBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id FROM Task__c ' +
            'WHERE Due_Date__c < TODAY AND Completed__c = false'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Task__c> scope) {
        for(Task__c task : scope) {
            task.Completed__c = true;
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext bc) {
        // Optional: Add logging or notifications here
    }
}