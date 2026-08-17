package com.neasaa.finance.operation.account.model;

import com.neasaa.base.app.operation.model.OperationResponse;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UploadAccountSnapshotResponse extends OperationResponse {

    private int recordsProcessed;

    public UploadAccountSnapshotResponse() {}
}
