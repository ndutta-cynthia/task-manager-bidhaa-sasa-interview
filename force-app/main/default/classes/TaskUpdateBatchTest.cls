@IsTest
private class TaskUpdateBatchTest {
    @TestSetup
    static void makeData(){
        List<Task__c> tasks = new List<Task__c>();
        
        // Create overdue incomplete task
        tasks.add(new Task__c(
            Name = 'Overdue Task',
            Due_Date__c = Date.today().addDays(-1),
            Completed__c = false
        ));
        
        // Create future incomplete task
        tasks.add(new Task__c(
            Name = 'Future Task',
            Due_Date__c = Date.today().addDays(1),
            Completed__c = false
        ));
        
        insert tasks;
    }
    
    @IsTest
    static void testBatch() {
        Test.startTest();
        TaskUpdateBatch batch = new TaskUpdateBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify results
        List<Task__c> updatedTasks = [SELECT Id, Completed__c FROM Task__c];
        System.assertEquals(2, updatedTasks.size(), 'Should have 2 tasks');
        
        for(Task__c task : updatedTasks) {
            if(task.Name == 'Overdue Task') {
                System.assert(task.Completed__c, 'Overdue task should be marked complete');
            } else {
                System.assert(!task.Completed__c, 'Future task should remain incomplete');
            }
        }
    }
}