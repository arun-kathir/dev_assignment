public with sharing class restrictJobAppViewControllerExtension{
    private final Job_Application__c jobApp;
    id idProfile;
    
    public restrictJobAppViewControllerExtension(ApexPages.StandardController stdController){
        this.jobApp = (Job_Application__c)stdController.getRecord();
    }

    public boolean getDisplay(){
    	system.debug('Profile name: ' + [select name from profile where id =: userinfo.getProfileId()].name);
    	system.debug('Profile id: ' + [select id from profile where id =: userinfo.getProfileId()].id);
    	for(Job_Application__c JobApp1 : [select id, ownerid from Job_Application__c where id = : jobApp.id]){
	    	idProfile = [select profileid from user where id = : JobApp1.OwnerId].profileid;
	    	system.debug('Profile name: ' + [select name from profile where id =: idProfile].name);
	    	if(userinfo.getProfileId() == '00e90000001DAVFAA4' && (userinfo.getProfileId() != idProfile)){
	    		system.debug('Entered');
	    		return false;
	    	}
    	}
    	return true;
    }
    
    public boolean getDisplayMsg(){
    	system.debug('Profile name: ' + [select name from profile where id =: userinfo.getProfileId()].name);
    	system.debug('Profile id: ' + [select id from profile where id =: userinfo.getProfileId()].id);
    	for(Job_Application__c JobApp1 : [select id, ownerid from Job_Application__c where id = : jobApp.id]){
	    	idProfile = [select profileid from user where id = : JobApp1.OwnerId].profileid;
	    	system.debug('Profile name: ' + [select name from profile where id =: idProfile].name);
	    	if(userinfo.getProfileId() == '00e90000001DAVFAA4' && (userinfo.getProfileId() != idProfile)){
	    		system.debug('Entered');
	    		return true;
	    	}
    	}
    	return false;
    }
}