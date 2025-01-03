@IsTest
private class TaskControllerTest {
    @TestSetup
    static void makeData(){
        Task__c task = new Task__c(
            Name = 'Test Task',
            Due_Date__c = Date.today(),
            Completed__c = false
        );
        insert task;
    }
    
    @IsTest
    static void testGetTasks() {
        Test.startTest();
        List<Task__c> tasks = TaskController.getTasks();
        Test.stopTest();
        
        System.assertEquals(1, tasks.size());
        System.assertEquals('Test Task', tasks[0].Name);
        System.assertEquals(false, tasks[0].Completed__c);
    }
    
    @IsTest
    static void testUpdateTaskStatus() {
        Task__c task = [SELECT Id FROM Task__c LIMIT 1];
        
        Test.startTest();
        TaskController.updateTaskStatus(task.Id);
        Test.stopTest();
        
        task = [SELECT Completed__c FROM Task__c WHERE Id = :task.Id];
        System.assert(task.Completed__c);
    }
}