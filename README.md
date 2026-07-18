# cloudsquare_case_study
Author: Asaf Amaya

Installation Guide: 

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
