/*
{
"Contacts": [{"FirstName":"Arun","LastName":"Kathir","Mobile":"+6582358445"}, 
{"FirstName":"Aswini","LastName":"Arun","Mobile":"+6582519291"}]
"Status":"<SUCCESS> / <FAILURE>"
}
*/
public class GenerateJSONController2 {
    public string finalJSONString {get; set;}
    //public Contact con {get; set;}
    //public integer a {get; set;}
    public GenerateJSONController2(){
        //con = new Contact();
        finalJSONString = '';
    }
    public void createJSONForContact(){
        list<Contact> conList = [select FirstName, LastName, Phone, (Select CaseNumber from Cases) from Contact where Name like '%Jack%'];
        system.JSONGenerator jsGen = JSON.createGenerator(true);
        jsGen.writeStartObject(); //To add {
        try{
            if(conList != null && !conList.isEmpty()){
                jsGen.writeFieldName('Contacts');
                jsGen.writeStartArray(); //To add [
                for(Contact con : conList){
                    jsGen.writeStartObject(); //To add {
                    jsGen.writeStringField('FirstName',con.FirstName);
                    jsGen.writeStringField('LastName',con.LastName);
                    if(con.Phone != null)
                    jsGen.writeStringField('Mobile',con.Phone);
                    if(con.Cases != null){
                        jsGen.writeFieldName('Cases');
                        jsGen.writeStartArray(); //To add [
                        for(Case cs : con.Cases){
                            jsGen.writeStartObject(); //To add {
                            jsGen.writeStringField('Case Number',cs.CaseNumber);
                            jsGen.writeEndObject(); //To add }
                        }
                        jsGen.writeEndArray();
                    }
                    jsGen.writeEndObject(); //To add }
                }
                jsGen.writeEndArray(); //To add ]
                jsGen.writeStringField('Status','SUCCESS');
            }
            else{
                jsGen.writeStringField('Status','FAILED because no records');
            }
        }
        Catch(Exception ex){
            jsGen.writeStringField('Status','FAILED because ' + ex.getMessage());
        }
        jsGen.writeEndObject(); //To add }
        
        finalJSONString = jsGen.getAsString();
    }
}