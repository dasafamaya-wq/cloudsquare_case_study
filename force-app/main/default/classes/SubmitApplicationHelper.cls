public with sharing class SubmitApplicationHelper {
    public static String processApplications(String jsonBody, String originSource){
        List<ApplicationDTO> applicationsToProcess = (List<ApplicationDTO>)JSON.deserialize(jsonBody, List<ApplicationDTO>.class);

        if(applicationsToProcess.size() > 0){
            List<Lead> leadsToInsert = new List<Lead>();
            Map<String, ApplicationDTO> fedTaxIdAppMap = new Map<String, ApplicationDTO>();
            Map<String, ApplicationDTO> companyNameAppMap = new Map<String, ApplicationDTO>();
            
            for (ApplicationDTO app : applicationsToProcess) {
                if (String.isNotBlank( String.escapeSingleQuotes(app.federalTaxId) )) {
                    fedTaxIdAppMap.put( String.escapeSingleQuotes(app.federalTaxId), app);
                } else if (String.isNotBlank( String.escapeSingleQuotes(app.companyName) )) {
                    companyNameAppMap.put( String.escapeSingleQuotes(app.companyName), app);
                }
            }

            List<Opportunity> oppsToInsert = validateateOppsLeads(fedTaxIdAppMap, companyNameAppMap, originSource);

            List<ApplicationDTO> appDTOMissingList = new List<ApplicationDTO>();
            appDTOMissingList.addAll(fedTaxIdAppMap.values());
            appDTOMissingList.addAll(companyNameAppMap.values());

            if(!appDTOMissingList.isEmpty()){
                for(ApplicationDTO app : appDTOMissingList){
                    leadsToInsert.add(populateLead(app, originSource));
                }
            }

            // Insert records
            if (!oppsToInsert.isEmpty()) {
                insert oppsToInsert;
            }
            if (!leadsToInsert.isEmpty()) {
                insert leadsToInsert;
            }
            return 'Data processed successfully!';
        }
        else{
            return 'There are no applications to process.';
        }
    }

    private static List<Opportunity> validateateOppsLeads(
        Map<String, ApplicationDTO> fedTaxIdAppMap, 
        Map<String, ApplicationDTO> companyNameAppMap, String originSource
    ) {
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        for(Account acc : [SELECT Id, Name, Federal_Tax_ID__c FROM Account WHERE Federal_Tax_ID__c IN :fedTaxIdAppMap.keySet() OR Name IN :companyNameAppMap.keySet()]){
            if(fedTaxIdAppMap.containsKey(acc.Federal_Tax_ID__c)){
                ApplicationDTO app = fedTaxIdAppMap.get(acc.Federal_Tax_ID__c);
                oppsToInsert.add(populateOpp(app, acc, originSource));
                fedTaxIdAppMap.remove(acc.Federal_Tax_ID__c);
            } else if(companyNameAppMap.containsKey(acc.Name)){
                ApplicationDTO app = companyNameAppMap.get(acc.Name);
                oppsToInsert.add(populateOpp(app, acc, originSource));
                companyNameAppMap.remove(acc.Name);
            }
        }
        return oppsToInsert;
    }

    private static Opportunity populateOpp(ApplicationDTO app, Account acc, String originSource){
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.Name = acc.Name + ' - ' + System.today()+ ' - ' + originSource;
        o.StageName = 'Prospecting';
        o.CloseDate = System.today().addDays(30);
        o.Application_Origin__c = originSource;

        return o;
    }

    private static Lead populateLead(ApplicationDTO app, String originSource){
        return new Lead(
                        Company = app.companyName,
                        FirstName =app.contactFirstName,
                        LastName = app.contactLastName,
                        Email = app.email,
                        Phone = app.phone,
                        Application_Origin__c = originSource, 
                        Federal_Tax_ID__c = app.federalTaxId, 
                        AnnualRevenue = app.annualRevenue);
    }
    
	public class ApplicationDTO {
        public String companyName;
        public String email;
        public String phone;
        public String contactFirstName;
        public String contactLastName;
        public String federalTaxId;
        public Decimal annualRevenue;
    }
}