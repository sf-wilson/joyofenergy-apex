import { LightningElement, api, wire, track } from 'lwc';
import getRecommendPlans from '@salesforce/apex/PlansStub.recommend'
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi'
import { refreshApex } from '@salesforce/apex';

const columns = [
    {
        label: 'Plan Name', fieldName: 'link', wrapText: true, hideDefaultActions: true, type: 'url', typeAttributes: {
            label: { fieldName: 'planName' },
            tooltip: { fieldName: 'planName' },
            target: '_blank'
        }
    },
    { label: 'Rate', fieldName: 'rate', hideDefaultActions: true },
    {
        label: 'Cost', fieldName: 'cost', hideDefaultActions: true, cellAttributes: { alignment: 'left' }, type: 'number', typeAttributes: {
            maximumFractionDigits: 6 // defualt is 37 digits, i.e. 0.0680752568212718071625344352617080000
        }
    }
];

export default class RecommendPlans extends LightningElement {
    @api recordId;
    @api limits;

    @track plans;
    @track error;
    @track title = 'Recommended Plans';
    @track disableButton = false;
    @track showTable = true;

    cols = columns;
    wiredPlansResult;

    @wire(getRecommendPlans, {
        clientId: '$recordId',
        limits: '$limits'
    })
    wirePlanData(result) {
        this.wiredPlansResult = result; // track the provisioned value
        const { data, error } = result; // destructure it for convenience
        if (data) { 
            let tempList = [];
            data.forEach((record) => {
                let row = Object.assign({}, record);
                row.link = '/' + row.planId;
                tempList.push(row);
            });

            this.plans = tempList;
            this.error = undefined;
            this.title = 'Recommended Plans (' + this.plans.length + ')';
            this.showTable = this.plans.length > 0;
            console.log('plans=>' + JSON.stringify(this.plans));
        }else if (error) { 
            this.plans = undefined;
            this.error = JSON.stringify(error);
            this.disableButton = true;
            this.showTable = false;
            console.log('error=>' + JSON.stringify(error));
        }
    }

    refreshPlans() {
        console.log('call refresh on plans...');
        refreshApex(this.wiredPlansResult);
    }

    @track messageBody = '';
    CHANNEL_NAME = '/event/CustomEvent__e';
    subscription = {};

    connectedCallback() {
        // refresh component after page loaded
        this.refreshPlans();
        // Register listener
        this.handleSubscribe();
        // Register error listener     
        this.registerErrorListener();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    // Handles subscribe button click
    handleSubscribe() {
        const thisReference = this;
        /**
         * Description: Callback invoked whenever a new event message is received
         * Note: you must change `messageCallback = function (response) {}` to `messageCallback = (response) => {}`, otherwise, refreshPlans function won't take any effect.
         */
        const messageCallback = (response) => {
            const subEvt = response.data.payload.sObject__c;
            const msg = response.data.payload.Message__c;
            thisReference.messageBody = '[' + subEvt + '] - ' + msg;
            console.log("###New message received ", thisReference.messageBody);
            // Response contains the payload of the new message received

            if ('Reading__c' == subEvt && 'refreshView' == msg) {
                console.log('start to refresh component...');
                this.refreshPlans();
                console.log('end to refresh component...');
            }
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.CHANNEL_NAME, -1, messageCallback).then((response) => {
            // Response contains the subscription information on subscribe call
            console.log(
                "Subscription request sent to: ",
                JSON.stringify(response.channel)
            );
            this.subscription = response;
        });
    }

    // Handles unsubscribe button click
    handleUnsubscribe() {
        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, (response) => {
            console.log("unsubscribe() response: ", JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log("Received error from server: ", JSON.stringify(error));
            // Error contains the server-side error
        });
    }

    handleRowAction() {

    }
}