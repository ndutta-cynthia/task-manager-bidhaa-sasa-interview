global class TaskUpdateScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        TaskUpdateBatch batch = new TaskUpdateBatch();
        Database.executeBatch(batch);
    }
}