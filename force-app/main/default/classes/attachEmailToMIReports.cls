global with sharing class attachEmailToMIReports implements Messaging.InboundEmailHandler  {
    //handler overwrite
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
         Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
                                                               
         String emailText = email.plainTextBody;
         String emailHtml = email.htmlBody;
                                                            
         Campaign_case__c cas = new Campaign_case__c();
         cas.Email__c = env.fromAddress;
         cas.New_Description__c = emailHtml;
         cas.Description__c = emailText;
         cas.Subject__c = email.subject; 
        
        
        system.debug('Email Message:- '+ email.messageId);
        system.debug('Email Message:- '+ email.textAttachments);
         Contact con = new Contact();
         try{
                                                                   
         List<Contact> conlist = [Select Id, name, email,AccountId,LastName from Contact where Email = :email.fromAddress LIMIT 1];
         if(conlist.size()>0){       //Checking if there is already a contact present in the org with the emailId email is sent
         System.debug('Inside if:');
         con = conlist[0];
         system.debug(email.subject);
         if(con != null){
         cas.Contact__c = con.Id;
         cas.Account__c = con.AccountId;
             
         }

        
         }
                                                                   
           else
           {
           System.debug('Inside else:');                                    //If no contact is available in the org with that email
           System.debug('Subject is :-'+email.subject);
           //If Subject does not contains FW
                                                                       
                                                                       
           
           con.Email = email.replyTo;
           String EM = email.replyTo;
           String split_first = EM.substring(0,EM.indexOf('@'));
           if(split_first != null){
           con.LastName = split_first;
                                                                       
           Database.insert(con);
           cas.Contact__c = con.Id;
           }
                                                                     
           }
            system.debug('Con50:-'+con);  
           retrieveCampaignId(emailHtml,cas);
           populatingCampaignName(cas,con);
             if(con.AccountId == null){
                 con.AccountId =cas.Account__c;
             }
           
           Database.update(con);
           system.debug('Contact Name:-'+con.LastName);
           Database.SaveResult sr = Database.insert(cas,false);
           if (sr.Success) {
           // Operation was successful, so get the ID of the record that was processed
           System.debug('Successfully inserted account. Account ID: ' + sr.getId());
           System.debug('Successfully inserted account. Account ID: ' + cas.Id);
           }
           else {
           cas.Campaign_Id__c = null;
           if(con.AccountId == null){
                 con.AccountId =cas.Account__c;
             }
           Database.update(con);
           
           Database.insert(cas);
           System.debug('The following error has occurred.'+ sr.getErrors());                    
           }
           }
           catch(QueryException e){
           System.debug('Exception Occurred: '+e.getMessage());
                                                                   
           }  
                                                                
                                                                
           try {



    
           if(email.binaryAttachments != null){
           List<ContentVersion>cvList = new List<ContentVersion>();
           List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
           for (Messaging.InboundEmail.BinaryAttachment binAttach : email.binaryAttachments) {
           ContentVersion testContentInsert = new ContentVersion();
           testContentInsert.Title = binAttach.fileName;
           testContentInsert.VersionData = binAttach.body;
           testContentInsert.PathOnClient = '/' + binAttach.fileName ;
           cvList.add(testContentInsert);
           system.debug('Added cvList');

           }
           insert cvList;
           cvList = [select id, ContentDocumentId from ContentVersion WHERE Id in :cvList];
           for (ContentVersion cv : cvList) {
           ContentDocumentLink cl = new ContentDocumentLink();
           cl.ContentDocumentId = cv.ContentDocumentId;
           system.debug(cas.Id);
           cl.LinkedEntityId = cas.Id; //Shared with record ID
           cl.ShareType = 'V';
           cl.Visibility = 'AllUsers';
           cdlList.add(cl);
           }
           insert cdlList;
           system.debug('Content Version'+cdlList);
           system.debug('Content Version'+cvlist);
           System.debug('Binary attachment'+email.binaryAttachments);
           }   
           }
           catch (Exception e) {
           System.debug('Email failed ' + e);
           } 

                                                               
                                                               result.success = true;
                                                               
                                                               return result;
                                                           }
    
    void populatingCampaignName(Campaign_case__c cas, Contact con){
        system.debug('Contact name:- '+ con.LastName);
        try{
                 List<Campaign> camplist = [Select Id, name from Campaign where Id = :cas.Campaign_Id__c LIMIT 1];
             Campaign camp = camplist[0];
             
             if(camp != null){
             cas.Name = con.LastName+'-'+camp.Name;
             }
             else{
                cas.Name = con.LastName;
             }
             }
             catch(exception e){
                 cas.Name = con.LastName;
                 
             }
        system.debug('CampaignCase Name:- '+cas.Name);
    }
        String parseContact(XmlStreamReader reader) {
        String Email1 = '';
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            else if (reader.getEventType() == XmlTag.CHARACTERS) {
                Email1 = reader.getText();
            }
            
            reader.next();
        }
        
        return Email1;
    }
    String parseSpan(XmlStreamReader reader) {
        String CampId = '';
        
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            }
            else if (reader.getEventType() == XmlTag.CHARACTERS) {
                CampId = reader.getText();
            }
            
            reader.next();
        }
        
        return CampId;
    }
    void retrieveCampaignId(String emailHtml,Campaign_case__c cas){
        string src= '<!DOCTYPE html [<!ENTITY nbsp " ">]>'+emailHtml;
        String[] values = new String[0];
        src=src.replaceAll('<(br|hr)>','');
        src=src.replaceAll('<meta','');
        src=src.replaceAll('<img','');
        src=src.replaceAll('<hr','');
        //System.debug(System.loggingLevel.Error,src);
        XmlStreamReader r = new XmlStreamReader(src);
        // parseParas(r);
        
        
        
        try{
            while(r.hasNext()) {
                if (r.getEventType() == XmlTag.START_ELEMENT) {
                    
                    
                    
                    if (r.getLocalName() == 'h6' || r.getLocalName() == 'div') {
                        
                        
                        system.debug('first Attribute count:-'+r.getAttributeCount());
                                     
                        system.debug('first Attribute count:-'+r.getAttributeLocalName(0));
                        system.debug('first Attribute count:-'+r.getAttributeValue('', 'id'));
                        String SomeId = r.getAttributeValue('', 'id');
                        //system.debug('Does it contains id:- '+ SomeId.contains('cgCampaignIdHidden'));
                        
                        
                        if(SomeId.contains('cgCampaignIdHidden') == true){
                           string CampaignId_m =  parseSpan(r);
                        system.debug('Required Id is :- ' + CampaignId_m);
                        
                        cas.Campaign_Id_2__c = CampaignId_m;
                        cas.Campaign_Id__c = CampaignId_m; 
                        }
                        
                        if(SomeId.contains('divRplyFwdMsg') == true){
                            string CampaignId_m =  parseSpan(r);
                            system.debug('Required Id is :- ' + CampaignId_m);
                            
                        }
                        
                        
                        
                        if(SomeId.contains('cgprimaryContactIdHidden') == true){
                        system.debug('Come here');
                          String Email2 = parseContact(r); 
                            system.debug('Required Email is :- ' + Email2);
                            
                            try{
                            List<Contact> conlist2 = [Select Id, name ,AccountId from Contact where ID = : Email2 LIMIT 1];
                             system.debug('Cont:-'+conlist2);   
                                
                             Contact con2 = conlist2[0];
                                if(con2!=null){
                                 
                                    if(cas.Account__c == null){
                                        cas.Primary_Contact__c = con2.Id;
                                        system.debug('Primary Contact is:- '+cas.Primary_Contact__c);
                                cas.Account__c = con2.AccountId;
                                        system.debug('Primary Account is:- '+cas.Account__c);
                                    }
                                }
                            }
                            catch(StringException e){
                                system.debug('Exception is:- '+ e);
                            }
                        }
                        
                    }
                }
                r.next();
            }
        }
        catch(exception e){
            system.debug(e);
        }
    }
}