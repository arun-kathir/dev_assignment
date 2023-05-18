public with sharing class SampleRelListButtonPageCtrlExt {
	Id empId = system.currentPageReference().getparameters().get('id');
	public list<Company__c> companyList {get; set;}
	public list<companyWrap> companyWrapList {get; set;}
	public list<Company__c> selectedCompanies {get; set;}
    public SampleRelListButtonPageCtrlExt(ApexPages.StandardSetController ctrl){
    	system.debug('empId :' + empId);
    	decimal countryCode;
    	set<id> setCompanyId = new set<id>();
    	for(Employee__c emp : [select Country_code__c, Name, Employee_Id__c, (select Company__c from Emp_Comp_Associations__r) from Employee__c where id =: empId]){
    		system.debug('emp :' + emp);
    		countryCode = emp.Country_code__c;
    		for(Emp_Comp_Association__c assoc : emp.Emp_Comp_Associations__r){
    			setCompanyId.add(assoc.Company__c);
    		}
    	}
    	if(companyWrapList == null){
    		companyWrapList = new list<companyWrap>();
	    	for(Company__c comp : [select Company_code__c, Country_code__c, Name from Company__c where Country_code__c =: countryCode and id NOT IN: setCompanyId]){
	    		companyWrapList.add(new companyWrap(comp));
	    	}
    	}
    }
    public PageReference createCompAssociations(){
    	selectedCompanies = new list<Company__c>();
    	list<Emp_Comp_Association__c> listInsertAssociation = new list<Emp_Comp_Association__c>();
    	boolean isSuccess = false;
        for(companyWrap wrapCompObj : companyWrapList) {
            if(wrapCompObj.selected == true) {
                selectedCompanies.add(wrapCompObj.company);
            }
        }
        for(Company__c selectedComp : selectedCompanies){
        	Emp_Comp_Association__c assc = new Emp_Comp_Association__c(Company__c = selectedComp.id, Employee__c = empId, Employee_Company__c = selectedComp.id + '_' + empId);
        	listInsertAssociation.add(assc);
        }
        if(!listInsertAssociation.isEmpty()){
        	Database.SaveResult[] srList = Database.insert(listInsertAssociation, true);
			for (Database.SaveResult sr : srList) {
			    if (sr.isSuccess()) {
			        System.debug('Successfully inserted Associations');
			        isSuccess = true;
			    }
			}
        }
        if(isSuccess){
        	PageReference pageRef = new PageReference('/' + empId);
        	return pageRef;
        }
        else{
        	return null;
        }
    }
    public PageReference deleteCompAssociations(){
    	selectedCompanies = new list<Company__c>();
    	list<Emp_Comp_Association__c> listDeleteAssociation = new list<Emp_Comp_Association__c>();
    	boolean isSuccess = false;
    	set<id> setCompanyId = new set<id>();
        for(companyWrap wrapCompObj : companyWrapList) {
            if(wrapCompObj.selected == true) {
                selectedCompanies.add(wrapCompObj.company);
                setCompanyId.add(wrapCompObj.company.id);
            }
        }
        for(Emp_Comp_Association__c assoc : [select id from Emp_Comp_Association__c where Company__c IN: setCompanyId and Employee__c =: empId]){
        	listDeleteAssociation.add(assoc);
        }
        if(!listDeleteAssociation.isEmpty()){
        	Database.DeleteResult[] drList = Database.delete(listDeleteAssociation, true);
			for (Database.DeleteResult dr : drList) {
			    if (dr.isSuccess()) {
			        System.debug('Successfully deleted Associations');
			        isSuccess = true;
			    }
			}
        }
        if(isSuccess){
        	PageReference pageRef = new PageReference('/' + empId);
        	return pageRef;
        }
        else{
        	return null;
        }
    }
    public class companyWrap {
        public Company__c company {get; set;}
        public Boolean selected {get; set;}
 
        public companyWrap(Company__c comp) {
            company = comp;
            selected = false;
        }
    }
}