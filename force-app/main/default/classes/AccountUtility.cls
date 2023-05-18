public with sharing class AccountUtility {
	
	public static list<id> listInactiveAccountId = new list<id>();
	public static map<Id,list<Opportunity>> mapAccountIdToOpportunities = new map<Id,list<Opportunity>>();
	
	public static map<Id,list<Opportunity>> getMapAccountIdToOpportunities(list<Account> listUpdatedAccount){
		for(Account tempAccount : listUpdatedAccount){
			if(tempAccount.Inactive__c == true){
				listInactiveAccountId.add(tempAccount.id);
			}
		}
		if(listInactiveAccountId.size() > 0){
			for(Account listAccount : [select id, (select id, Inactive__c from Opportunities) from Account where id IN :listInactiveAccountId]){
				mapAccountIdToOpportunities.put(listAccount.id,listAccount.opportunities);
			}
			return mapAccountIdToOpportunities;
		}
		else{
			return null;
		}
	}

}