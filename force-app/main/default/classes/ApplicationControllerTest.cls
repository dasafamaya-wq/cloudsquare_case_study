/**
 * Test class for ApplicationController apex class
 */
@isTest
private class ApplicationControllerTest {
    @isTest
    static void submitAppError() {
        String jsonPayload = 'null';
        
        Test.startTest();
            try {
                ApplicationController.createApplication(jsonPayload);
                
                Assert.fail('An exception was expected but none was thrown.');
            } catch (Exception e) {
                Assert.areEqual('Script-thrown exception', e.getMessage(), 'Getting a different error message');
            }
		Test.stopTest();
    }
    
    @isTest
    static void submitAppSuccess() {
        String jsonPayload = '{"companyName": "Asaf LLC","contactFirstName": "Robert","contactLastName": "Doe","phone": "555-0189","email": "roberdoe@testing.com", "federalTaxId": "12345678", "annualRevenue": 135000}';
        
        Test.startTest();
        	ApplicationController.createApplication(jsonPayload);
		Test.stopTest();
    }
}