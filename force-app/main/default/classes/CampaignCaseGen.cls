public class CampaignCaseGen {
    //first commit from CampaignCaseGen class
    /*private Campaign_case__c cas;
    private Messaging.InboundEmail email;
    private Messaging.InboundEnvelope env;
    private String emailText;
    private String emailHtml;
    public CampaignCaseGen(Campaign_case__c cas,Messaging.InboundEmail email,String emailText,String emailHtml,Messaging.InboundEnvelope env){
        this.cas = cas;
        this.email = email;
        this.emailText = emailText;
        this.emailHtml = emailHtml;
        this.env = env;
    }
    
    public void execute(QueueableContext context) {
        
        try{
            
            List<Contact> conlist = [Select Id, name, email from Contact where Email = :email.fromAddress LIMIT 1];
            if(conlist.size()>0){
                System.debug('Inside if:');
                Contact con = conlist[0];
                cas.Email__c = env.fromAddress;
                
                cas.New_Description__c = emailHtml;
                cas.Description__c = emailText;
                
                //system.debug('Description:- '+cas.New_Description__c);
                //system.debug('Description:- '+cas.Description__c);
                cas.Subject__c = email.subject;
                system.debug(email.subject);
                
                if(con != null){
                    cas.Contact__c = con.Id;
                }
                
                System.debug('Start of HTML Parsing code:');
                string src= '<!DOCTYPE html [<!ENTITY nbsp " ">]>'+emailHtml;
                String[] values = new String[0];
                src=src.replaceAll('<(br|hr)>','');
                src=src.replaceAll('<meta','');
                src=src.replaceAll('<img','');
                src=src.replaceAll('<hr','');
                //System.debug(System.loggingLevel.Error,src);
                XmlStreamReader r = new XmlStreamReader(src);
                // parseParas(r);
                Integer retry = 0;
                Boolean inRow = false, inCol = false;
                
                
                try{
                    while(r.hasNext()) {
                        if (r.getEventType() == XmlTag.START_ELEMENT) {
                            if (r.getLocalName() == 'h6') {
                                
                                string CampaignId_m =  parseCell(r);
                                system.debug('Required Id is :- ' + CampaignId_m);
                                // cas.Campaign_Id__c =  CampaignId_m;
                                // system.debug('Campaign Id :- ' + cas.Campaign_Id__c);
                                cas.Campaign_Id_2__c = CampaignId_m;
                                cas.Campaign_Id__c = CampaignId_m;
                            }
                        }
                        r.next();
                    }
                }
                catch(exception e){
                    system.debug(e);
                }
                System.debug('End of HTML Parsing code:');
                
                
                
                
                
                
                insert cas;
                //  String SUBJECT_OUT_OF_OFFICE = 'Automatic reply';
                // String TEXT_BODY_OUT_OF_OFFICE = 'out of the office';
                
                
                
                //  System.debug('New Campaign case Object: ' + cas );  
                System.debug('New Campaign case id is : ' + cas.id );  
                
            }
            
            else
            {
                System.debug('Inside else:');
                
                System.debug('Subject is :-'+email.subject);
                
                if(email.subject.startsWith('FW')){
                    
                    System.debug('Inside FW');
                    List<Campaign_case__c> cas1 = [Select Id, Subject__c, Email__c, Description__c , New_Description__c From Campaign_case__c Where Email__c =: env.fromAddress order by CreatedDate DESC Limit 1];
                    system.debug('Size of List :-'+ cas1.size());
                    system.debug('cas1 is :- '+cas1);
                    If(cas1.size() > 0){
                        cas = cas1[0];
                        system.debug('Cas :-'+ cas.Id);
                        cas.Email__c = env.fromAddress;
                        cas.New_Description__c = emailHtml;
                        cas.Description__c = emailText;
                        cas.Subject__c = email.subject;
                        
                        
                        System.debug('Start of HTML Parsing code:');
                        string src= '<!DOCTYPE html [<!ENTITY nbsp " ">]>'+emailHtml;
                        String[] values = new String[0];
                        src=src.replaceAll('<(br|hr)>','');
                        src=src.replaceAll('<meta','');
                        src=src.replaceAll('<img','');
                        src=src.replaceAll('<hr','');
                        //System.debug(System.loggingLevel.Error,src);
                        XmlStreamReader r = new XmlStreamReader(src);
                        // parseParas(r);
                        Integer retry = 0;
                        Boolean inRow = false, inCol = false;
                        
                        
                        try{
                            while(r.hasNext()) {
                                if (r.getEventType() == XmlTag.START_ELEMENT) {
                                    if (r.getLocalName() == 'h6') {
                                        
                                        string CampaignId_m =  parseCell(r);
                                        system.debug('Required Id is :- ' + CampaignId_m);
                                        // cas.Campaign_Id__c =  CampaignId_m;
                                        // system.debug('Campaign Id :- ' + cas.Campaign_Id__c);
                                        cas.Campaign_Id_2__c = CampaignId_m;
                                        cas.Campaign_Id__c = CampaignId_m;
                                    }
                                }
                                r.next();
                            }
                        }
                        catch(exception e){
                            system.debug(e);
                        }
                        System.debug('End of HTML Parsing code:');
                        //update cas;
                        system.debug('Cas Generated : '+cas);
                    }
                    else{
                        System.debug('Inside if cas1 size is zero');
                        cas.Email__c = env.fromAddress;
                        cas.New_Description__c = emailHtml;
                        cas.Description__c = emailText;
                        cas.Subject__c = email.subject;
                        System.debug('Start of HTML Parsing code:');
                        string src= '<!DOCTYPE html [<!ENTITY nbsp " ">]>'+emailHtml;
                        String[] values = new String[0];
                        src=src.replaceAll('<(br|hr)>','');
                        src=src.replaceAll('<meta','');
                        src=src.replaceAll('<img','');
                        src=src.replaceAll('<hr','');
                        //System.debug(System.loggingLevel.Error,src);
                        XmlStreamReader r = new XmlStreamReader(src);
                        // parseParas(r);
                        Integer retry = 0;
                        Boolean inRow = false, inCol = false;
                        
                        
                        try{
                            while(r.hasNext()) {
                                if (r.getEventType() == XmlTag.START_ELEMENT) {
                                    if (r.getLocalName() == 'h6') {
                                        
                                        string CampaignId_m =  parseCell(r);
                                        system.debug('Required Id is :- ' + CampaignId_m);
                                        // cas.Campaign_Id__c =  CampaignId_m;
                                        // system.debug('Campaign Id :- ' + cas.Campaign_Id__c);
                                        cas.Campaign_Id_2__c = CampaignId_m;
                                        cas.Campaign_Id__c = CampaignId_m;
                                    }
                                }
                                r.next();
                            }
                        }
                        catch(exception e){
                            system.debug(e);
                        }
                        System.debug('End of HTML Parsing code:');
                        insert cas;
                        system.debug('Cas INsert generated'+cas);
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }
                else{
                    System.debug('Inside if subject does not contains FW');
                    cas.Email__c = env.fromAddress;
                    cas.New_Description__c = emailHtml;
                    cas.Description__c = emailText;
                    cas.Subject__c = email.subject;
                    System.debug('Start of HTML Parsing code:');
                    string src= '<!DOCTYPE html [<!ENTITY nbsp " ">]>'+emailHtml;
                    String[] values = new String[0];
                    src=src.replaceAll('<(br|hr)>','');
                    src=src.replaceAll('<meta','');
                    src=src.replaceAll('<img','');
                    src=src.replaceAll('<hr','');
                    //System.debug(System.loggingLevel.Error,src);
                    XmlStreamReader r = new XmlStreamReader(src);
                    // parseParas(r);
                    Integer retry = 0;
                    Boolean inRow = false, inCol = false;
                    
                    
                    try{
                        while(r.hasNext()) {
                            if (r.getEventType() == XmlTag.START_ELEMENT) {
                                if (r.getLocalName() == 'h6') {
                                    
                                    string CampaignId_m =  parseCell(r);
                                    system.debug('Required Id is :- ' + CampaignId_m);
                                    // cas.Campaign_Id__c =  CampaignId_m;
                                    // system.debug('Campaign Id :- ' + cas.Campaign_Id__c);
                                    cas.Campaign_Id_2__c = CampaignId_m;
                                    cas.Campaign_Id__c = CampaignId_m;
                                }
                            }
                            r.next();
                        }
                    }
                    catch(exception e){
                        system.debug(e);
                    }
                    System.debug('End of HTML Parsing code:');
                    insert cas;
                    
                } 
            } 
        }
        catch(QueryException e){
            System.debug('Exception Occurred: '+e.getMessage());
            // Campaign_case__c cas = new Campaign_case__c();
            
        }
        System.enqueueJob(new AddingAttachment(email,cas));
    }
    
    String parseCell(XmlStreamReader reader) {
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
    }*/
}