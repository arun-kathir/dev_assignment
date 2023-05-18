public class scheduleQueueableSample implements Queueable{
    public scheduleQueueableSample(){
    }
    public void execute(QueueableContext context) {
        list<Task> listTask = new list<Task>();
        for(Opportunity oppty : [select id, OwnerId from Opportunity where isClosed = false and CloseDate < today]){
            Task tsk = new Task(WhatId = oppty.Id);
            tsk.Subject = 'Created from Scheduled Queueable';
            tsk.ActivityDate = system.today();
            //tsk.CallType = 'Phone';
            tsk.Description = 'Please close this Opportunity ASAP';
            tsk.Status= 'Not Started';
            tsk.OwnerId = oppty.OwnerId;
            listTask.add(tsk);
        }
        insert listTask;
    }
}