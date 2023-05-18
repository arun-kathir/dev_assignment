global class SampleEmailServiceWithAttachments implements Messaging.InboundEmailHandler {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug(email.toAddresses);
        system.debug(email.fromAddress);
        system.debug(email.fromName);
        list<ContentVersion> cvList = new list<ContentVersion>();
        list<ContentDistribution> cdList = new list<ContentDistribution>();
        if(email.binaryAttachments != null){
            for (Messaging.InboundEmail.BinaryAttachment binAttach : email.binaryAttachments) {
                system.debug('Mime Type: ' + binAttach.mimeTypeSubType);
                system.debug('Headers: ' + binAttach.Headers);
                for(Messaging.InboundEmail.Header hd : binAttach.Headers){
                    system.debug('Name: ' + hd.Name);
                    system.debug('Value: ' + hd.Value);
                }
                ContentVersion cv = new ContentVersion();
                cv.Title = binAttach.fileName;
                cv.VersionData = binAttach.body;
                cv.PathOnClient = '/' + binAttach.fileName ;
                cvList.add(cv);
            }
        }
        if(!cvList.isEmpty()){
            insert cvList;
        }
        for(ContentVersion cv : [select id, ContentDocumentId, Title from ContentVersion where id IN: cvList]){
            ContentDistribution cd = new ContentDistribution();
            cd.Name = cv.Title;
            cd.ContentVersionId = cv.Id;
            cd.PreferencesAllowViewInBrowser= true;
            cdList.add(cd);
        }
        if(!cdList.isEmpty()){
            insert cdList;
        }
        ID jobID = System.enqueueJob(new factureOCRQueueable(cdList));
        System.debug('jobID'+jobID);
        return result;
    }
    
}