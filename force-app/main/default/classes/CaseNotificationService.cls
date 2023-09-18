public inherited sharing class CaseNotificationService {
    public void sendCaseNotification(List<Case> cases, Map<Id, Case> oldCases) {
        Id internalCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        Map<String, EmailTemplate> emailTemplates = this.getEmailTemplates();

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        Set<String> assetManagersEmails = this.getAssetManagersEmails();

        for (Case caseItem : cases) {
            if (caseItem.RecordTypeId != internalCaseId) {
                continue;
            }

            if (oldCases != null && oldCases.get(caseItem.Id).Status != caseItem.Status) {
                emails = new List<Messaging.SingleEmailMessage>{
                   this.buildEmailMessage(
                        emailTemplates.get('InternalCaseStatusWasChanged'), 
                        caseItem, 
                        this.getCaseOwnerEmailAddress(caseItem)
                    ),
                    this.buildEmailMessage(
                        emailTemplates.get('InternalCaseStatusWasChangedGroup'), 
                        caseItem, 
                        assetManagersEmails
                    ) 
                };
            }
            
            if (oldCases == null) {
                emails.add(
                    this.buildEmailMessage(
                        emailTemplates.get('NewInternalCaseNotification'), 
                        caseItem, 
                        assetManagersEmails
                    )
                );
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    
    private Set<String> getAssetManagersEmails() {
        Group assetManagerGroup = CaseNotificationSelector.getGroupByName('AssetManagers');
        Set<String> assetManagersEmails = new Set<String>();

        for (
            User user : CaseNotificationSelector.getUsersByIds(this.getUsersFromPublicGroup(
                new Set<Id> {assetManagerGroup.Id}
            ))
        ) {
            assetManagersEmails.add(user.email);
        }

        return assetManagersEmails;
    }

    private Set<Id> getUsersFromPublicGroup(Set<Id> groupIds) {
        Set<Id> userIds = new Set<Id>();
        Set<Id> nestedGroupIds = new Set<Id>();

        for (GroupMember groupMember : CaseNotificationSelector.getGroupMembersByGroupIds(groupIds)) {
            if (groupMember.UserOrGroupId.getSObjectType() == User.sObjectType) {
                userIds.add(groupMember.UserOrGroupId);
                continue;
            }

            nestedGroupIds.add(groupMember.UserOrGroupId);
        }

        if (!nestedGroupIds.isEmpty()) {
            userIds.addAll(this.getUsersFromPublicGroup(nestedGroupIds));
        }

        return userIds;
    }

    private Messaging.SingleEmailMessage buildEmailMessage(
        EmailTemplate emailTemplate, 
        Case actualCase, 
        Set<String> mailToAddresses
    ) {
        Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(
            emailTemplate.Id, 
            actualCase.OwnerId, 
            actualCase.Id
        );
        
        message.targetObjectId = actualCase.ContactId;
        message.toAddresses = new List<String> (mailToAddresses);
        message.setTreatTargetObjectAsRecipient(false);
        message.setSaveAsActivity(true); 

        return message;
    }

    public Map<String, EmailTemplate> getEmailTemplates() {
        Set<String> templatesName = new Set<String>{
            'NewInternalCaseNotification',
            'InternalCaseStatusWasChanged',
            'InternalCaseStatusWasChangedGroup'
        };

        List<EmailTemplate> caseNotificationEmailTemplates = EmailTemplateSelector.getEmailTemplatesByName(templatesName);
        Map<String, EmailTemplate> emailTemplatesMap = new Map<String, EmailTemplate>();

        for (EmailTemplate template : caseNotificationEmailTemplates) {
            emailTemplatesMap.put(template.DeveloperName, template);
        }

        return emailTemplatesMap;
    }

    private Set<String> getCaseOwnerEmailAddress(Case actualCase) {
        return new Set<String>{CaseNotificationSelector.getCaseOwnerByCaseId(actualCase.Id)?.Email};
    }
}