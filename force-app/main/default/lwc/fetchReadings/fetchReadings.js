import { LightningElement, api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import initReadings from '@salesforce/apex/ReadingsStub.initReadings'
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
// import { updateRecord } from 'lightning/uiRecordApi';
// import { getRecordNotifyChange } from 'lightning/uiRecordApi';
// import { refreshApex } from '@salesforce/apex';

export default class FetchReadings extends LightningElement {
    @api recordId;

    @wire(CurrentPageReference) pageRef;
    // pubsub model for registered custom components refresh.
    pubSubMessage() {
        const msg = 'pubsub';
        fireEvent(this.pageRef, 'refreshView', msg);
        console.log('fire event...');
    }

    renderedCallback() {
        this.pubSubMessage();
        console.log(this.recordId);
        initReadings({clientId: this.recordId})
        .then(()=>{
            const toast = new ShowToastEvent({
                title: 'Readings Ready!',
                message: 'Fetch readings finished.',
                variant: 'success'
            });

            // Only update standard contact page including detail & related list.
            eval("$A.get('e.force:refreshView').fire();");

            this.pubSubMessage();
            
            this.dispatchEvent(toast);
            this.dispatchEvent(new CloseActionScreenEvent()); // used to close popup window automatically -> lightning-spinner

            // window.location.reload();

            // Only refresh standard contact detail page
            // updateRecord({fields: {Id: this.recordId}});

            // Display fresh data in the form
            // return refreshApex(this.contact);

            // Notify LDS that you've changed the record outside its mechanisms.
            // getRecordNotifyChange([{recordId: this.recordId}]);
        })
        .catch(error => {
            console.log('[fetchReading] error: ' + error);
        });
    }
}