/**
 * Apex class to cover tests for SubmitApplication and SubmitApplicationHelper apex classes.
 */
@isTest
private class SubmitApplicationTest {
    @isTest
    static void submitAppNotJSONError() {
        String jsonPayload = '[{"companyName": "Krimea LLC","contactFirstName": "John","contactLastName": "Doe","phone": "555-0199","email": "krimea@testing.com", "federalTaxId": "", "annualRevenue": "135000"}]';
        
        createPostRequest(jsonPayload, false);

        Test.startTest();
            SubmitApplication.handleIncomingApplications();
        Test.stopTest();
        
        //System.debug('*** response: ' + response);
    }
    
    @isTest
    static void submitAppError() {
        String jsonPayload = 'null';
        
        RestResponse response = createPostRequest(jsonPayload, true);

        Test.startTest();
            SubmitApplication.handleIncomingApplications();
        Test.stopTest();
        
        System.assertEquals(500, response.statusCode, 'Status Code is different from 500');
    }
    
    @isTest
    static void submitAppOppByTaxIdSuccess() {
        createAccount();
        String jsonPayload = '[{"companyName": "Asaf LLC","contactFirstName": "Robert","contactLastName": "Doe","phone": "555-0189","email": "roberdoe@testing.com", "federalTaxId": "12345678", "annualRevenue": 135000}]';
        
        RestResponse response = createPostRequest(jsonPayload, true);

        Test.startTest();
            SubmitApplication.handleIncomingApplications();
        Test.stopTest();
        
        System.assertEquals(200, response.statusCode, 'Status Code is different from 200');
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        System.assertEquals(1, oppList.size(), 'Opportunity was not created');
    }
    
    @isTest
    static void submitAppOppByNameSuccess() {
        createAccount();
        String jsonPayload = '[{"companyName": "Asaf LLC","contactFirstName": "Robert","contactLastName": "Doe","phone": "555-0189","email": "roberdoe@testing.com", "federalTaxId": "", "annualRevenue": 135000}]';
        
        RestResponse response = createPostRequest(jsonPayload, true);

        Test.startTest();
            SubmitApplication.handleIncomingApplications();
        Test.stopTest();
        
        System.assertEquals(200, response.statusCode, 'Status Code is different from 200');
        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        System.assertEquals(1, oppList.size(), 'Opportunity was not created');
    }
    
    @isTest
    static void submitAppLeadSuccess() {
        String jsonPayload = '[{"companyName": "Asaf LLC","contactFirstName": "Robert","contactLastName": "Doe","phone": "555-0189","email": "roberdoe@testing.com", "federalTaxId": "12345678", "annualRevenue": 135000}]';
        
        RestResponse response = createPostRequest(jsonPayload, true);

        Test.startTest();
            SubmitApplication.handleIncomingApplications();
        Test.stopTest();
        
        System.assertEquals(200, response.statusCode, 'Status Code is different from 200');
        List<Lead> leadList = [SELECT Id FROM Lead];
        System.assertEquals(1, leadList.size(), 'Lead was not created');
    }

    private static void createAccount(){
        Account acc = new Account(Name = 'Asaf LLC', Federal_Tax_ID__c = '12345678');
        insert acc;
    }
    
    private static RestResponse createPostRequest(String jsonPayload, Boolean jsonFormat){
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.requestURI = '/services/apexrest/submitapplication/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(jsonPayload);
        if(jsonFormat){
            request.addHeader('Content-Type', 'application/json');
        }
        
        RestContext.request = request;
        RestContext.response = response;
        
        return response;
    }
}