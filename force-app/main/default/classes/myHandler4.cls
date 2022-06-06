global class myHandler4 implements Messaging.InboundEmailHandler {
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
           /*   for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
            Attachment attachment = new Attachment();

              attachment.Name = tAttachment.fileName;
               //attachment.Name = tAttachment.fileName + '.msg';
                //Attachment.Name = attachmentname + '.msg'
               // attachment.Body = Blob.valueOf(tAttachment.body);
                attachment.Body = Blob.valueOf(emailHtml);
                attachment.ParentId = con.Id;
                attachment.ParentId = cas.Id;
                insert attachment;
            }*/
              Attachment attachment = new Attachment();

              attachment.Name = 'Email.html';
               //attachment.Name = tAttachment.fileName + '.msg';
                //Attachment.Name = attachmentname + '.msg'
               // attachment.Body = Blob.valueOf(tAttachment.body);
                attachment.Body = Blob.valueOf(emailHtml);
               
                attachment.ParentId = cas.Id;
                insert attachment;
              
              ContentVersion doc = new ContentVersion();
              doc.ContentLocation = 'S';
              doc.PathOnClient = 'Email.msg';
              doc.Title = 'Email.msg';
              Blob textData = Blob.valueOf(emailHtml);
              doc.VersionData = textData;
             
              insert doc;
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