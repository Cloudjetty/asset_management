import { api, LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { notifyParent } from 'c/utils';

import closePurchaseOrder from '@salesforce/apex/PurchaseOrderController.closePurchaseOrder';
import titlePurchaseOrderClosed from '@salesforce/label/c.PurchaseOrderClosed';

const COLUMNS = [
    { label: 'Purchased', value: 'Purchased' },
    { label: 'Rejected', value: 'Rejected' }
];

export default class ClosePurchaseOrder extends LightningElement {
    @api recordId;

    @track closedReason;
    columns = COLUMNS;

    handleChange(event) {
        this.closedReason = event.detail.value;
    }

    handleClosePurchaseOrder() {
        this.validateField();

        closePurchaseOrder({
            orderId: this.recordId,
            closedReason: this.closedReason
        }).then(() => {
            this.showToast('Success', 'success', titlePurchaseOrderClosed);
            this.handleClose();
        }).catch(error => {
            this.showToast('Error', 'error', error.body.message);
        });
    }

    validateField() {
        if (this.closedReason == null) {
            this.closedReason.reportValidity();
        };
    }

    handleClose() {
        notifyParent('close', true, this);
    }

    showToast(title, variant, messageText) {
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: messageText
        });

        this.dispatchEvent(event);
    }
}