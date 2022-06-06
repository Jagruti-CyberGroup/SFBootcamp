global class myHandlerV2 implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		  Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          String emailText = ' ';
          String emailHtml = ' ';
          
          emailText = email.plainTextBody;
          emailHtml = email.htmlBody;
          try{
              Contact con = [Select Id, name, email from Contact where Email = :email.fromAddress LIMIT 1];
              Campaign_case__c cas = new Campaign_case__c();
              cas.Email__c = envelope.fromAddress;
              cas.New_Description__c = emailHtml;
              cas.Description__c = emailText;
              cas.Subject__c = email.subject;
              cas.Contact__c = con.Id;
              
         	   insert cas;
          
          
          System.debug('New Campaign case Object: ' + cas );
            /*  for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
            Attachment attachment = new Attachment();

              //attachment.Name = tAttachment.fileName;
               attachment.Name = tAttachment.fileName + '.msg';
                //Attachment.Name = attachmentname + '.msg'
                //attachment.Body = Blob.valueOf(tAttachment.body);
               attachment.Body = Blob.valueOf(emailHtml);
                attachment.ParentId = con.Id;
                attachment.ParentId = cas.Id;
                insert attachment;
                  System.debug('New Campaign case Object: ' + attachment );
            }  */
              
             // Messaging.InboundEmailResult result2 = new Messaging.InboundEmailResult();
String myPlainText= '';
myPlainText = email.plainTextBody;
Integer i = myPlainText.indexOf('ref:',0);                                                   
//String objectId = myPlainText.substring(i+5, i+20);
//System.debug('recordId '+objectId);
     try {
        EmailMessage            createEmail = new EmailMessage(
             Subject                        = email.Subject
            ,Status                         = '2'
            ,FromAddress                    = email.fromAddress
            ,FromName                       = email.fromName
            ,Headers                        = JSON.serialize( email.headers )
            ,HtmlBody                       = email.htmlBody
            ,TextBody                       = email.plainTextBody
            ,Incoming                       = true
            ,MessageDate                    = DateTime.now()
            ,RelatedToId                    = cas.Id
           // ,Market_Intelligence_Reports__c = cas.Id;
        );
        insert createEmail;
        System.debug('Created Email'+createEmail.Id);

      /*  List<ContentVersion>cvList = new List<ContentVersion>();
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
          cl.LinkedEntityId = createEmail.Id; //Shared with record ID
          cl.ShareType = 'V';
          cl.Visibility = 'AllUsers';
         cdlList.add(cl);
}
insert cdlList;
         system.debug('insert cdlList'+objectId);
         system.debug('Content Version'+cvlist);
*/ }
catch (Exception e) {
    System.debug('Email failed ' + e);
}
              
      }
          catch(QueryException e){
          System.debug('Exception Occurred: '+e);
          Campaign_case__c cas = new Campaign_case__c();
          cas.Email__c = envelope.fromAddress;
          cas.New_Description__c = emailHtml;
          cas.Description__c = emailText;
          cas.Subject__c = email.subject;
          insert cas;
              
          System.debug('New Campaign case Object: ' + cas );
          }
          result.success=true;
          return result;
         
      }
    
  }