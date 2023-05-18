trigger ClosedOpportunityTrigger on Opportunity (after insert, after update, before update, before insert) {
    /*list<Task> taskInsertList = new list<Task>();
    for(Opportunity oppty : trigger.new){
        if(oppty.StageName == 'Closed Won'){
            taskInsertList.add(new Task(Subject = 'Follow Up Test Task', WhatId = oppty.id));
        }
    }
    if(taskInsertList != null){
        insert taskInsertList;
    }*/
    if(trigger.isBefore && trigger.isUpdate){
        for(Opportunity opp : trigger.new){
            if((opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') && opp.StageName != trigger.OldMap.get(opp.id).StageName){
                opp.Closed_date__c = system.today();
            }
        }
    }
    set<Id> setAsmntId = new set<Id>();
    map<id, decimal> mapProvIdToTotal = new map<id, decimal>();
    list<Assessment_Provider__c> updProv = new List<Assessment_Provider__c>();
    if(trigger.isAfter && trigger.isUpdate){
        for(Opportunity opp : trigger.new){
            if((opp.StageName == 'Closed Won') && opp.StageName != trigger.OldMap.get(opp.id).StageName && opp.Assessment_Provider__c != null){
                setAsmntId.add(opp.Assessment_Provider__c);
            }
        }
    }
    if(!setAsmntId.isEmpty()){
        for(Assessment_Provider__c prov : [select id, (select Amount from Opportunities__r where StageName = 'Closed Won') from Assessment_Provider__c where Id IN: setAsmntId ]){
            for(Opportunity oppty : prov.Opportunities__r){
                if(!mapProvIdToTotal.isEmpty() && mapProvIdToTotal.containsKey(prov.id)){
                    if(mapProvIdToTotal.get(prov.id) != null){
                        mapProvIdToTotal.put(prov.id, mapProvIdToTotal.get(prov.id) + oppty.Amount);
                    }
                    else{
                        mapProvIdToTotal.put(prov.id, oppty.Amount);
                    }
                }
                else{
                        mapProvIdToTotal.put(prov.id, oppty.Amount);
                }
        	}
        }
        for(Id assId : setAsmntId){
            if(!mapProvIdToTotal.isEmpty() && mapProvIdToTotal.containsKey(assId)){
                Assessment_Provider__c prov = new Assessment_Provider__c(id=assId, Assessment_Total__c=mapProvIdToTotal.get(assId));
                updProv.add(prov);
                }
        }
        if(!updProv.isEmpty()){
            update updProv;
        }
    }
    
}