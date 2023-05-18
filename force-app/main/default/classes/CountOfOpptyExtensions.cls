public with sharing class CountOfOpptyExtensions {
	private final Account acct;
	
	public CountOfOpptyExtensions(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }

    public integer getCountOfOpenOppty() {
        return [select count() from opportunity where AccountId = :acct.id and StageName NOT IN ('Closed won','Closed Lost')];
    }

    public integer getCountOfClosedOppty() {
        return [select count() from opportunity where AccountId = :acct.id and StageName IN ('Closed won','Closed Lost')];
    }
}