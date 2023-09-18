public inherited sharing class SupplierSynchroniserSelector {
    public static PurchaseOrder__c getPurchaseOrderBySupplierId(Id supplierId) {
        return [
            SELECT Id, FinalSupplier__c, FinalSupplierContact__c, 
                   (
                        SELECT Id, Status__c, Account__c, Contact__c
                        FROM PurchaseOrderSuppliers__r
                   )
            FROM PurchaseOrder__c
            WHERE Id IN (
                SELECT PurchaseOrder__c 
                FROM PurchaseOrderSupplier__c 
                WHERE Id =: supplierId
            ) 
        ];
    }

    public static List<PurchaseOrderSupplierItem__c> getPurchaseOrderSupplierItems(Id supplierId) {
        return [
            SELECT AssetName__c, Product__c, Quantity__c, Type__c, UnitPrice__c, Description__c
            FROM PurchaseOrderSupplierItem__c 
            WHERE PurchaseOrderSupplier__c =: supplierId
        ];
    }
}