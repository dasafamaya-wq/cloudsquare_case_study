public with sharing class ApplicationController {
    @AuraEnabled
    public static void createApplication(String applicationJson) {
        try {
            SubmitApplicationHelper.processApplications('['+ applicationJson + ']', 'Community');
        } catch (Exception e) {
            throw new AuraHandledException('Error creating application: ' + e.getMessage());
        }
    }
}