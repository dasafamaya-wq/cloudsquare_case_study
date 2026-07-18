import { LightningElement, track } from 'lwc';
import createApplication from '@salesforce/apex/ApplicationController.createApplication';

export default class ApplicationForm extends LightningElement {
    @track isSaving = false;
    @track isSuccess = false;
    @track error;

    handleSubmit() {
        // 1. Validate required inputs
        const allValid = [
            ...this.template.querySelectorAll('[data-id="req-field"]')
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        if (!allValid) {
            return;
        }

        this.isSaving = true;
        this.isSuccess = false;
        this.error = undefined;

        // 2. Gather data into a JavaScript Object
        const applicationData = {};
        const inputs = this.template.querySelectorAll('lightning-input');
        
        inputs.forEach(input => {
            if(input.name && input.value === '' && input.type == 'number'){
                applicationData[input.name] = null;
            }
            else if (input.name) {
                applicationData[input.name] = input.value;
            }
        });

        // 3. Serialize to JSON
        const jsonPayload = JSON.stringify(applicationData);

        // 4. Send to Apex
        createApplication({ applicationJson: jsonPayload })
            .then(() => {
                this.isSuccess = true;
                this.template.querySelectorAll('lightning-input').forEach(input => input.value = '');
            })
            .catch(error => {
                console.error(error);
                this.error = error.body ? error.body.message : error.message;
            })
            .finally(() => {
                this.isSaving = false;
            });
    }
}
