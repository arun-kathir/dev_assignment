public with sharing class Sample_Picklist {
    
    public Sample_Picklist(ApexPages.StandardController controller) {
    	
    }
    public List<SelectOption> getLocation()
	{
	   List<SelectOption> options = new List<SelectOption>();
	   Schema.DescribeFieldResult fieldResult = Interviewer__c.Interviewer_Location__c.getDescribe();
	   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	   for(Schema.PicklistEntry f : ple){
		  if(f.getValue() == 'Mum'){
		  	options.add(new SelectOption('Mumbai', 'Mumbai'));
		  }
		  else{
	      	options.add(new SelectOption(f.getLabel(), f.getValue()));
		  }
	   }       
	   return options;
	}
}