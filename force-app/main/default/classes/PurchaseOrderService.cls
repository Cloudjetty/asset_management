public with sharing class PurchaseOrderService {
    public Id generatePurchaseOrder(Id actualCaseId) {
        PurchaseOrder__c purchaseOrder = this.buildPurchaseOrder();
        
        insert purchaseOrder;

        Case actualCase = this.buildCaseToUpdate(
            CaseSelector.getCasesByIds(new Set<Id> {actualCaseId})[0], 
            purchaseOrder.Id
        );
        
        update actualCase;

        return purchaseOrder.Id;
    }    
    
    public void closePurchaseOrder(Id purchaseOrderId, String closedReason) {
        PurchaseOrder__c purchaseOrder = this.buildPurchaseOrderToUpdate(
            PurchaseOrderSelector.getPurchaseOrderById(purchaseOrderId),
            closedReason
        );

        update purchaseOrder;

        this.generateAssetsFromPurchaseOrderItems(purchaseOrderId);
    }

    private PurchaseOrder__c buildPurchaseOrder() {
        return new PurchaseOrder__c(Status__c = 'Draft');
    }

    private Case buildCaseToUpdate(Case actualCase, Id purchaseOrderId) {
        actualCase.PurchaseOrder__c = purchaseOrderId;
        actualCase.Status = 'In Purchase';

        return actualCase;
    }

    private PurchaseOrder__c buildPurchaseOrderToUpdate(PurchaseOrder__c purchaseOrder, String closedReason) {
        purchaseOrder.ClosedReason__c = closedReason;
        purchaseOrder.Status__c = 'Closed';

        return purchaseOrder;
    }

    private void generateAssetsFromPurchaseOrderItems(Id purchaseOrderId) {
        Employee__c assetOwner = PurchaseOrderSelector.getEmployeeByCurrentUserId();
        List<Asset> assetsToInsert = new List<Asset>();

        for (PurchaseOrderItem__c purchaseOrderItem : PurchaseOrderSelector.getPurchaseOrderItemsByOrderId(purchaseOrderId)) {
            for (Integer i = 0; i < purchaseOrderItem.Quantity__c; i++) {
                assetsToInsert.add(this.buildAsset(purchaseOrderItem, assetOwner));
            }
        }

        if (!assetsToInsert.IsEmpty()) {
            insert assetsToInsert;
        }
    }

    private Asset buildAsset(PurchaseOrderItem__c purchaseOrderItem, Employee__c assetOwner) {
        return new Asset(
            Name = purchaseOrderItem.AssetName__c,
            Description = purchaseOrderItem.Description__c,
            Price = purchaseOrderItem.UnitPrice__c,
            Quantity = 1,
            PurchaseDate = System.today(),
            Type__c = purchaseOrderItem.Type__c,
            Status = 'Purchased',
            IsInternal = true,
            PurchaseOrder__c = purchaseOrderItem.PurchaseOrder__c,
            ContactId = assetOwner.Contact__c,
            InternalOwner__c = assetOwner.Id
        );
    }
}
