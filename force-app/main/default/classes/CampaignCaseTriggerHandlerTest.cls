@isTest
public class CampaignCaseTriggerHandlerTest {
    @isTest
    public static void CheckCustomerProspectIfPositive(){
        Campaign_Case__c CampaignCase = new Campaign_Case__c();
        CampaignCase.Description__c = 'I am interested';
        
        
        Test.startTest();
        insert CampaignCase;
        Test.stopTest();
        Campaign_Case__c CamCas = [select Customer_Prospect__c FROM Campaign_Case__c Where Id =: CampaignCase.Id];
        system.assertEquals('Potential Positive',CamCas.Customer_Prospect__c);
    }
        @isTest
        public static void CheckCustomerProspectIfNegative(){
        Campaign_Case__c CampaignCase = new Campaign_Case__c();
        CampaignCase.Description__c = 'I am not interested';
        
        
        Test.startTest();
        insert CampaignCase;
        Test.stopTest();
        
        Campaign_Case__c CamCas = [select Customer_Prospect__c FROM Campaign_Case__c Where Id =: CampaignCase.Id];
        system.assertEquals('Potential Negative',CamCas.Customer_Prospect__c);            
    }
}