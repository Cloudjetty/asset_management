public with sharing class CaseTriggerHandler {
    public static void fillCaseApprover(List<Case> cases) {
        Id caseApproverId = CaseNotificationSelector.getUserByEmail('anastasiiakomar.cloud@gmail.com').Id;

        for (Case currentCase : cases) {
            currentCase.Approver__c = caseApproverId;
        }
    }

    public static void sendCaseNotification(List<Case> cases, Map<Id, Case> oldCases) {
        new CaseNotificationService().sendCaseNotification(cases, oldCases);
    }
}