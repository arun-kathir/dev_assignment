global class scheduledQueueable implements Schedulable {
   global void execute(SchedulableContext sc) {
        ID jobID = System.enqueueJob(new scheduleQueueableSample());
        System.debug('jobID'+jobID);
   }
}