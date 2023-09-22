public inherited sharing class InternalAssetService {
    public void changeAssetOwner(Id assetId, Id ownerId, String comments) {
        Employee__c internalOwner = InternalAssetSelector.getAssetInternalOwnerById(ownerId);
        
        Asset assetToUpdate = this.buildAssetToUpdate(
            InternalAssetSelector.getAssetRecordById(assetId),
            ownerId,
            internalOwner.Contact__c
        );
        
        update assetToUpdate;

        Approval.process(this.buildApprovalRequest(comments, assetToUpdate.Id, internalOwner.AssignedUser__c));
    }

    private Asset buildAssetToUpdate(Asset asset, Id ownerId, Id contactId) {
        asset.Id = asset.Id;
        asset.Status = 'In Delivery';
        asset.PreviousOwner__c = asset.InternalOwner__c;
        asset.InternalOwner__c = ownerId;
        asset.ContactId = contactId;

        return asset;
    }

    private Approval.ProcessSubmitRequest buildApprovalRequest(String comments, Id assetId, Id approverId) {
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();

        approvalRequest.setComments(comments);
        approvalRequest.setObjectId(assetId);
        approvalRequest.setNextApproverIds(new Id[] {approverId});

        return approvalRequest;
    }
}