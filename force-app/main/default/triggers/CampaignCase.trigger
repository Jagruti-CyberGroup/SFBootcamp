trigger CampaignCase on Campaign_Case__c (before insert) {

    if(Trigger.IsBefore && Trigger.isInsert){
        CampaignCaseTriggerHandler.handleBeforeInsert(Trigger.new);   // calling trigger handler method
    }
}