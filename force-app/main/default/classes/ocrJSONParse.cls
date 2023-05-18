public class ocrJSONParse {
    public static string parseStaticRsrJSON(string jsonString){
        //system.debug('allcontents: ' + allcontents);
        JSONParser jp = JSON.createParser(jsonString);
        
        while(jp.nextToken() != null){
            if(jp.getCurrentToken() == System.JSONToken.FIELD_NAME && jp.getText() == 'label'){
                jp.nextToken();
                if(jp.getText().equalsIgnoreCase('Number')){
                    while(jp.nextToken() != null){
                        if(jp.getCurrentToken() == System.JSONToken.FIELD_NAME && jp.getText() == 'label'){
                            jp.nextToken();
                            system.debug(jp.getText());
                            if(jp.getText().isNumeric()){
                                system.debug('Invoice Number: ' + jp.getText());
                                return jp.getText();
                            }
                            //temperature.put(mapKey,jp.getText());
                            break;
                        }
                    }
                }
            }
        }
        return null;
    }
}