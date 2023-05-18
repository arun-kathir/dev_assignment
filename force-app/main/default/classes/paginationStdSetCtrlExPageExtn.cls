public with sharing class paginationStdSetCtrlExPageExtn {
    public integer size{get;set;} 
    public integer noOfRecords{get; set;} 
    public list<SelectOption> paginationSizeOptions{get;set;}
         
    public paginationStdSetCtrlExPageExtn(){
        size=10;
        paginationSizeOptions = new list<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
    }
     
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [select id,Name,AccountId,Account.name,Amount,StageName,CloseDate,LastModifiedDate from Opportunity]));
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
     
    //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
    public list<Opportunity> getOpportunities() {
         return (list<Opportunity>) setCon.getRecords();
    }
}