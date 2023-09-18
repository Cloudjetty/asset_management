public inherited sharing class CaseSelector {
    public static List<Case> getCasesByIds(Set<Id> caseIds) {
        return [
            SELECT Id, CreatedDate, ClosedDate, AccountId, CaseNumber, Subject
            FROM Case
            WHERE Id IN: caseIds
        ];
    }
}