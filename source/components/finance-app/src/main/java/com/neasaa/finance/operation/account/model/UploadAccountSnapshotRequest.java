package com.neasaa.finance.operation.account.model;

import com.neasaa.base.app.operation.model.OperationRequest;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UploadAccountSnapshotRequest extends OperationRequest {

    private long accountId;
    private String snapshotCSVFilePath;

    public UploadAccountSnapshotRequest() {}

    @Override
    public void normalize() {}
}
