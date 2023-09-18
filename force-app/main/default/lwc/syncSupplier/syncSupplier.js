import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { notifyParent } from 'c/utils';

import syncSupplier from '@salesforce/apex/SupplierSynchroniserController.syncSupplier';
import titleSynchronizedSuppliers from '@salesforce/label/c.SynchronizedSuppliers';

export default class SyncSupplier extends LightningElement {
    @api recordId;

    @track showSpinner = true;

    connectedCallback() {
        this.syncSupplierRecord();
    }

    syncSupplierRecord() {
        syncSupplier({
            supplierId: this.recordId
        }).then(() => {
            this.showSpinner = false;
            this.showToast('Success', 'success', titleSynchronizedSuppliers);
            this.handleClose();
        }).catch(error => {
            this.showSpinner = false;
            this.showToast('Error', 'error', error.body.message);
            this.handleClose();
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