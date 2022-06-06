public class CampaignCaseTriggerHandler {

    public static void handleBeforeInsert(List<Campaign_Case__c> newCampaignCase){
    
      List<Not_Interested_List__mdt> lstLabel = Not_Interested_List__mdt.getAll().values();
   
    String str = '';
    Set<String> a  = new Set<String>();
    
    for(Not_Interested_List__mdt nil : lstLabel){
        a.add(nil.Label); 
    }
    
    List<String> idList = new List<String>(a);
    
    for (Campaign_Case__c c : newCampaignCase) {
       
        if(c.Description__c != null)
        {
            for(integer i = 0; i < lstLabel.size();i++) {       
                if(c.Description__c.containsIgnoreCase(idList[i])){
                    
                    c.Customer_Prospect__c = 'Potential Negative';
                    break;
                }
                else{
                    
                    c.Customer_Prospect__c = 'Potential Positive';
                }
            }
            
        }
}
    }
}