/**
 * Class OpportunityHandler
 *
 * Trigger Handler for the Opportunity SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class OpportunityHandler implements ITrigger{   

    public OpportunityHandler(){
    }

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore(){
    }
    
    public void bulkAfter(){
    }
        
    public void beforeInsert(SObject so){
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        Opportunity oppty = (Opportunity)so;
        system.debug(oppty.Account.NumberofLocations__c);
        system.debug([SELECT ListPrice,Name,OpportunityId,ProductCode,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItem where OpportunityId =: oppty.id and Quantity =: oppty.Account.NumberofLocations__c]);
    }
    
    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so){   
    }
    
    public void afterInsert(SObject so){
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
    }
    
    public void afterDelete(SObject so){
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally(){
    }
}