public with sharing class helloWorldAuraCtrl {
	@AuraEnabled
    public static string getAcntName(){
        return [select Name from Account limit 1][0].Name;
    }
}