public class futureSample {
    @future
    public static void createTask(list<id> listRecIds){
        list<Task> listTask = new list<Task>();
        for(id recId : listRecIds){
            Task tsk = new Task(WhatId = recId);
            tsk.Subject = 'Created from Future';
            tsk.ActivityDate = system.today() + 3;
            //tsk.CallType = 'Phone';
            tsk.Status= 'Not Started';
            listTask.add(tsk);
        }
        insert listTask;
    }
}