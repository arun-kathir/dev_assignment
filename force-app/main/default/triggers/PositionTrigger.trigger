trigger PositionTrigger on Position__c (before update, after update) {
    list<string> listStrOldTerr = new list<string>();
    list<string> listStrNewTerr = new list<string>();
    set<string> setStrRMLTerr = new set<string>();
    set<string> setStrOldRMLTerr = new set<string>();
    String strTerr = '';
    map<id,set<string>> mapIdToSetRMLTerr = new map<id,set<string>>();
    if(trigger.isBefore){
    for(Position__c oldPos : trigger.old){
        setStrRMLTerr.clear();
        listStrOldTerr.clear();
        if(oldPos.Territory__c != null){
            listStrOldTerr = oldPos.Territory__c.split(';');
            system.debug('listStrOldTerr: '+ listStrOldTerr);
            for(string tempStr : listStrOldTerr){
                if(tempStr.length() != 0 && tempStr.startsWith('2')){
                    //strRMLTerr += tempStr;
                    //strRMLTerr += ';';
                    system.debug('Entered');
                    setStrRMLTerr.add(tempStr);
                }
                //setStrRMLTerr.add(tempStr);
            }
            system.debug('setStrRMLTerr: ' + setStrRMLTerr);
            mapIdToSetRMLTerr.put(oldPos.id, setStrRMLTerr);
            system.debug('mapIdToSetRMLTerr: ' + mapIdToSetRMLTerr);
            //strRMLTerr = ';';
        }
    }
    
    for(Position__c newPos : trigger.new){
        listStrNewTerr.clear();
        setStrOldRMLTerr.clear();
        strTerr += ';';
        if(newPos.Territory__c != null){
            listStrNewTerr = newPos.Territory__c.split(';');
            system.debug('listStrNewTerr: ' + listStrNewTerr);
            if(!(mapIdToSetRMLTerr.isEmpty())){
                //newPos.Territory__c += mapIdToRMLTerr.get(newPos.id);
                system.debug('Entered');
                system.debug('mapIdToSetRMLTerr: ' + mapIdToSetRMLTerr);
                system.debug('newPos.id: ' + newPos.id);
                setStrOldRMLTerr = mapIdToSetRMLTerr.get(newPos.id);
                system.debug('setStrOldRMLTerr: ' + setStrOldRMLTerr);
                if(listStrNewTerr.size() > 0){
                    for(string tempNewTerr : listStrNewTerr){
                        if(tempNewTerr.length() != 0){
                            setStrOldRMLTerr.add(tempNewTerr);
                        }
                    }
                }
                
                if(setStrOldRMLTerr.size() > 0){
                    for(String tempOldTerr : setStrOldRMLTerr){
                        strTerr += tempOldTerr;
                        strTerr += ';';
                    }
                }
                system.debug('strTerr: ' + strTerr);
            }
        }
        newPos.Territory__c = strTerr;
    }}
    if(trigger.isAfter){
        for(Position__c newPos : trigger.new){
            if(newPos.Approval_status__c == 'Step2'){
                ProcessDefinition Position_approval_process = [Select id from ProcessDefinition where DeveloperName = 'Position_approval_process'];
                ProcessNode node = [Select id from ProcessNode where DeveloperName = 'Step_2'];
                ProcessInstance PI = [SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,
                                        ProcessDefinitionId,Status,SystemModstamp,TargetObjectId FROM ProcessInstance
                                        where TargetObjectId =: newPos.id and Status = 'Pending' limit 1];
                ProcessInstanceWorkitem pw = [SELECT ActorId,CreatedById,CreatedDate,Id,IsDeleted,OriginalActorId,
                                                ProcessInstanceId,SystemModstamp FROM ProcessInstanceWorkitem
                                                where ProcessInstanceId =: PI.id limit 1];
                //delete pw;
                //insert step;
                Approval.ProcessWorkitemRequest req2 = 
                new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
                req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req2.setWorkitemId(pw.id);
                Approval.ProcessResult result2 =  Approval.process(req2);
            }
        }
    }
}