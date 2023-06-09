Public class ContactTable{ 
    public String size { get; set; } 
    //This is Our collection of the class/wrapper objects WrapperContactWrapper 
    public List<WrapperContactWrapper> wrapperlist; 
    public Integer noOfRecords{get; set;} 
    // Create a new Map to verify whether the contact is already added in the Map 
    Map <id,Contact> SelectedcontactMap = new Map <id,Contact>(); 
    public boolean display{get;set;} 
    public list<Contact> selectedList {get;set;} 
    // instantiate the StandardSetController from a query locator 
    public ApexPages.StandardSetController Setcon{ 
        get{
            if(Setcon == Null){ 
                Setcon = new ApexPages.StandardSetController(Database.getQueryLocator([Select Name,Accountid,Email,MobilePhone,LeadSource from Contact])); 
                // sets the number of records in each page set 
                setCon.setpagesize(10); 
                noOfRecords = setCon.getResultSize(); 
            }
            return Setcon; 
        } 
        set; 
    } 
    //Returns a list of wrapper objects for the sObjects in the current page set 
    public List<WrapperContactWrapper> getContact(){ 
        getSelectedContact(); 
        // Initilaize the list to add the selected contact 
        wrapperlist = new List <WrapperContactWrapper>(); 
        for(Contact cc : (List<contact>)Setcon.getRecords()){ 
            if( SelectedcontactMap .ContainsKey(cc.id)){ 
                wrapperlist.add (new WrapperContactWrapper(cc,true)); 
            } 
            else{ 
                wrapperlist.add(new WrapperContactWrapper(cc,false)); 
            }
        } 
        return wrapperlist;
    } 
    public void getSelectedContact(){ 
        if(wrapperlist!=null){ 
            for(WrapperContactWrapper wr:wrapperlist){ 
                if(wr.bool == true){ 
                    SelectedcontactMap.put(wr.con.id,wr.con); 
                    // Add the selected contact id in to the SelectedcontactMap. 
                } 
                else{ 
                    SelectedcontactMap.remove(wr.con.id); 
                    // If you uncheck the contact, remove it from the selectedcontactMap 
                } 
            } 
        } 
    }
    public void clickMe(){ 
        display = true; 
        getSelectedContact(); 
        selectedList = SelectedcontactMap.values(); 
    } 
    public integer pageNumber{ get{return Setcon.getPageNumber();} set;}
    Public class WrapperContactWrapper{ 
        Public Contact con{get;set;} 
        Public boolean bool{get;set;} 
        public WrapperContactWrapper(Contact c,boolean bool){ 
            this.con = c; 
            this.bool = bool; 
        } 
    } 
}