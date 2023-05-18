public class AssigningCasesToSessionExtensions {
	Test_Session__c testSession;
	public string inputCases{get;set;}
	public list<wrapCase> wrapCaseList{get; set;}
	public list<wrapCase> wrapUnassignCaseList{get; set;}
	public list<wrapTestCase> wrapClickedTestCaseList{get; set;}
	public list<Test_Case__c> selectedCases{get;set;}
	public list<Test_Case__c> selectedTestCases{get;set;}
	public list<Test_Case__c> clickedCases{get;set;}
	public string clickedTestCaseName{get; set;}
	public string msg{get;set;}
	ApexPages.standardcontroller TS;
	list<Test_Session_Case__c> listInsertTestSessionCase = new list<Test_Session_Case__c>();
	list<Test_Session_Case__c> listTestSessionCase = new list<Test_Session_Case__c>();
	list<Test_Session_Case__c> listDeleteTestSessionCase = new list<Test_Session_Case__c>();
	list<Test_Case__c> listTestCase = new list<Test_Case__c>();
	list<string> caseNameList = new list<string>();
	//public list<Test_Case__c> caseList{get;set;}
	public AssigningCasesToSessionExtensions(ApexPages.standardcontroller controller){
		testSession = (Test_Session__c)controller.getRecord();
		system.debug('testSessionID' + testSession.id);
		this.TS = controller;
        if(wrapUnassignCaseList == null) {
            wrapUnassignCaseList = new List<wrapCase>();
            for(Test_Case__c testCaseObj: [select Name, Test_Case_Name__c from Test_Case__c where id IN (select Test_Case__c from Test_Session_Case__c where Test_Session__c =: testSession.id )]) {
                wrapUnassignCaseList.add(new wrapCase(testCaseObj));
            }
        }
		if(wrapClickedTestCaseList == null){
			wrapClickedTestCaseList = new List<wrapTestCase>();
			for(Test_Session_Case__c tsc : [select id, Test_Case__c, Test_Session__c from Test_Session_Case__c where Test_Session__c =: testSession.id]){
				for(Test_Case__c testCaseObj : [select Name, Test_Case_Name__c from Test_Case__c where id = :tsc.Test_Case__c]){
					wrapClickedTestCaseList.add(new wrapTestCase(testCaseObj));
				}
			}
		}
	}
    public void processSelected() {
        selectedCases = new List<Test_Case__c>();
        if(!wrapCaseList.isEmpty()){
	        for(wrapCase wrapCaseObj : wrapCaseList) {
	            if(wrapCaseObj.selected == true) {
	                selectedCases.add(wrapCaseObj.testcase);
	            }
	        }
        }
    }
    public void processSelected1() {
        selectedCases = new List<Test_Case__c>();
        if(!wrapUnassignCaseList.isEmpty()){
	        for(wrapCase wrapCaseObj : wrapUnassignCaseList) {
	            if(wrapCaseObj.selected == true) {
	                selectedTestCases.add(wrapCaseObj.testcase);
	            }
	        }
        }
    }
    public pageReference processClicked() {
        clickedCases = new List<Test_Case__c>();
        Test_Scenario_History__c testScenario;
        Test_Scenario_Script__c testScenarioScript;
        list<Test_Scenario_Script__c> testScenarioScriptlist = new list<Test_Scenario_Script__c>();
        if(!wrapClickedTestCaseList.isEmpty()){
	        for(wrapTestCase wrapTestCaseObj : wrapClickedTestCaseList) {
	            if(wrapTestCaseObj.clicked == clickedTestCaseName) {
	            	for(Test_Session_Case__c testSessionCaseObj: [select id from Test_Session_Case__c where Test_Session__c =: testSession.id and Test_Case__c =: wrapTestCaseObj.testcaseclicked.id]) {
	            		testScenario = new Test_Scenario_History__c(Test_Case__c = testSessionCaseObj.id, Execution_start_date_time__c = system.now());
	            	}
	            }
	        }
	        insert testScenario;
        }
        if(testScenario.Id != null){
        	for(Test_Script__c testScript : [select Name, Expected_Result__c, Script_Step__c, Test_Script_Description__c from Test_Script__c where Related_Test_Case__c =: testScenario.Test_Case__r.Test_Case__r.id]){
        		testScenarioScript = new Test_Scenario_Script__c(
        										Name = testScript.Name,
        										Expected_Result__c = testScript.Expected_Result__c,
        										Step__c = testScript.Script_Step__c,
        										Test_Script_Description__c = testScript.Test_Script_Description__c,
        										Test_Scenario_History__c = testScenario.id);
        		testScenarioScriptlist.add(testScenarioScript);
        	}
        	insert testScenarioScriptlist;
        }
		PageReference pr = new PageReference('/apex/RunScenarioScriptPage?id='+testScenario.id);
		pr.setRedirect(true);
		return pr;
    }
	/*public list<Test_Case__c> getAssign(){
		return null;
	}*/
	public void searchCases(){
		if(inputCases != null){
			caseNameList = inputCases.split(',');
		}
        if(wrapCaseList == null && !caseNameList.isEmpty()) {
            wrapCaseList = new List<wrapCase>();
            for(Test_Case__c a: [select Name, Test_Case_Name__c from Test_Case__c where Name IN :caseNameList]) {
                wrapCaseList.add(new wrapCase(a));
            }
        }
	}
	public pageReference assignCases(){
		set<id> setTestCaseId = new set<id>();
		if(!wrapCaseList.isEmpty()){
	        for(wrapCase wrapCaseObj : wrapCaseList) {
	            if(wrapCaseObj.selected == true) {
	            	setTestCaseId.add(wrapCaseObj.testcase.id);
	            	//Test_Session_Case__c testSessionCase = new Test_Session_Case__c(Test_Case__c = wrapCaseObj.testcase.id, Test_Session__c = testSession.id);
	            	//listInsertTestSessionCase.add(testSessionCase);
	            }
	        }
		}
		if(!setTestCaseId.isEmpty()){
			for(Test_Session_Case__c tempTestSessionCaseObj : [select id, Test_Case__c from Test_Session_Case__c where Test_Session__c =: testSession.id]){
				if(setTestCaseId.contains(tempTestSessionCaseObj.Test_Case__c)){
					setTestCaseId.remove(tempTestSessionCaseObj.Test_Case__c);
				}
			}
		}
		for(Id tempId : setTestCaseId){
        	Test_Session_Case__c testSessionCase = new Test_Session_Case__c(Test_Case__c = tempId, Test_Session__c = testSession.id);
        	listInsertTestSessionCase.add(testSessionCase);
		}
		if(!listInsertTestSessionCase.isEmpty()){
        	insert listInsertTestSessionCase;
		}
		msg = 'Test Cases successfully assigned';
		return TS.view().setRedirect(true);
	}
	public pageReference unassignCases(){
		list<id> listTestCaseId = new list<id>();
		if(!wrapUnassignCaseList.isEmpty()){
	        for(wrapCase wrapCaseObj : wrapUnassignCaseList) {
	            if(wrapCaseObj.selected == true) {
	            	listTestCaseId.add(wrapCaseObj.testcase.id);
	            }
	        }
		}
        if(!listTestCaseId.isEmpty()){
        	listDeleteTestSessionCase = [select id from Test_Session_Case__c where Test_Case__c IN: listTestCaseId AND Test_Session__c =: testSession.id];
        }
        if(!listDeleteTestSessionCase.isEmpty()){
        	delete listDeleteTestSessionCase;
        }
		msg = 'Test Cases successfully unassigned';
		return TS.view().setRedirect(true);
	}
	/*public list<Test_Case__c> getTestCases(){

	}*/
	public pageReference assignPage(){
		PageReference pr = new PageReference('/apex/AssigningCasesToSession?id='+testSession.id);
		pr.setRedirect(true);
		return pr;
	}
	public pageReference unassignPage(){
		PageReference pr = new PageReference('/apex/UnassigningCasesToSession?id='+testSession.id);
		pr.setRedirect(true);
		return pr;
	}
    // This is our wrapper/container class. 
    public class wrapCase {
        public Test_Case__c testcase {get; set;}
        public Boolean selected {get; set;}
        public wrapCase(Test_Case__c TCase) {
            testcase = TCase;
            selected = false;
        }
    }
    public class wrapTestCase {
        public Test_Case__c testcaseclicked {get; set;}
        public string clicked{get; set;}
        public wrapTestCase(Test_Case__c TCase) {
            testcaseclicked = TCase;
            clicked = TCase.Name;
        }
    }
}