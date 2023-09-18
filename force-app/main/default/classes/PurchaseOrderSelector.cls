public inherited sharing class PurchaseOrderSelector {
    public static PurchaseOrder__c getPurchaseOrderById(Id orderId) {
        return [
            SELECT Id, ClosedReason__c, Status__c
            FROM PurchaseOrder__c
            WHERE Id =: orderId
        ];
    }

    public static List<PurchaseOrderItem__c> getPurchaseOrderItemsByOrderId(Id orderId) {
        return [
            SELECT Id, AssetName__c, Description__c, UnitPrice__c, Type__c, PurchaseOrder__c, Quantity__c
            FROM PurchaseOrderItem__c
            WHERE PurchaseOrder__r.Id =: orderId
        ];
    }

    public static Employee__c getEmployeeByCurrentUserId() {
        return [
            SELECT Contact__c
            FROM Employee__c
            WHERE AssignedUser__r.Id =: UserInfo.getUserId()
            LIMIT 1
        ];
    }
}