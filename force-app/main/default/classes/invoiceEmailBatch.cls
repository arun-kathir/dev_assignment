global class invoiceEmailBatch implements Database.Batchable<sObject>{
    Id queueId = [SELECT Id, Type FROM Group WHERE Type = 'Queue' AND Name = 'Invoice queue'].Id;
    Id templateId = [Select Id,DeveloperName from EmailTemplate where Name = 'InvEmailClassicHTML'].Id;
	global Database.QueryLocator start(Database.BatchableContext bc){
        string query = 'SELECT Amount_to_be_paid__c,Contact__c,Contact__r.Name, Contact__r.Email, Contact__r.Account.Name';
        query += ', Due_date__c,Id,Invoice_date__c,Invoice_Number__c,Inv_amount__c,Name,Paid_amount__c,Status__c FROM Invoice__c';
        query += ' where Amount_to_be_paid__c > 0';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, list<Invoice__c> invList){
        String acntName;
        list<Task> listTask = new list<Task>();
        list<Contact> listContToUpd = new list<Contact>();
        map<id, string> mapContIdToInvoiceHTMLTable = new map<id, string>();
        map<id, list<Invoice__c>> mapContIdToListInvoice = new map<id, list<Invoice__c>>();
        list<Messaging.SingleEmailMessage> listEmails = new list<Messaging.SingleEmailMessage>();
        system.debug('queueId: ' + queueId);
        system.debug('templateId: ' + templateId);
        for(Invoice__c inv : invList){
            if(inv.Contact__c != null && inv.Contact__r.Email != null){
                acntName = inv.Contact__r.Account.Name;
                if(!mapContIdToListInvoice.containsKey(inv.Contact__c)){
                    mapContIdToListInvoice.put(inv.Contact__c, new list<Invoice__c>{inv});
                }
                else{
                    mapContIdToListInvoice.get(inv.Contact__c).add(inv);
                }
            }
            else{
                Task tsk = new Task(Subject = 'Send Letter', OwnerId = queueId, WhatId = inv.Id);
                if(inv.Contact__c != null){
                    tsk.WhoId = inv.Contact__c;
                }
                listTask.add(tsk);
            }
        }
        for(Id contId : mapContIdToListInvoice.keySet()){
            decimal amountToBePaid = 0.0;
            string htmlInvTable = '<table>';
            htmlInvTable += '<tr><th>Invoice Date</th>';
            htmlInvTable += '<th>Invoice Number</th>';
            htmlInvTable += '<th>Due Date</th>';
            htmlInvTable += '<th>Remaining amount</th></tr>';
            for(Invoice__c inv : mapContIdToListInvoice.get(contId)){
                amountToBePaid += inv.Amount_to_be_paid__c;
                htmlInvTable += '<tr><th>' + inv.Invoice_date__c + '</th>';
                htmlInvTable += '<th>' + inv.Invoice_Number__c + '</th>';
                htmlInvTable += '<th>' + inv.Due_date__c + '</th>';
                htmlInvTable += '<th>' + inv.Amount_to_be_paid__c + '</th></tr>';
            }
            htmlInvTable += '</table>';
            mapContIdToInvoiceHTMLTable.put(contId, htmlInvTable);
            system.debug('htmlInvTable: ' + htmlInvTable);
            Contact cont = new Contact(id = contId, Invoice_List_HTML__c = htmlInvTable);
            listContToUpd.add(cont);
        }
        if(!listContToUpd.isEmpty()){
         update listContToUpd;   
        }
        for(Id contId : mapContIdToListInvoice.keySet()){
            String emailId;
            string contName;
            string htmlBody = '<html><body>Hello ';
            string ccAddr = 'arun.niji.sg@gmail.com;arunkumar.kathiravan@niji.fr';
            List<String> listCCAddr = new List<String>();
            listCCAddr = ccAddr.split(';');
            system.debug('listCCAddr: ' + listCCAddr);
            for(Invoice__c inv : mapContIdToListInvoice.get(contId)){
                emailId = inv.Contact__r.Email;
                contName = inv.Contact__r.name;
                
            }
            htmlBody += contName + ',<br/><br/>';
            htmlbody += mapContIdToInvoiceHTMLTable.get(contId) + '<br/><br/>Thanks,<br/>Admin</body></html>';
            system.debug('emailId: ' + emailId);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new string[] {emailId});
            //email.setEntityAttachments(listInvoiceFileIds);
            email.setSubject(acntName + ' - notification for pending invoice payments');
            email.setTargetObjectId(contId);
            //email.setReplyTo('');
            //email.setCcAddresses(listCCAddr);
            email.setSaveAsActivity(true);
            //email.setTemplateId(templateId);
            email.setHtmlBody(htmlBody);
            listEmails.add(email);
        }
        if(!listEmails.isEmpty()){
            Messaging.sendEmail(listEmails);
        }
        if(!listTask.isEmpty()){
            insert listTask;
        }
    }
    global void finish(Database.BatchableContext bc){

    }
}