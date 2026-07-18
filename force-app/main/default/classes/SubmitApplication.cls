@RestResource(urlMapping='/submitapplication/*')
global with sharing class SubmitApplication {
    @HttpPost
    global static void handleIncomingApplications() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            if (req.headers.get('Content-Type') == null || !req.headers.get('Content-Type').contains('application/json')) {
                res.statusCode = 415; // Unsupported Media Type
                res.responseBody = Blob.valueOf('{"error": "Unsupported Media Type. Expected application/json"}');
                return;
            }

            String jsonBody = req.requestBody.toString();
            String message = SubmitApplicationHelper.processApplications(jsonBody, 'Webhook');

            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"status": "success", "message": "' + message + '"}');
            
        } catch(Exception e) {
            // Handle errors
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"status": "error", "message": "' + e.getMessage() + '"}');
        }
    }
}