public with sharing class PurchaseOrderController {
    @AuraEnabled
    public static Id generatePurchaseOrder(Id caseId) {
        Id orderId;

        try {
            orderId = new PurchaseOrderService().generatePurchaseOrder(caseId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }

        return orderId;
    }

    @AuraEnabled
    public static void closePurchaseOrder(Id orderId, String closedReason) {
        try {
            new PurchaseOrderService().closePurchaseOrder(orderId, closedReason);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}