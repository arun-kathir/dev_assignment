public class listofcontactsextension {
    Account acc;
    //public string inputCases{get;set;}
    public list<wrapCase> wrapAcc{get; set;}
    public list<Contact> selectedCons{get;set;}
    //public string msg{get;set;}
    public string clickedContactName{get; set;}
    ApexPages.standardcontroller ac;
    set<string> setContNames = new set<string>();
    list<string> caseNameList = new list<string>();
    //public list<Test_Case__c> caseList{get;set;}
    public listofcontactsextension(ApexPages.standardcontroller controller){
        selectedCons = new List<Contact>();
        acc = (Account)controller.getRecord();
        //this.ac = controller;
        if(wrapAcc== null) {
            wrapAcc = new List<wrapCase>();
            for(Contact testConObj: [select Name from Contact where Accountid =: acc.id limit 10]) {
                wrapAcc.add(new wrapCase(testConObj));
            }
        }
    }
    public void processSelected() {
        //selectedCons = new List<Contact>();
        if(!wrapAcc.isEmpty()){
            for(wrapCase wrapCaseObj : wrapAcc) {
            	if(wrapCaseObj.clicked == clickedContactName){
                	selectedCons.add(wrapCaseObj.cont);
                }
            }
        }
    }
    // This is our wrapper/container class. 
    public class wrapCase {
        public Contact cont{get; set;}       
        public string clicked{get; set;}
        public wrapCase(Contact TCase) {       
            cont = TCase;            
            clicked = TCase.Name;
        }
    }
}