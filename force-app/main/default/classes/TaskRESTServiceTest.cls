@IsTest
private class TaskRESTServiceTest {
    @TestSetup
    static void makeData(){
        Task__c task = new Task__c(
            Name = 'REST Test Task',
            Due_Date__c = Date.today(),
            Completed__c = false
        );
        insert task;
    }
    
    @IsTest
    static void testGetTasks() {
        Test.startTest();
        List<TaskRESTService.TaskWrapper> tasks = TaskRESTService.getTasks();
        Test.stopTest();
        
        System.assertEquals(1, tasks.size());
        System.assertEquals('REST Test Task', tasks[0].name);
        System.assertEquals(false, tasks[0].completed);
    }
}