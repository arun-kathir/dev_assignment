global class scheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchApexExample b = new BatchApexExample(); 
      Database.executeBatch(b);
   }
}