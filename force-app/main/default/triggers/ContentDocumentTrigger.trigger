trigger ContentDocumentTrigger on ContentDocument (after insert) {
    map<string, id> mapCodeToId = new map<string, id>();
    list<ContentDocumentLink> listInsert = new list<ContentDocumentLink>();
    for(Key_Value_Pair__c KVP : [SELECT License_Type_State__c, License_Type_Code__c from Key_Value_Pair__c]){
        if(KVP.License_Type_Code__c != null){
        mapCodeToId.put(KVP.License_Type_Code__c, KVP.Id);
        }
    }
    for(ContentDocument cd : trigger.new){
        system.debug(cd.Title);
        string title = cd.Title;
        for(String code : mapCodeToId.keySet()){
            if(title.containsIgnoreCase(code)){
                listInsert.add(new ContentDocumentLink(ContentDocumentId = cd.id, LinkedEntityId = mapCodeToId.get(code), ShareType = 'V'));
            }
        }
    }
    if(!listInsert.isEmpty()){
        system.debug(listInsert);
        insert listInsert;
    }
}