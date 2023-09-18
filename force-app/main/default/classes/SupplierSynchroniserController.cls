public with sharing class SupplierSynchroniserController {
    @AuraEnabled
    public static void syncSupplier(Id supplierId) {
        try {
            new SupplierSynchroniserService().syncSupplier(supplierId);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}