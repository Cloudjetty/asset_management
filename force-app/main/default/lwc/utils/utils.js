import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';


export const showToast = (reference, title, message, attributes, variant, mode) => {
    let toastParams = {
        title: title,
        message: message,
        variant: variant
    };

    if (attributes !== null) {
        toastParams.messageData = attributes;
    }

    if (mode !== null) {
        toastParams.mode = mode;
    }

    reference.dispatchEvent(new ShowToastEvent(toastParams));
}


export const copyArray = (array) => {
    return JSON.parse(JSON.stringify(array));
}


export const handleError = (sourceError) => {
    let handledError = 'Unexpected Error';

    if (Array.isArray(sourceError.body)) {
        handledError = sourceError.body.map(e => e.message).join(', ');
    } else if (sourceError.body && typeof sourceError.body.message === 'string') {
        handledError = sourceError.body.message;
    }

    return handledError;
}

export const notifyParent = (eventName, message, reference) => {
    reference.dispatchEvent(new CustomEvent(eventName, { detail: message }));
}

export const navigateToRecord = (recordId, objectName, reference) => {
    reference[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId,
            objectApiName: objectName,
            actionName: 'view'
        }
    });
}