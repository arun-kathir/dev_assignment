public with sharing class SampleCopyAddressPageCtrlExt {
    public Contact contact{get;set;}
    public SampleCopyAddressPageCtrlExt(ApexPages.StandardController controller) {
        this.contact = (Contact )controller.getRecord();
        //contact = new Contact();
    }
    
    public void test(){
        contact.otherCountry = contact.MailingCountry;
        contact.otherState = contact.MailingState;
        contact.otherStreet = contact.MailingStreet;
        //return null;
    }
}