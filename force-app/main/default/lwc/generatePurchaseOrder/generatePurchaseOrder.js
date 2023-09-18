import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { notifyParent } from 'c/utils';
import { NavigationMixin } from 'lightning/navigation';

import generatePurchaseOrder from '@salesforce/apex/PurchaseOrderController.generatePurchaseOrder';
import titleRecordCreated from '@salesforce/label/c.PurchaseOrderCreated';

export default class GeneratePurchaseOrder extends NavigationMixin(LightningElement) {
    @api recordId;

    @track showSpinner = true;

    connectedCallback() {
        this.generatePurchaseOrderRecord();
    }

    generatePurchaseOrderRecord() {
        generatePurchaseOrder({
            caseId: this.recordId
        }).then(result => {
            this.showSpinner = false;
            this.showToast('Success', 'success', titleRecordCreated);
            this.handleClose();
            this.navigateToRecordViewPage(result);
        }).catch(error => {
            this.showSpinner = false;
            this.showToast('Error', 'error', error.body.message);
            this.handleClose();
        });
    }

    navigateToRecordViewPage(recordId) {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'PurchaseOrder__c',
                actionName: 'view'
            }
        }).then(url => {
            this.navigateToEditPage(recordId, url);
        });
    }

    navigateToEditPage(recordId, url) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'PurchaseOrder__c',
                actionName: 'edit'
            },
            state: {
                nooverride: 1,
                navigationLocation: 'DETAIL',
                backgroundContext: url
            }
        });
    }

    showToast(title, variant, messageText) {
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: messageText
        });

        this.dispatchEvent(event);
    }

    handleClose() {
        notifyParent('close', true, this);
    }
}