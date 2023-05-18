public class postal_off_info {
    public string pinCode {get;set;}
    public string branchName {get;set;}
    public string respBodyPinCode {get;set;}
    public string respBodyBranchName {get;set;}
    public list<string> poNamesByPinCode {get;set;}
    public list<string> poNamesByBranchName {get;set;}
    public void getPostOffInfoByPincode(){
        poNamesByPinCode = new list<string>();
        //Http Callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //MEHTB
        req.setMethod('GET'); //Method
        req.setEndpoint('https://api.postalpincode.in/pincode/' + pinCode); //Endpoint URL
        req.setTimeout(60000); // Timeout value in milliseconds
        HttpResponse resp = h.send(req);
        respBodyPinCode = resp.getBody();
        system.debug('resp: ' + resp);
        //Deserialize JSON
        system.JSONParser jp = JSON.createParser(respBodyPinCode);
        while(jp.nextToken() != null){
            if(jp.getCurrentToken() == system.JSONToken.FIELD_NAME && jp.getText() == 'Name'){
                jp.nextToken();
                system.debug(jp.getText());
                poNamesByPinCode.add(jp.getText());
            }
        }
    }
    public void getPostOffInfoByBranchName(){
        poNamesByBranchName = new list<string>();
        //Http Callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //MEHTB
        req.setMethod('GET'); //Method
        req.setEndpoint('https://api.postalpincode.in/postoffice/' + branchName);
        req.setTimeout(60000); // Timeout value in milliseconds
        HttpResponse resp = h.send(req);
        respBodyBranchName = resp.getBody();
        system.debug('resp: ' + resp);
        //Deserialize JSON
        system.JSONParser jp = JSON.createParser(respBodyBranchName);
        while(jp.nextToken() != null){
            if(jp.getCurrentToken() == system.JSONToken.FIELD_NAME && jp.getText() == 'Name'){
                jp.nextToken();
                system.debug(jp.getText());
                poNamesByBranchName.add(jp.getText());
            }
        }
    }
}