trigger CaseTrigger on Case (before insert, after insert, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            CaseTriggerHandler.fillCaseApprover(Trigger.new);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CaseTriggerHandler.sendCaseNotification(Trigger.new, null);
        }

        if (Trigger.isUpdate) {
            CaseTriggerHandler.sendCaseNotification(Trigger.new, (Map<Id, Case>)Trigger.oldMap);
        }
    }
}