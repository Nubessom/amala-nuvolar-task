import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveFlight from '@salesforce/apex/NU_CreateFlightController.saveFlight';

export default class Nu_createFlight extends LightningElement {
    @track isLoading = false;
    @track recordId;
    originIATACode;
    destinationIATACode;


    matchingInfo = {
        primaryField: { fieldPath: 'NU_IATA_Code__c' },
        additionalFields: [{ fieldPath: 'Name' }],
    };

    handleOriginSelect(event) {
        this.originIATACode = event.detail.recordId;
    }

    handleDestinationSelect(event) {
        this.destinationIATACode = event.detail.recordId;
    }

    saveFlight() {
        this.isLoading = true;
        saveFlight({ originAirportId: this.originIATACode, destinationAirportId: this.destinationIATACode })
            .then(result => {
                this.recordId = result; // Use the ID of the newly created flight record to display details
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Flight created successfully',
                    variant: 'success',
                }));
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                }));
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
    
}