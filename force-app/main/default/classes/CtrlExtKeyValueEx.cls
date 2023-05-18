public class CtrlExtKeyValueEx {
    public Key_Value_Pair__c pair {get; set;}
    public Attachment attachment {get; set;}
    public List<SelectOption> types {get; set;}
    public static Map<string,Set<string>> mapLicenceType;
    public CtrlExtKeyValueEx(ApexPages.StandardController controller) {
        pair = (Key_Value_Pair__c)controller.getRecord();
        attachment = new Attachment();
        attachment = [Select Id, ParentId, Name, Description FROM Attachment WHERE ParentId =: pair.id limit 1];
        system.debug('Entered');
    }
    public void selectTypes(){
        types = new List<SelectOption>();
        system.debug('mapLicenceType: ' + mapLicenceType);
        mapLicenceType = new Map<string,Set<string>>();
        for(Key_Value_Pair__c kvp : [SELECT License_Type_Code__c,License_Type_State__c FROM Key_Value_Pair__c ORDER BY License_Type_State__c ASC NULLS LAST]){
            //system.debug('kvp: ' + kvp);
            if(mapLicenceType.containsKey(kvp.License_Type_State__c)){
                mapLicenceType.get(kvp.License_Type_State__c).add(kvp.License_Type_Code__c);
            }
            else{
                mapLicenceType.put(kvp.License_Type_State__c, new Set<string>{kvp.License_Type_Code__c});
            }
        }
        system.debug('mapLicenceType: ' + mapLicenceType);
        if(pair != null && pair.License_Type_State__c != null && !string.isblank(pair.License_Type_State__c)){
            if(mapLicenceType.get(pair.License_Type_State__c) != null && !mapLicenceType.get(pair.License_Type_State__c).isEmpty()){
                for(string str : mapLicenceType.get(pair.License_Type_State__c)){
                    types.add(new SelectOption(str,str));
                }
            }
        }
        system.debug('types: ' + types);
        //return options;
    }
    public PageReference test() {
        return null;
    }
}