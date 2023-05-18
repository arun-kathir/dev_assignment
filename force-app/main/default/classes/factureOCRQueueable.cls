public class factureOCRQueueable implements Queueable, Database.AllowsCallouts {
    public list<ContentDistribution> cdList = new list<ContentDistribution>();
    public factureOCRQueueable(list<ContentDistribution> cdList){
        this.cdList = cdList ;  
    }
    public void execute(QueueableContext context) {
        string contentType = 'application/JSON';
        contentType = 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"';
        string endpoint = 'https://api.einstein.ai/v2/vision/ocr';
        Blob formBlob;
        EinsteinController ectrl = new EinsteinController();
        string token = ectrl.getAccessToken();
        map<string, ContentDistribution> mapFactureToAttachment = new map<string, ContentDistribution>();
        list<Invoice__c> listInvoices = new list<Invoice__c>();
        for(ContentDistribution cd : [select ContentDocumentId,DistributionPublicUrl,ContentDownloadURL from ContentDistribution where id IN:cdList]){
            HttpRequest httpRequest = new HttpRequest();
            string form64 = '';        
            form64 += HttpFormBuilder.WriteBoundary();
            //form64 += HttpFormBuilder.WriteBodyParameter('sampleLocation', 'https://nura-dev-ed.my.salesforce.com/sfc/p/90000000thNM/a/0I000003DZu6/LOuxlALnrqvcwlgwpPz9tISsCpzeWiYK_cPUcFKxgV8');
            form64 += HttpFormBuilder.WriteBodyParameter('sampleLocation', cd.ContentDownloadURL);
            form64 += HttpFormBuilder.WriteBoundary();
            form64 += HttpFormBuilder.WriteBodyParameter('modelId', 'OCRModel');
            //form64 += HttpFormBuilder.WriteBodyParameter('modelId', 'tabulatev2');
            form64 += HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);
            
            formBlob = EncodingUtil.base64Decode(form64);
            system.debug('formBlob: ' + formBlob);
            string contentLength = string.valueOf(formBlob.size());
            system.debug('contentLength: ' + contentLength);
            httpRequest.setBodyAsBlob(formBlob);
            httpRequest.setHeader('Connection', 'keep-alive');
            httpRequest.setHeader('Content-Length', contentLength);
            httpRequest.setHeader('Content-Type', contentType);
            httpRequest.setHeader('Cache-Control', 'no-cache');
            httpRequest.setMethod('POST');
            httpRequest.setTimeout(120000);
            httpRequest.setHeader('Authorization','Bearer ' + token);
            httpRequest.setEndpoint(endPoint);
    
            Http http = new Http();
            try {
                HTTPResponse res = http.send(httpRequest);
                if (res.getStatusCode() == 200) {
                    string jsonString = res.getBody();
                    system.debug('jsonString: ' + jsonString);
                    string invoice = ocrJSONParse.parseStaticRsrJSON(jsonString);
                    if(invoice != null && invoice.isNumeric()){
                        mapFactureToAttachment.put(invoice, cd);
                    }
                    else{//Create File d'attente records with Echec status if there is no invoice number
                        Invoice__c inv = new Invoice__c(Status__c = 'Failed');
                        listInvoices.add(inv);
                    }
                }
                else{
                    system.debug('Resp: ' + res.getStatusCode());
                    system.debug('Resp: ' + res.getBody());
                }
            } catch(System.CalloutException e) {
                System.debug('ERROR:' + e);
                //return e.getStackTraceString();
            }
        }
        if(!mapFactureToAttachment.isEmpty()){
            for(string invNum : mapFactureToAttachment.keyset()){
                //insert File d'attente records for all new invoice numbers
                Invoice__c inv = new Invoice__c(Invoice_Number__c = invNum, Status__c = 'Success');
                listInvoices.add(inv);
            }
        }
        list<ContentDocumentLink> listDocLink = new list<ContentDocumentLink>();
        if(!listInvoices.isEmpty()){
            insert listInvoices;//insert File d'attente records for all new invoice numbers
            for(Invoice__c inv : listInvoices){
                if(mapFactureToAttachment.get(inv.Invoice_Number__c) != null){
                    ContentDocumentLink cdl = new ContentDocumentLink();//Prepare Content Document Link records for all pdf attachments
                    cdl.ContentDocumentId = mapFactureToAttachment.get(inv.Invoice_Number__c).ContentDocumentId;
                    cdl.LinkedEntityId = inv.Id;
                    listDocLink.add(cdl);
                }
            }
            if(!listDocLink.isEmpty()){
                insert listDocLink;//Insert Content Document Link records for all pdf files related to File d'attente records
            }
        }
    }
}