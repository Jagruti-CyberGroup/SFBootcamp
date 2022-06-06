trigger UpdateCotaact on CampaignMember (before insert)
{


    set<id>contactids=new set<id>();
    contact cont;
    for(campaignmember cam:trigger.new)
    {
    
      contactids.add(cam.ContactId);  
        
    } 
//Map<id, contact> contacts = new map<id, contact>([select id,Description,createddate,name from contact where id in:contactids ORDER BY CreatedDate DESC limit 1]);
Map<id, contact> contacts = new map<id, contact>([select id,New_Campaign_Id_2__c,Description,name from contact where id in:contactids]);
    
    //Map<Id,Campaignmember>stat=new Map<Id,Campaignmember>([select id,contactid,campaignid from Campaignmember where contactid in:contactids]); 
    
//Map<id, contact> contact1 = new map<id, contact>([select id,Description,createddate,name from contact where id in:contactids order by createddate desc limit 1]);    
 
       
    for(Campaignmember bolly:trigger.new)
    {
        
       contact cont=contacts.get(bolly.ContactId);
       //if(cont.New_Campaign_Id_1__c==null)
       {
       cont.New_Campaign_Id_2__c=bolly.CampaignId;
       update cont; 
       }
    }
    /*
Map<id,contact> contact1 = new map<id,contact>([select id,name from contact where id in:contactids]);    
     
    for(Campaignmember bolly1:trigger.new)
    {
        
       contact contra=contact1.get(bolly1.ContactId);
       
       
   
       
      
         
       contra.Most_Recent_Campaign__c=bolly1.CampaignId;
   
       update contra; 
       } */
        
    }