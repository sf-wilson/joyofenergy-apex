import { LightningElement, api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getContactDetails from '@salesforce/apex/refreshContact.getContactDetails';
import { registerListener, unregisterAllListeners} from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';

export default class refreshContact extends LightningElement {

    // reactive variable
	@api recordId;

	@track lname;
    @track fname;

    /**
     * refreshContact Demo
     */
    wiredContactResult; 

    @wire(getContactDetails, {conid: '$recordId'})
    wireContactData(result) {
        this.wiredContactResult = result; // track the provisioned value
        const { data, error } = result; // destructure it for convenience
        if (data) { 
            this.lname = data.LastName;
            this.fname = data.FirstName;
            this.error = undefined;
        }else if (error) { 
            this.lname = undefined;
            this.fname = undefined;
            console.log('err=>' + JSON.stringify(error));
        }
    }

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        registerListener('refreshView', this.handleCallback, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleCallback(msg) {
        console.log('Received event in contact');
        console.log(msg);
        this.refreshContact();
    }

    refreshContact() {
        console.log('call refresh contact...');
        return refreshApex(this.wiredContactResult); 
    }
}