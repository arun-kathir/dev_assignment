public with sharing class ApexParamExPageCtrlExtn {
	public list<contact> contactList{get;set;}
	public string inputValue{get;set;}
	public string conLevel{get;set;}
	public Contact contactObj{get;set;}
	Account a;
	public ApexParamExPageCtrlExtn(ApexPages.standardcontroller controller){
		a = (Account)controller.getRecord();
		contactList = [select id, firstName, Salutation, Level__c from contact where Accountid =: a.id];
	}
	public List<SelectOption> getLevels()
	{
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Contact.Level__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry f : ple)
		{
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}       
		return options;
	}
	public void saveContact(){
		system.debug('contactName: ' + contactObj);
		contactObj.Level__c = conLevel;
		update contactObj;
	}
}