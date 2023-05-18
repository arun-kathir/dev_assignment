public class queueableSample implements Queueable {
    list<id> listRecIds= new list<id>();
    public queueableSample(list<Account> listAccs){
        for(Account acc : listAccs){
            listRecIds.add(acc.id);
        }
    }
    public void execute(QueueableContext context) {
        list<Task> listTask = new list<Task>();
        for(id recId : listRecIds){
            Task tsk = new Task(WhatId = recId);
            tsk.Subject = 'Created from Queueable';
            tsk.ActivityDate = system.today() + 3;
            //tsk.CallType = 'Phone';
            tsk.Status= 'Not Started';
            listTask.add(tsk);
        }
        insert listTask;
    }
}