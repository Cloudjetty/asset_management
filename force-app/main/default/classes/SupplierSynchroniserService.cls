public inherited sharing class SupplierSynchroniserService {
    public void syncSupplier(Id supplierId) {
        PurchaseOrder__c purchaseOrder = SupplierSynchroniserSelector.getPurchaseOrderBySupplierId(supplierId);

        List<PurchaseOrderSupplier__c> suppliers = this.buildSuppliersToUpdate(purchaseOrder, supplierId);
        update suppliers;

        List<PurchaseOrderItem__c> purchaseOrderItems = this.syncItems(purchaseOrder.Id, supplierId);
        insert purchaseOrderItems;

        this.buildPurchaseOrderToUpdate(
            purchaseOrder,
            new Map<Id, PurchaseOrderSupplier__c>(suppliers),
            supplierId
        );
        
        update purchaseOrder;
    }

    private List<PurchaseOrderSupplier__c> buildSuppliersToUpdate(PurchaseOrder__c purchaseOrder, Id actualSupplierId) {
        List<PurchaseOrderSupplier__c> suppliers = new List<PurchaseOrderSupplier__c>();

        for (PurchaseOrderSupplier__c supplier : purchaseOrder.PurchaseOrderSuppliers__r) {
            suppliers.add(this.buildSupplierToUpdate(supplier, actualSupplierId));
        }

        return suppliers;
    }

    private PurchaseOrderSupplier__c buildSupplierToUpdate(PurchaseOrderSupplier__c supplier, Id actualSupplierId) {
        supplier.Status__c = 'Rejected';
        supplier.SynchronizedSupplier__c = false;

        if (supplier.Id == actualSupplierId) {
            supplier.Status__c = 'Accepted';
            supplier.SynchronizedSupplier__c = true;
        }

        return supplier;
    }

    private List<PurchaseOrderItem__c> syncItems(Id purchaseOrderId, Id supplierId) {
        List<PurchaseOrderItem__c> purchaseOrderItemsToInsert = this.buildPurchaseOrderItems(
            SupplierSynchroniserSelector.getPurchaseOrderSupplierItems(supplierId), 
            purchaseOrderId
        );

        if (purchaseOrderItemsToInsert.isEmpty()) {
            throw new ExceptionUtils.ServiceException(Label.PurchaseOrderSupplierItemsAreMissing);
        }
        
        return purchaseOrderItemsToInsert;
    }

    private List<PurchaseOrderItem__c> buildPurchaseOrderItems(
        List<PurchaseOrderSupplierItem__c> supplierItems, 
        Id purchaseOrderId
    ) {
        List<PurchaseOrderItem__c> purchaseOrderItems = new List<PurchaseOrderItem__c>();

        for (PurchaseOrderSupplierItem__c supplierItem : supplierItems) {
            purchaseOrderItems.add(this.buildPurchaseOrderItem(supplierItem, purchaseOrderId));
        }

        return purchaseOrderItems;
    }
    
    private PurchaseOrderItem__c buildPurchaseOrderItem(PurchaseOrderSupplierItem__c supplierItem, Id purchaseOrderId) {
        PurchaseOrderItem__c purchaseOrderItem = new PurchaseOrderItem__c(
            PurchaseOrder__c = purchaseOrderId,
            Description__c = supplierItem.Description__c,
            Product__c = supplierItem.Product__c,
            Quantity__c = supplierItem.Quantity__c,
            Type__c = supplierItem.Type__c,
            AssetName__c = supplierItem.AssetName__c,
            UnitPrice__c = supplierItem.UnitPrice__c
        );

        return purchaseOrderItem;
    }

    private void buildPurchaseOrderToUpdate(
        PurchaseOrder__c purchaseOrder, 
        Map<Id, PurchaseOrderSupplier__c> supplier,
        Id supplierId
    ) {
        purchaseOrder.FinalSupplier__c = supplier.get(supplierId).Account__c;
        purchaseOrder.FinalSupplierContact__c = supplier.get(supplierId).Contact__c;
    }
}