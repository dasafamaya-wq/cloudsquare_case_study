# cloudsquare_case_study
Author: Asaf Amaya

Installation Guide: 

Pre Deployment Steps: 
1. On setup > sharing settings, set the External Access for Account as Public Read Only

One thing you need is to have your VS Code connected to your org before installation. Then you may proceed with one of the following options. 

FIRST Option:
- If you have already a project created in your VS Code you may replace the default content on your project with the content from this repository and deploy it to your org. (force-app > main > default)

SECOND OPTION: 
- Also, if you have a project created you can just copy the Apex Classes, LWC, Sharing Rules, Object (Account, Opportunity, and Lead fields), and global value set and deploy it to your org.

THIRD OPTION: Replace the main folder of your project with the one here on this repository and you may use the manifest to deploy everything included here to the org. 

Post Deployment steps: 
1. Create a site on setup > sites with the following details:
     - Site Label: Submit Application
     - Site Name: submitApplication
     - Active: Checked
2. Once the site is created, Click on Published Access Settings and perform the following:
     - Grant Read access to the Account. Also grant access to the Federal Tax ID field.
     - Grant Read/Write access to Opportunity. You may need to grant access to the Application Origin field.
     - Grant Read/Write access to Lead. You may need to grant access to the Application Origin and Federal Tax ID field.
     - Also, grant access to the SubmitApplication and SubmitApplicationHelper apex classes.


Overall Design 
 - For Leads Creation, the object will have a field to store the Federal Tax ID in case it's provided by the user.
 - A global value set was created to store the two possible origins (Community or Webhook) and that is being used by two picklist, one on the lead side and the other one on the opportunity side. In case we need to add more origins we can just add it to the global value set and will be available for both.
 - The lightning web component may be used on a experience page and will be displaying the fields required and optional. Once the form is populated and the record is created, fields are blank and user can create more records.
 - As per now, the sharing rule only has the validation when Name is not blank but we can modify and add more rules if needed.
 - Apex has the String.escapeSingleQuotes for SOQL/SOSL injection.

What's missing?
- Fields may be added to any page layout or lightning page.
- Permissions can be granted to any needed profile or Permission sets to the new fields being created
- No site is included with the LWC

Notes: No chatgpt, no claude, agentforce vibes was used to solved this but Google search. ;) 

Feel free to provide any feedback. We can always learn! :) 
