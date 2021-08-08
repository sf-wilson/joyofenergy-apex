import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import initReadings from '@salesforce/apex/ReadingsStub.initReadings'

export default class FetchReadings extends LightningElement {
    @api recordId;

    renderedCallback() {
        console.log(this.recordId)
        initReadings({clientId: this.recordId}).then(()=>{
            const toast = new ShowToastEvent({
                title: 'Readings Ready!',
                message: 'Fetch readings finished.',
                variant: 'success'
            });
            this.dispatchEvent(toast);
            this.dispatchEvent(new CloseActionScreenEvent());
        }).catch(error => {
            console.log(error)
        });
    }
}