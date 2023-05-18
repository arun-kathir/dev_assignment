/**
 * Class AccountHandler
 *
 * Trigger Handler for the Account SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 * Adding one more line to test Git
 */
public with sharing class AccountHandler implements ITrigger{	
	
	map<Id,list<Opportunity>> mapAccountIdToOpportunities = new map<Id,list<Opportunity>>();
	list<Opportunity> listOppty = new list<Opportunity>();
	list<Opportunity> listUpdateOppty = new list<Opportunity>();
    list<id> listAcntId = new list<id>();
    list<Account> listAccs = new list<Account>();
	public AccountHandler(){
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
		mapAccountIdToOpportunities = AccountUtility.getMapAccountIdToOpportunities(trigger.new);
		system.debug('mapAccountIdToOpportunities: ' + mapAccountIdToOpportunities);
	}
		
	public void beforeInsert(SObject so){
	}
	
	public void beforeUpdate(SObject oldSo, SObject so){
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
        listAcntId.add(so.id);
        listAccs.add((Account)so);
	}
	
	public void afterUpdate(SObject oldSo, SObject so){
		Account updatedAcnt = (Account)so;
		listOppty = mapAccountIdToOpportunities.get(updatedAcnt.id);
		system.debug('listOppty: ' + listOppty);
		for(Opportunity tempOppty : listOppty){
			tempOppty.Inactive__c = true;
			listUpdateOppty.add(tempOppty);
		}
	}
	
	public void afterDelete(SObject so){
	}
	
	/**
	 * andFinally
	 *
	 * This method is called once all records have been processed by the trigger. Use this 
	 * method to accomplish any final operations such as creation or updates of other records.
	 * For eg. put all DML statements inside this method
	 */
	public void andFinally(){
		if(trigger.isAfter){
			if(trigger.isUpdate){
				update listUpdateOppty;
			}
            if(trigger.isInsert){
                if(!listAcntId.isEmpty()){
                	futureSample.createTask(listAcntId);
                }
                if(!listAccs.isEmpty()){
                	ID jobID = System.enqueueJob(new queueableSample(listAccs));
                }
            }
		}
	}
}