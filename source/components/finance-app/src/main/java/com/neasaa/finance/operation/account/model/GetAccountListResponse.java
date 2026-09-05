package com.neasaa.finance.operation.account.model;

import com.neasaa.base.app.operation.model.OperationResponse;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GetAccountListResponse extends OperationResponse {

    private List<AccountDetail> accounts;

    public GetAccountListResponse() {}
}
