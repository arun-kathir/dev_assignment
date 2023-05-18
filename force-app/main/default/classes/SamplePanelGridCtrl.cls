public with sharing class SamplePanelGridCtrl {
    public Account acc {get; set;}
    public void populateAccounts(){
        acc = [select id, Name, AccountNumber, Phone from Account where Name = 'Express Logistics and Transport'];
    }
}