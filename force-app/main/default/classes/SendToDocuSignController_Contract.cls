public with sharing class SendToDocuSignController_Contract {
    private final Contract contract;
    
    public String envelopeId {get;set;}
    private String accountId = 'b9f52ea6-7b7e-48a1-b30c-f61481c0c5fb';
    private String userId = '2b889e98-9383-471f-8a25-434c117f8172';
    private String password = 'Arunkumar17';
    private String integratorsKey = 'b2347d84-b3f6-4ea8-a461-6b2f3e67fc72';
    private String webServiceUrl = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
    
    public SendToDocuSignController_Contract(ApexPages.StandardController controller)
    {
        this.contract = [select Id, CustomerSignedId, AccountId, ContractNumber 
        from Contract where id = :controller.getRecord().Id];
        envelopeId = 'Not sent yet';
        
        SendNow();
    }

    public void SendNow()
    {
        DocuSignAPI.APIServiceSoap dsApiSend 
            = new DocuSignAPI.APIServiceSoap();
        dsApiSend.endpoint_x = webServiceUrl;

        //Set Authentication
        String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password><IntegratorKey>' + integratorsKey 
            + '</IntegratorKey></DocuSignCredentials>';
        /*String auth = '<DocuSignCredentials><Username>'+ userId 
            +'</Username><Password>' + password 
            + '</Password></DocuSignCredentials>';*/
        System.debug('Setting authentication to: ' + auth);
            
        dsApiSend.inputHttpHeaders_x = new Map<String, String>();
        dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', 
            auth);
 
        DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
        envelope.Subject = 'Please Sign this Contract: ' 
            + contract.ContractNumber;
        envelope.EmailBlurb = 'This is my new eSignature service,'+ 
            ' it allows me to get your signoff without having to fax, ' +
            'scan, retype, refile and wait forever';
        envelope.AccountId  = accountId; 
        

        // Render the contract
        System.debug('Rendering the contract');
        PageReference pageRef = new PageReference('/apex/RenderContract');
        pageRef.getParameters().put('id',contract.Id);
        Blob pdfBlob = pageRef.getContent();     

        // Document
        DocuSignAPI.Document document = new DocuSignAPI.Document();
        document.ID = 1;
        document.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
        document.Name = 'Contract';
        document.FileExtension = 'pdf';
        envelope.Documents = new DocuSignAPI.ArrayOfDocument();
        envelope.Documents.Document = new DocuSignAPI.Document[1];
        envelope.Documents.Document[0] = document;
        
        // Recipient
        System.debug('getting the contact');
        Contact contact = [SELECT email, FirstName, LastName 
            from Contact where id = :contract.CustomerSignedId];
        
        DocuSignAPI.Recipient recipient = new DocuSignAPI.Recipient();
        recipient.ID = 1;
        recipient.Type_x = 'Signer';
        recipient.RoutingOrder = 1;
        recipient.Email = contact.Email;
        recipient.UserName = contact.FirstName + ' ' + contact.LastName;
            
        // This setting seems required or you see the error:
        // "The string '' is not a valid Boolean value. 
        // at System.Xml.XmlConvert.ToBoolean(String s)" 
        recipient.RequireIDLookup = false;      
        
        envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
        envelope.Recipients.Recipient = new DocuSignAPI.Recipient[1];
        envelope.Recipients.Recipient[0] = recipient;
        
        // Tab
        DocuSignAPI.Tab tab1 = new DocuSignAPI.Tab();
        tab1.Type_x = 'SignHere';
        tab1.RecipientID = 1;
        tab1.DocumentID = 1;
        tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab1.AnchorTabItem.AnchorTabString = 'By:';

        
        DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
        tab2.Type_x = 'DateSigned';
        tab2.RecipientID = 1;
        tab2.DocumentID = 1;
        tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
        tab2.AnchorTabItem.AnchorTabString = 'Date Signed:';
        
        envelope.Tabs = new DocuSignAPI.ArrayOfTab();
        envelope.Tabs.Tab = new DocuSignAPI.Tab[2];
        envelope.Tabs.Tab[0] = tab1;        
        envelope.Tabs.Tab[1] = tab2;
        
        DocuSignAPI.CustomField field = new DocuSignAPI.CustomField ();
        field.Name = '##SFContract';
        field.Value = contract.Id;
        
        envelope.CustomFields = new DocuSignAPI.ArrayOfCustomField();
        envelope.CustomFields.CustomField = new DocuSignAPI.CustomField[1];
        envelope.CustomFields.CustomField[0] = field;
        
        System.debug('Calling the API');
        try {
            DocuSignAPI.EnvelopeStatus es 
            = dsApiSend.CreateAndSendEnvelope(envelope);
            envelopeId = es.EnvelopeID;
        } catch ( CalloutException e) {
            System.debug('Exception - ' + e );
            envelopeId = 'Exception - ' + e;
        }
      
    }
}