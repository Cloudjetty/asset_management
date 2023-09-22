public with sharing class InternalAssetController {
    @AuraEnabled
    public static void changeAssetOwner(Id assetId, Id ownerId, String comments) {
        try {
            new InternalAssetService().changeAssetOwner(assetId, ownerId, comments);
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}