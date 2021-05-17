import { LightningElement, wire, track } from 'lwc';
import getAllCases from '@salesforce/apex/babYodaListView.getAllCases';
import callOut from '@salesforce/apex/babYodaListView.callOut';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class BabyYodaListView extends LightningElement {
    @track columns;
    showDetail = false;
    showSpinner = false;
    @track response;
    @track error;
    @track data;
    @track record;
    @track value;
    @track options;
    @wire(getAllCases)
    wiredCases({
        error,
        data
    }) {
        if (data) {
            this.columns = data.lstDataTableColumns;
            this.data = data.lstDataTableData;
            this.options = data.optionList;
            let resultSet = data.optionList;
            for (let i = 0; i < resultSet.length; i++) {
                if (resultSet[i].isDefault == true) {
                    this.value = resultSet[i].value;
                }
            }

        } else if (error) {
            this.error = error;
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'show_details':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    showRowDetails(row) {
        this.record = row;
        this.showDetail = true;
        this.template.querySelector('[data-id="editDialog"]').classList.add('slds-fade-in-open');
        this.template.querySelector('[data-id="dialogBack"]').classList.add('slds-backdrop--open');

    }

    handleClick(event) {
        this.template.querySelector('[data-id="editDialog"]').classList.remove('slds-fade-in-open');
        this.template.querySelector('[data-id="dialogBack"]').classList.remove('slds-backdrop--open');

    }

    handleCallWebservice(event) {
        this.showSpinner = true;
        console.log('this.record.Description, this.record.Id' + this.record.Description + ',' + this.record.Id);
        callOut({ code: this.record.Description, idCase: this.record.Id })
            .then(result => {
                this.response = result;
                const eventx = new ShowToastEvent({
                    title: 'Get Help',
                    type:'Success',
                    message: this.response
                });
                this.dispatchEvent(eventx);
            })
            .catch(error => {
                this.response = error;
                const eventx = new ShowToastEvent({
                    title: 'Get Help',
                    message: this.response
                });
                this.dispatchEvent(eventx);
            });

        this.showSpinner = false;
        ;
    }



    handleChange(event) {
        this.value = event.detail.value;
        this.showSpinner = false;
        this.showDetail = false;
    }
}