public class exampleCon {
    String uname;

    public String getUsername() {
        return uname;
    }
            
    public PageReference sayHello() {
        uname = UserInfo.getName();
        return null;
    }
            
    public void setState(String n) {
        state = n;
    }
            
    public String getState() {
        return state;
    }
            
    public PageReference methodOne() {
        return null;
    }
            
    private String state = 'no';

/*global class initiatePaymentClass {
    webservice static string initiatePayment(id eventId) {
        string region;
        Campaign ibEvent = new Campaign();
        set<id> setContactId = new set<id>();
        set<id> setCampaignIds = new set<id>();
        list<string> listVenueRegions = new list<string>();
        list<My_Staffing_Event__c> listAssignments = new list<My_Staffing_Event__c>();
        list<My_Staffing_Event__c> listUpdateAssignments = new list<My_Staffing_Event__c>();
        ibEvent = [select Name, Status, Type, RecordType.Name, Workshop_Event_Region__c, Workshop_Event_Region_del__c, StartDate, EndDate, Consultation_Visit_Date_Confirmed__c, CV_End_Date__c,
                             Workshop_Programme__c, IB_Programme__c, Programme_del__c, Related_IB_Programme__r.Name, Sub_Type__c, Related_IB_Programme__r.RecordType.Name,
                             (Select Name, Status, Type, RecordType.Name, Workshop_Event_Region__c, Workshop_Event_Region_del__c, StartDate, EndDate, Consultation_Visit_Date_Confirmed__c, CV_End_Date__c,
                             Workshop_Programme__c, IB_Programme__c, Programme_del__c, Related_IB_Programme__r.Name, Sub_Type__c, Related_IB_Programme__r.RecordType.Name from ChildCampaigns
                             where Status != 'Cancelled' and Payment_approval__c = false and External_PD_Provider__c = false)
                             from Campaign where id =: eventId and Payment_approval__c = false and External_PD_Provider__c = false];
        if(ibEvent.id != null){
            setCampaignIds.add(ibEvent.id);
            if(ibEvent.ChildCampaigns != null){
                for(Campaign camp : ibEvent.ChildCampaigns){
                    setCampaignIds.add(camp.id);
                }
            }
            String assignmentFieldString = UtilityClass.getCreatableFieldsSOQL('My_Staffing_Event__c') + ', IB_Event__r.Name';
            String assignmentQueryWhereClause = ' where (Application_Status__c = /'Confirmed/') and IB_Event__c IN ' + setCampaignIds + ' and Payment_Initiated__c = false 
                                                    and Exception_Created__c = false and IB_Contact__r.IB_Staff__c != /'Current/'';
            String assignmentQuery = 'SELECT ' + assignmentFieldString + ' FROM My_Staffing_Event__c';
            listAssignments = Database.Query(assignmentQuery + assignmentQueryWhereClause);
            if(!listAssignments.isEmpty()){
                for(My_Staffing_Event__c staffAssgnmt : listAssignments){
                    if(setContactId != null && !setContactId.contains(staffAssgnmt.IB_Contact__c)){
                        setContactId.add(staffAssgnmt.IB_Contact__c);
                        listVenueRegions.add(staffAssgnmt.Staffing_Event_Region__c);
                    }
                    if(!listVenueRegions.isEmpty()){
                        region = listVenueRegions[0];
                    }
                    else if(ibEvent.Workshop_Event_Region__c != null){
                        region = ibEvent.Workshop_Event_Region__c;
                    }
                    else if(ibEvent.Workshop_Event_Region_del__c != null){
                        region = ibEvent.Workshop_Event_Region_del__c;
                    }
                    system.debug('region: ' + region);
                }
            }
            if(!listVenueRegions.isEmpty()){
                region = listVenueRegions[0];
            }
            else if(ibEvent.Workshop_Event_Region__c != null){
                region = ibEvent.Workshop_Event_Region__c;
            }
            else if(ibEvent.Workshop_Event_Region_del__c != null){
                region = ibEvent.Workshop_Event_Region_del__c;
            }
            if(ibEvent.RecordType.Name != null){
                if(ibEvent.RecordType.Name == 'Regional Event'){
                    eventRecType = 'Regional Workshop';
                }
                else if(ibEvent.RecordType.Name == 'Cluster Event'){
                    eventRecType = 'Cluster Workshop';
                }
                else if(ibEvent.RecordType.Name == 'In School Event'){
                    eventRecType = 'In School Workshop';
                }
                else if(ibEvent.RecordType.Name == 'IBEN Parent Reader Event'){
                    eventRecType = 'Authorization';
                }
                else{
                    eventRecType = ibEvent.RecordType.Name;
                }
            }
            if(ibEvent.Type != null){
                if(ibEvent.Type == 'Reader Parent Event'){
                    eventType = 'Authorization';
                }
                else if(ibEvent.Type == 'Consultation' && eventRecType == 'Evaluation'){
                    eventType = 'Evaluation';
                }
                else if(ibEvent.Type == 'Parent In School Workshop' && eventRecType == 'In School Workshop'){
                    eventType = null;
                }
                else{
                    eventType = ibEvent.Type;
                }
            }
            if(ibEvent.Sub_Type__c != null){
                if(ibEvent.Sub_Type__c == 'Authorization Visit'){
                    eventSubType = 'Verification Visit';
                }
                else if(ibEvent.Sub_Type__c == 'Evaluation Follow Up'){
                    eventSubType = 'Evaluation Visit';
                }
                else if(ibEvent.Sub_Type__c == 'Return Visit'){
                    eventRecType = 'Evaluation';
                    eventSubType = 'Return Visit';
                    eventType = 'Evaluation';
                }
                else{
                    eventSubType = ibEvent.Sub_Type__c;
                }
            }
            if(eventRecType == 'Cluster Workshop'){ //No need to verify Type and Sub-type for Cluster Workshop events
                eventSubType = null;
                eventType = null;
            }
            if(eventSubType != null && (eventSubType.contains('Visit') || eventSubType.contains('Follow Up'))){
                isVisit = true;
            }
            if(eventSubType != null && eventSubType == 'Consultancy Visit'){
                if(ibEvent.Consultation_Visit_Date_Confirmed__c != null && ibEvent.CV_End_Date__c != null){
                    startDt = ibEvent.Consultation_Visit_Date_Confirmed__c;
                    endDt = ibEvent.CV_End_Date__c;
                }
                else{
                    return 'Consultancy Visit Start Date and Consultancy Visit End Date is mandatory before completing this event';
                }
            }
            else{
                startDt = ibEvent.StartDate;
                endDt = ibEvent.EndDate;
            }
            eventDays = startDt.daysBetween(endDt) + 1;
            system.debug('region: '+ region);
            system.debug('eventRecType: '+ eventRecType);
            system.debug('eventType: '+ eventType);
            system.debug('eventSubType: '+ eventSubType);
            system.debug('startDt: '+ startDt);
            system.debug('endDt: '+ endDt);
            system.debug('eventDays: '+ eventDays);
            //Check whether payment is required for this event. If its not required return 'Not Reqd' message
            string query = 'SELECT Account__c,Active__c,Amount__c,CreatedById,CreatedDate,CurrencyIsoCode,Currency__c,Effective_End_Date__c,Effective_Start_Date__c,'
                                    + 'Event_Record_Type__c,Event_Sub_type__c,Event_Type__c,Fees_Name__c,Fees_Type__c,Fiscal_year__c,'
                                    + 'IB_Programme__c,Id,LastModifiedById,LastModifiedDate,Name,OwnerId,Quantity__c,Service__c,Task_Code__c,'
                                    + 'Unique_Key__c,Unit_of_Measure__c,Venue_Region__c FROM IBEN_Honorarium_Fees_Table__c';
            string queryCondition = ' where Active__c = true and Venue_Region__c =: region';
            if(eventRecType != null){
                queryCondition += ' and Event_Record_Type__c =: eventRecType';
            }
            if(eventType != null){
                queryCondition += ' and Event_Type__c =: eventType';
            }
            if(eventSubType != null){
                queryCondition += ' and Event_Sub_type__c =: eventSubType';
            }
            if(startDt != null){
                queryCondition += ' and Effective_Start_Date__c <=: startDt and Effective_End_Date__c >=: startDt';
            }
            list<IBEN_Honorarium_Fees_Table__c> listFeesTable = new list<IBEN_Honorarium_Fees_Table__c>();
            system.debug('queryCondition: ' + queryCondition);
            listFeesTable = Database.query(query + queryCondition);
            system.debug('listFeesTable: ' + listFeesTable);
            system.debug('listFeesTable.size(): ' + listFeesTable.size());
            if(!listFeesTable.isEmpty()){
                for(IBEN_Honorarium_Fees_Table__c feesTableRec : listFeesTable){
                    setFeesNames.add(feesTableRec.Fees_Name__c);
                }
            }
            else{
                for(IBEN_Honorarium_payment_mapping__mdt mapping : [SELECT MasterLabel, DeveloperName, Event_Sub_type__c, Event_Type__c, No_Payment_Required__c FROM IBEN_Honorarium_payment_mapping__mdt where MasterLabel =: eventRecType]){
                    if((eventType != null && mapping.Event_Type__c != null && eventType == mapping.Event_Type__c) || (eventType == null && mapping.Event_Type__c == null)){
                        if((eventSubType != null && mapping.Event_Sub_type__c != null && eventSubType == mapping.Event_Sub_type__c) || (eventSubType == null && mapping.Event_Sub_type__c == null)){
                            if(mapping.No_Payment_Required__c){
                                return System.Label.IBEN_Honorarium_No_Payment_Error_Message;
                            }
                        }
                    }
                }
            }
            if(!setFeesNames.isEmpty()){
                list<IBEN_Honorarium_Payment__c> listInsertPayment = new list<IBEN_Honorarium_Payment__c>();
                system.debug('setFeesNames: ' + setFeesNames);
                if(setFeesNames.size() <= 2){
                    
                }
                else{
                    if(!listAssignments.isEmpty()){
                        for(My_Staffing_Event__c assignment : listAssignments) {
                            system.debug('Exception');
                            //Create Exception
                            IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                            if(eventRecType != null){
                                exp.Event_Record_Type__c = eventRecType;
                            }
                            if(eventType != null){
                                exp.Event_Type__c = eventType;
                            }
                            if(eventSubType != null){
                                exp.Event_Sub_type__c = eventSubType;
                            }
                            exp.Exception_message__c = System.Label.IBEN_Honorarium_multiple_fees_value_Exception_Message;
                            exp.IB_Event__c = assignment.IB_Event__c;
                            //exp.IB_Programme__c = 
                            exp.Registration_Number__c = assignment.id;
                            if(region != null){
                                exp.Venue_Region__c = region;
                            }
                            listException.add(exp);
                            assignment.Exception_Created__c = true;
                            listUpdateAssignments.add(assignment);
                        }
                    }
                    message = System.Label.IBEN_Honorarium_multiple_fees_value_Error_Message;
                }
                if(!listInsertPayment.isEmpty()){
                    system.debug('listInsertPayment: ' + listInsertPayment);
                    insert listInsertPayment;
                    ibEvent.Payment_approval__c = true;
                    update ibEvent;
                    return System.Label.IBEN_Honorarium_Payment_Success_Message;
                }
                else{
                    return System.Label.IBEN_Honorarium_No_Payment_Message;
                }
            }
            else{
                if(!listAssignments.isEmpty()){
                    for(My_Staffing_Event__c assignment : listAssignments) {
                        system.debug('Exception');
                        IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                        if(eventRecType != null){
                            exp.Event_Record_Type__c = eventRecType;
                        }
                        if(eventType != null){
                            exp.Event_Type__c = eventType;
                        }
                        if(eventSubType != null){
                            exp.Event_Sub_type__c = eventSubType;
                        }
                        exp.Exception_message__c = System.Label.IBEN_Honorarium_No_fees_value_Exception_Message;
                        exp.IB_Event__c = assignment.IB_Event__c;
                        //exp.IB_Programme__c = 
                        exp.Registration_Number__c = assignment.id;
                        if(region != null){
                            exp.Venue_Region__c = region;
                        }
                        listException.add(exp);
                    }
                }
                message = System.Label.IBEN_Honorarium_No_fees_value_Error_Message;
            }
        }
    }
}*/
}