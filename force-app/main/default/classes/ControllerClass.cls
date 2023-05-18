public class ControllerClass {
    
    public boolean selected1 {get;set;}
    public Candidate__c Cd {get; set;}
    //public PageReference copyField{get; set;}
    public ControllerClass(){
        Cd = new Candidate__c();
    }
    public PageReference copyField(){
        if(selected1==true){
        Cd.Name = Cd.First_Name__c + ' ' + Cd.Last_Name__c;
        }
        return null;
    }
}