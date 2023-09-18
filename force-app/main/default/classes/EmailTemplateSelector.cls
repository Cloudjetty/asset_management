public inherited sharing class EmailTemplateSelector {
    public static List<EmailTemplate> getEmailTemplatesByName(Set<String> templatesName) {
        return [
            SELECT Id, DeveloperName
            FROM EmailTemplate 
            WHERE DeveloperName IN: templatesName
        ];
    }
}