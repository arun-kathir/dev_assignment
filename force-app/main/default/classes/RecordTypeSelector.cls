public class RecordTypeSelector{
    public static Map<Id, String> recordtypemap;

@AuraEnabled        

    public static Map<Id, String> fetchRecordTypeValues(String objectName){
        List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master' && rt.getName().trim() != '')
            	recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap;
    }
}