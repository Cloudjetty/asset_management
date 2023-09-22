import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { notifyParent } from 'c/utils';

import changeAssetOwner from '@salesforce/apex/InternalAssetController.changeAssetOwner';
import titleAssetOwnerChanged from '@salesforce/label/c.AssetOwnerChanged';

export default class ChangeAssetOwner extends LightningElement {
    @api recordId;

    @track newOwner;
    @track comments;

    handleOwnerValue(event) {
        this.newOwner = event.target.value;
    }

    handleChangeAssetOwner() {
        this.comments = this.template.querySelector('lightning-textarea').value;

        changeAssetOwner({
            assetId: this.recordId,
            ownerId: this.newOwner,
            comments: this.comments
        }).then(() => {
            this.showToast('Success', 'success', titleAssetOwnerChanged);
            this.handleClose();
        }).catch(error => {
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