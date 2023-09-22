public inherited sharing class InternalAssetSelector {
    public static Asset getAssetRecordById(Id assetId) {
        return [
            SELECT Id, Status, PreviousOwner__c, InternalOwner__c
            FROM Asset 
            WHERE Id =: assetId
        ];
    }

    public static Employee__c getAssetInternalOwnerById(Id ownerId) {
        return [
            SELECT AssignedUser__c, AssignedUser__r.Email, Contact__c
            FROM Employee__c
            WHERE Id =: ownerId
        ];
    }
}