public inherited sharing class CaseNotificationSelector {
    public static Group getGroupByName(String groupName) {
        return [
            SELECT Id
            FROM Group 
            WHERE DeveloperName =: groupName
            LIMIT 1
        ];
    }

    public static List<GroupMember> getGroupMembersByGroupIds(Set<Id> groupIds) {
        return [
            SELECT Id, UserOrGroupId 
            FROM GroupMember 
            WHERE GroupId IN: groupIds
        ];
    }

    public static List<User> getUsersByIds(Set<Id> userIds) {
        return [
            SELECT Id, Email 
            FROM User 
            WHERE Id IN: userIds
        ];
    }

    public static User getUserByEmail(String email) {
        return [
            SELECT Id
            FROM User 
            WHERE Email =: email
              AND IsActive = true
        ];
    }

    public static User getCaseOwnerByCaseId(Id caseId) {
        return [
            SELECT Id, Email 
            FROM User 
            WHERE Id IN (
                SELECT OwnerId
                FROM Case
                WHERE Id =: caseId
            )
        ];
    }
}