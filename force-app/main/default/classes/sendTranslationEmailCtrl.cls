public class sendTranslationEmailCtrl {
    public void sendTranslationEmail(){
        system.debug(UserInfo.getLanguage());
        system.debug(UserInfo.getLanguage().startsWithIgnoreCase('en'));
        system.debug(UserInfo.getUserEmail());
        string templateName = 'Translation Sample Template ';
        if(UserInfo.getLanguage().startsWithIgnoreCase('en')){
            templateName += 'EN';
        }
        else if(UserInfo.getLanguage().startsWithIgnoreCase('es')){
            templateName += 'SP';
        }
         EmailTemplate et=[Select id, Name from EmailTemplate where name =: templateName limit 1];
         system.debug(et);
         /*Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
         mail.setTargetObjectIds(lstIds);
         mail.setSenderDisplayName('System Admin');
         mail.setTemplateId(et.id);
         Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });*/
    }
}