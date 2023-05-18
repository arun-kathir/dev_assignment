public with sharing class lightningCompCtrlForSubmitAppr{
@AuraEnabled
public static void submitForApproval(Company__c comp)
    {
      User userRecord = [SELECT Id FROM User WHERE name= 'arun.kathiravan@accenture.in'];
       // Create an approval request for the Company
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval');
        req1.setObjectId(comp.id);
        req1.setSubmitterId(userRecord.id);
        req1.setProcessDefinitionNameOrId('Company_approval');// provide approval process name
        //req1.setSkipEntryCriteria(true);
        //Submit the approval request for the account
        Approval.ProcessResult result1 = Approval.process(req1);
        // First, get the ID of the newly created item
        /*List<Id>newWorkItemIds = result.getNewWorkitemIds();
        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
         
                // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
         
                // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
         
                // Verify the results
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        System.assertEquals('Approved', result2.getInstanceStatus(), 'Instance Status'+result2.getInstanceStatus());*/
    }
}