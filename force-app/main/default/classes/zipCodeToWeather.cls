public class zipCodeToWeather {
    public string endpoint;
    public string product{get;set;}
    public string zipcode{get;set;}
    public string oneobservation{get;set;}
    public string apikey{get;set;}
    public string respBody {get;set;}
    public map<string,string> temperature {get;set;}
    public zipCodeToWeather(){
        //https://weather.ls.hereapi.com/weather/1.0/report.json?
        //product=observation&zipcode=10025&oneobservation=true&apiKey=H6XyiCT0w1t9GgTjqhRXxDMrVj9h78ya3NuxlwM7XUs
        endpoint = 'https://weather.ls.hereapi.com/weather/1.0/report.json?';
        product = 'observation';
        //zipcode = '10025';
        oneobservation = 'true';
        apikey = 'QJKhPs2fg1hU1NtQ5sWkwcMOnIiVC-hWO1JVkmiVnfc';
        temperature = new map<string,string>();
    }
    public void getWeatherInfo(){
        //Http Callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //MEHTB
        req.setMethod('GET'); //Method
        endpoint += 'product=' + product;
        endpoint += '&zipcode=' + zipcode;
        endpoint += '&oneobservation=' + oneobservation;
        endpoint += '&apiKey=' + apiKey;
        req.setEndpoint(endpoint);
        //req.setHeader(key, value); No need of header
        req.setTimeout(60000);
        //req.setBody(body); No need of setting body for get method
        h.send(req);
        HttpResponse resp = h.send(req);
        respBody = resp.getBody();
        system.debug('resp: ' + resp);
        system.debug('respBody: ' + respBody);
        //Deserialize JSON to get Temperature
        system.JSONParser jp = JSON.createParser(respBody);
        while(jp.nextToken() != null){
            if(jp.getCurrentToken() == system.JSONToken.FIELD_NAME && jp.getText().containsIgnoreCase('temperature')){
                string mapKey = jp.getText();
                jp.nextToken();
                system.debug(jp.getText());
                temperature.put(mapKey,jp.getText());
            }
        }
    }
}