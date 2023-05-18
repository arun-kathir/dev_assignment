public class GenerateJSONController1 {
    public string finalJSONString {get; set;}
    public Contact con {get; set;}
    public integer a {get; set;}
    public GenerateJSONController1(){
        con = new Contact();
        finalJSONString = '';
    }
    public void createContact(){
        system.JSONGenerator jsGen = JSON.createGenerator(true);
        jsGen.writeStartObject(); //To add {
        jsGen.writeFieldName('Status');
        try{
            insert con; 
            jsGen.writeString('SUCCESS');
            jsGen.writeIdField('conId', con.id);
            jsGen.writeDateField('CreatedDate', date.today());
            jsGen.writeStringField('Message', 'Contact is successfully inserted');
        }
        catch(Exception ex){
            jsGen.writeString('FAILED');
            jsGen.writeStringField('Message', ex.getMessage());
        }
        jsGen.writeEndObject(); //To add }

        finalJSONString = jsGen.getAsString();
    }
}