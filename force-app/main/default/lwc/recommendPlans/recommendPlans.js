import { LightningElement, api, wire, track } from 'lwc';
import getRecommendPlans from '@salesforce/apex/PlansStub.recommend'

const columns = [
    {label: 'Plan Name', fieldName: 'link', wrapText: true, hideDefaultActions: true, type: 'url', typeAttributes: {
        label: {fieldName: 'planName'}, 
        tooltip: {fieldName: 'planName'},
        target: '_blank'
    }},
    {label: 'Rate', fieldName: 'rate', hideDefaultActions: true},
    {label: 'Cost', fieldName: 'cost', hideDefaultActions: true, cellAttributes: { alignment: 'left' }, type: 'number', typeAttributes: {
        maximumFractionDigits: 6 // defualt is 37 digits, i.e. 0.0680752568212718071625344352617080000
    }}
];

export default class RecommendPlans extends LightningElement {
    @api recordId;
    @api limits;

    @track title = 'Recommend Plans';
    @track disableButton = false;
    @track showTable = true;

    /*
        1st solution: Wire an Apex method as property
        Tips: 
            1. First we need to create one apex class with @AuraEnabled(cacheable=true), and also specify @AuraEnabled for variable name if needed.
            2. During passing of the parameters, we need to put '$' sign before the property.
            3. Then we can get the data using {plans.data} & error using {plans.error} in html file.
    */
    // @wire (getRecommendPlans, {
    //     clientId: '$recordId',
    //     limits: '$limits'
    // }) 
    // plans;

    /*
        2nd solution: Wire an Apex Method as function
        Tips: 
            1. The same as #1 in 1st solution.
            2. The same as #2 in 1st solution.
            3. Defined two private reactive properties such as plans and error.
            4. Then we need to set these two properties into the wired function named wiredPlans.
    */
    // @track plans;
    // @track error;

    // @wire (getRecommendPlans, {
    //     clientId: '$recordId',
    //     limits: '$limits'
    // })
	// wiredPlans({data, error}){
	// 	if(data) {
	// 		this.plans =data;
	// 		this.error = undefined;
	// 	}else {
	// 		this.plans =undefined;
	// 		this.error = error;
	// 	}
	// }

    /*
        3rd solution: Call an apex method imperatively
        Tips:
            1. For imperative method we dont need to mark the apex method as cacheabe=true.
    */
    @track plans;
    @track error;

    cols = columns;

    connectedCallback(){
        this.handleRefresh();
    }

    handleRefresh() {
        console.log(this.recordId);
        console.log(this.limits);

        getRecommendPlans({
            clientId: this.recordId,
            limits: this.limits
        })
        .then(result => {
            console.log('result=>' + JSON.stringify(result));
            console.log('size=>' + result.length);

            let tempList = []; 
            result.forEach((record) => {
                let row = Object.assign({}, record);  
                row.link = '/' + row.planId;
                tempList.push(row);
            });
            
            this.plans = tempList;
            this.error = undefined;
            this.title = 'Recommend Plans ('+ result.length +')';
            this.showTable = this.plans.length > 0;
            console.log('plans=>' + JSON.stringify(this.plans));
        })
        .catch(error => {
            this.plans = undefined;
            this.error = error;
            this.disableButton = true;
            this.showTable = false;
        });
    }

    handleRowAction(){
        
    }

    /*  
        Ref: https://www.apexhours.com/call-apex-method-from-lightning-web-components/
        Here is some consideration:
            First, import the Apex method into the JS
            If it is wired, make sure cacheable=trued ecorator is set
            Parameters are passed as an object
            For simple results: wire to a property
            For some processing: wire to a function
            For controlling when to call: imperative
    */
}