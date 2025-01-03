@RestResource(urlMapping='/v1/tasks/*')
global with sharing class TaskRESTService {
    @HttpGet
    global static List<TaskWrapper> getTasks() {
        List<Task__c> tasks = [
            SELECT Id, Name, Due_Date__c, Completed__c 
            FROM Task__c 
            ORDER BY Due_Date__c ASC
        ];
        
        List<TaskWrapper> wrappers = new List<TaskWrapper>();
        for(Task__c task : tasks) {
            wrappers.add(new TaskWrapper(task));
        }
        return wrappers;
    }
    
    global class TaskWrapper {
        public String name;
        public Date dueDate;
        public Boolean completed;
        
        public TaskWrapper(Task__c task) {
            this.name = task.Name;
            this.dueDate = task.Due_Date__c;
            this.completed = task.Completed__c;
        }
    }
}