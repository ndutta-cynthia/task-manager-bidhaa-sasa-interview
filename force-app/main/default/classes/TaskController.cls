@RestResource(urlMapping='/Tasks/*')
global without sharing class TaskController {
    
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
    global static String getTasksREST() {
        RestResponse res = RestContext.response;
        try {
            // Get current user info for debugging
            User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
            
            // Query tasks without security enforced
            List<Task__c> tasks = [
                SELECT Id, Name, Due_Date__c, Completed__c 
                FROM Task__c 
                ORDER BY Due_Date__c ASC
            ];
            
            // Create response map
            Map<String, Object> responseMap = new Map<String, Object>{
                'userInfo' => currentUser,
                'taskCount' => tasks.size(),
                'tasks' => tasks,
                'userPermissions' => Schema.sObjectType.Task__c.isAccessible(),
                'fieldPermissions' => new Map<String,Boolean>{
                    'Name' => Schema.sObjectType.Task__c.fields.Name.isAccessible(),
                    'Due_Date__c' => Schema.sObjectType.Task__c.fields.Due_Date__c.isAccessible(),
                    'Completed__c' => Schema.sObjectType.Task__c.fields.Completed__c.isAccessible()
                }
            };
            
            // Convert to JSON string
            return JSON.serialize(responseMap);
            
        } catch(Exception e) {
            res.statusCode = 500;
            return JSON.serialize(new Map<String, Object>{
                'error' => e.getMessage(),
                'type' => e.getTypeName(),
                'userPermissions' => Schema.sObjectType.Task__c.isAccessible()
            });
        }
    }
    
    @HttpPost
    global static Task__c createTaskREST() {
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        // Add debug headers
        res.addHeader('Content-Type', 'application/json');
        System.debug('Request URI: ' + req.requestURI);
        System.debug('Request Method: ' + req.httpMethod);
        
        String requestBody = req.requestBody.toString();
        System.debug('Request Body: ' + requestBody);
        
        try {
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
            Task__c newTask = new Task__c(
                Name = (String)params.get('name'),
                Due_Date__c = Date.valueOf((String)params.get('dueDate')),
                Completed__c = (Boolean)params.get('completed')
            );
            
            insert newTask;
            return newTask;
        } catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw new AuraHandledException('Error creating task: ' + e.getMessage());
        }
    }
}