global class submitForApprovalWS {
    webservice static string submitForApproval(id companyId) {
        try{
            for(Company__c comp : [select Company_Status__c from Company__c where id =: companyId]){
                if(comp.Company_Status__c == 'Inactive'){
                    //comp.addError('Company needs to be active to be submitted');
                    return 'DisplayMessage';
                }
                else{
                    //User userRecord = [SELECT Id FROM User WHERE username = 'arun.kathiravan@accenture.in'];
                    User userRecord = [SELECT Id FROM User WHERE id =: UserInfo.getUserId()];
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval');
                    req1.setObjectId(comp.id);
                    req1.setSubmitterId(userRecord.id);
                    req1.setProcessDefinitionNameOrId('Company_approval');// provide approval process name
                    //req1.setSkipEntryCriteria(true);
                    //Submit the approval request for the account
                    Approval.ProcessResult result1 = Approval.process(req1);
                    return 'DontDisplayMessage';
                }
            }
            return null;
        }
        catch(Exception ex){
            return ex.getMessage();
        }
    }
}