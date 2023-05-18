trigger OpptyTrigger on Opportunity (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(OpportunityHandler.class);
}