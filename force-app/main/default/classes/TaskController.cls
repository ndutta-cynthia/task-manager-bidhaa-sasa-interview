@RestResource(urlMapping='/Tasks/*')
global with sharing class TaskController {
    
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getTasks() {
        try {
            return [SELECT Id, Name, Due_Date__c, Completed__c 
                    FROM Task__c 
                    ORDER BY Due_Date__c ASC];
        } catch(Exception e) {
            throw new AuraHandledException('Error retrieving tasks: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updateTaskStatus(Id taskId, Boolean completed) {
        try {
            Task__c task = new Task__c(Id = taskId, Completed__c = completed);
            update task;
        } catch(Exception e) {
            throw new AuraHandledException('Error updating task: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void deleteTask(Id taskId) {
        try {
            Task__c task = [SELECT Id FROM Task__c WHERE Id = :taskId WITH SECURITY_ENFORCED];
            delete task;
        } catch(Exception e) {
            throw new AuraHandledException('Error deleting task: ' + e.getMessage());
        }
    }
    
    @HttpGet
    global static List<Task__c> getTasksREST() {
        try {
            return [SELECT Id, Name, Due_Date__c, Completed__c 
                    FROM Task__c 
                    ORDER BY Due_Date__c ASC];
        } catch(Exception e) {
            throw new AuraHandledException('Error retrieving tasks: ' + e.getMessage());
        }
    }
}