@isTest
public class CampaignCaseTestClass {
    
    public static testMethod void testingCampaignCas(){
        // Create a new email and envelope object (Mandatory)
        Messaging.InboundEmail email  = new Messaging.InboundEmail(); //Creating email
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope(); // Creating envelop
        
        
        Account account = new Account();
        account.Name = 'CG1AccountTest';
        insert account;
        Campaign Campaign1 = new Campaign();
        Campaign1.Name = 'Champion';
        
        insert Campaign1;
        email.plainTextBody = 'This should become description';  //Description
        email.htmlBody = '<html><body><b><h6 id="cgCampaignIdHidden" style="display:none">'+Campaign1.Id+'</h6><h6 id="cgprimaryContactIdHidden" style="display:none">wagh.jagruti89@gmail.com</h6></b></body></html>';
        email.fromAddress = 'test@test.com';  // email address
        email.replyTo = 'test@test.com';       
        email.subject = 'Dummy Subject';          //Subject 
        
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();  //Attachment
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            
            // add an Text atatchment
            
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
            
            
            
            
        attachEmailToMIReports edr = new attachEmailToMIReports();
        
        Test.startTest();
        // pass email & enveloper object as parameters here
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Test.stopTest();
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
        Campaign_case__c [] Camp_cas = [select ID ,Description__c from Campaign_case__c where Subject__c=:email.subject LIMIT 1];
        system.assertEquals(1, Camp_cas.size());
        system.assertEquals('This should become description', Camp_cas[0].Description__c);
        //system.assertEquals(1, Camp_cas.size());
        //Contact [] cont = [select firstname,lastname from Contact where email=:email.fromAddress];
        //system.assertEquals(1, cont.size());
    } 
    
    
    
    
    public static testMethod void testingCampaignCasHavingContact(){
        // Create a new email and envelope object (Mandatory)
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        
        email.plainTextBody = 'This should become description';  //Description
        email.htmlBody = '<html><body><b><h6 id="cgCampaignIdHidden" style="display:none">7018B0000005CvGQAU</h6><h6 id="cgprimaryContactIdHidden" style="display:none">wagh.jagruti89@gmail.com</h6></b></body></html>';
        email.fromAddress = 'test@test.com';  // email address
        email.replyTo = 'test@test.com';       
        email.subject = 'Dummy Subject';          //Subject 
        
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();  //Attachment
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            
            // add an Text atatchment
            
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
        
        Account account = new Account();
        account.Name = 'CG1AccountTest';
        insert account;
        
        Contact Pcontact = new Contact();
        Pcontact.LastName = 'LastTestName';
        Pcontact.Email = 'wagh.jagruti89@gmail.com';
        Pcontact.AccountId = account.Id;
        insert Pcontact;
        
        Contact contact = new Contact();
        contact.Salutation = 'Mr.'; 
        contact.AccountId = account.Id;
        contact.FirstName = 'Test1';
        contact.LastName = 'Test2';   
        contact.Email =  'test1@test.com';
        insert contact;    
        email.plainTextBody = 'This should become description';
        email.fromAddress = 'test1@test.com';
        email.subject = 'Dummy Subject2';
        

        
        attachEmailToMIReports edr = new attachEmailToMIReports();
        
        Test.startTest();
        // pass email & enveloper object as parameters here
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Test.stopTest();
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
        Campaign_case__c [] Camp_cas = [select ID ,Primary_Contact__c,Account__c,Description__c from Campaign_case__c where Subject__c=:email.subject LIMIT 1];
        Campaign_case__c CampCas = Camp_cas[0];
        system.assertEquals(1, Camp_cas.size());
        system.assertEquals('This should become description', CampCas.Description__c);
        system.assertEquals(null, CampCas.Primary_Contact__c);
        system.assertEquals(account.Id, CampCas.Account__c);
        //system.assertEquals(1, Camp_cas.size());
        Contact [] cont = [select firstname,lastname from Contact where email=:email.fromAddress];
        system.assertEquals(1, cont.size());
        system.debug(cont);
    } 
    public static testMethod void testingCampaignCasNotHavingContact(){
        // Create a new email and envelope object (Mandatory)
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Account account = new Account();
        account.Name = 'CG1AccountTest';
        insert account;
        
        Contact contact = new Contact();
        contact.LastName = 'LastTestName';
        contact.Email = 'wagh.jagruti89@gmail.com';
        contact.AccountId = account.Id;
        insert contact;
        
        Campaign Campaign1 = new Campaign();
        Campaign1.Name = 'Champion';
        insert Campaign1;
        
        
        
        email.plainTextBody = 'This should become description';
        email.htmlBody = '<html><body><b><h6 id="cgCampaignIdHidden" style="display:none">'+Campaign1.Id+'</h6><h6 id="cgprimaryContactIdHidden" style="display:none">wagh.jagruti89@gmail.com</h6></b></body></html>';
        email.fromAddress = 'test@test.com';
        email.replyTo = 'test@test.com';
        email.subject = 'FW:-Dummy Subject';
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();  //Attachment
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfileone.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
            
            
            // add an Text atatchment
            
        Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
        attachmenttext.body = 'my attachment text';
        attachmenttext.fileName = 'textfiletwo3.txt';
        attachmenttext.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };        
        attachEmailToMIReports edr = new attachEmailToMIReports();
        
        Test.startTest();
        // pass email & enveloper object as parameters here
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Test.stopTest();
        
        //System.assert (result.success, 'InboundEmailResult returned a failure message');
        
        Campaign_case__c [] Camp_cas = [select ID ,Primary_Contact__c,Account__c,Description__c from Campaign_case__c where Subject__c=:email.subject LIMIT 1];
        Campaign_case__c CampCas = Camp_cas[0];
        system.assertEquals(1, Camp_cas.size());
        system.assertEquals('This should become description', CampCas.Description__c);
        system.assertEquals(contact.Id, CampCas.Primary_Contact__c);
        system.assertEquals(account.Id, CampCas.Account__c);
        system.assertEquals(contact.AccountId, CampCas.Account__c);
        
        
        //system.assertEquals(1, Camp_cas.size());
        //Contact [] cont = [select firstname,lastname from Contact where email=:email.fromAddress];
        //system.assertEquals(1, cont.size());
    }
}