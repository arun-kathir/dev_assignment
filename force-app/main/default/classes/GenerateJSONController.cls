/*
{
"FirstName":"Arun",
"LastName":"Kathir",
"Mobile":"+6582358445",
"Status":"<SUCCESS> / <FAILURE>"
}
*/
public class GenerateJSONController {
    public string finalJSONString {get; set;}
    public integer a {get; set;}
    public void createJSON(){
        system.JSONGenerator jsGen = JSON.createGenerator(true);
        jsGen.writeStartObject(); //To add {
        jsGen.writeStringField('FirstName', 'Arun');
        jsGen.writeStringField('LastName', 'Kathir');
        jsGen.writeStringField('Mobile', '+6582358445');
        jsGen.writeFieldName('Status');
        if(a > 10){
            jsGen.writeString('SUCCESS');
        }
        else{
            jsGen.writeString('FAILURE');
        }
        jsGen.writeEndObject(); //To add }

        finalJSONString = jsGen.getAsString();
    }
}