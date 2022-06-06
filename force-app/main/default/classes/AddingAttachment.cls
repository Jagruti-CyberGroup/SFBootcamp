public class AddingAttachment implements Queueable{
    
    private Messaging.InboundEmail email;
    private Campaign_case__c cas;
    public AddingAttachment(Messaging.InboundEmail email, Campaign_case__c cas) {
        this.email = email;
        this.cas = cas;
    }
    
    public void execute(QueueableContext context) {
        try {
            system.debug('Received Email:- '+email.Subject);
            EmailMessage createEmail = new EmailMessage(
                Subject                        = email.Subject
                
                //,Status                         = '2'
                ,FromAddress                    = email.fromAddress
                ,FromName                       = email.fromName
                ,Headers                        = JSON.serialize( email.headers )
                ,HtmlBody                       = email.htmlBody
                ,TextBody                       = email.plainTextBody
                //,Incoming                       = true
                ,MessageDate                    = DateTime.now()
                ,ToAddress						= 'jagrutiwagh@hotmail.com' //check with business what should be this address
                //,RelatedToId                    = cas.Id
                ,Market_Intelligence_Reports__c = cas.Id
            );
            // System.debug('RelatedtoId Email'+cas.Id);
            System.debug('Market_Intelligence_Reports__c '+cas.Id);
            
            insert createEmail;
            System.debug('Created Email'+createEmail.Id);
            System.debug('Created Subject'+createEmail.Subject);
            String emailHeader = JSON.serialize(email.headers); 
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
                
                system.debug('Content Version'+cvlist);
            }   
        }
        catch (Exception e) {
            System.debug('Email failed ' + e);
        } 
        
        /* List<ContentVersion>cvList = new List<ContentVersion>();


*/
        //}
        //  catch (Exception e) {
        //System.debug('Email failed ' + e);
        //}
        
        /* Attachment attachment = new Attachment();

*/
        
        
        //System.debug('Binary attachment'+email.binaryAttachments);
        //System.debug('Text attachment'+email.textAttachments);                                                      
        if(email.textAttachments != null)      {                                                
            for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                Attachment attachment = new Attachment();
                
                attachment.Name = tAttachment.fileName;
                //attachment.Name = tAttachment.fileName + '.msg';
                //Attachment.Name = attachmentname + '.msg'
                attachment.Body = Blob.valueOf(tAttachment.body);
                // attachment.Body = Blob.valueOf(emailHtml);
                // attachment.ParentId = con.Id;
                attachment.ParentId = cas.Id;
                insert attachment;
                System.debug('Text attachment'+attachment);
            }   
        }
        System.debug('Binary attachment'+email.binaryAttachments);
        if(email.binaryAttachments != null){                                                     
            for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                Attachment attachment = new Attachment();
                
                attachment.Name = bAttachment.fileName;
                // attachment.Name = bAttachment.fileName + '.eml';
                //Attachment.Name = attachmentname + '.msg'
                attachment.Body = bAttachment.body;
                // attachment.Body = Blob.valueOf(emailHtml);
                // attachment.Body = Blob.valueOf(emailText);
                // attachment.ParentId = con.Id;
                attachment.ParentId = cas.Id;
                insert attachment;
                
            } 
        }       
    }
    
}