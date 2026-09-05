package com.neasaa.finance.operation.account;

import com.neasaa.base.app.operation.AbstractOperation;
import com.neasaa.base.app.operation.exception.OperationException;
import com.neasaa.base.app.operation.model.EmptyOperationRequest;
import com.neasaa.finance.dao.entity.account.Account;
import com.neasaa.finance.dao.pg.account.AccountDao;
import com.neasaa.finance.operation.FinanceOperationNames;
import com.neasaa.finance.operation.account.model.AccountDetail;
import com.neasaa.finance.operation.account.model.GetAccountListResponse;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Log4j2
@Component("GetAccountListOperation")
@Scope("prototype")
public class GetAccountListOperation
        extends AbstractOperation<EmptyOperationRequest, GetAccountListResponse> {

    @Autowired
    private AccountDao accountDao;

    @Override
    public String getOperationName() {
        return FinanceOperationNames.GET_ACCOUNT_LIST;
    }

    @Override
    public void doValidate(EmptyOperationRequest request) throws OperationException {}

    @Override
    public GetAccountListResponse doExecute(EmptyOperationRequest request) throws OperationException {
        //TODO: Replace this with the actual userId from the session context. For now, we will use a hardcoded userId.
        //int userId = getContext().getAppSessionUser().getUserId();
        int userId = 3;
        log.info("Fetching account list for userId={}", userId);

        List<Account> accounts = accountDao.getAccountsByUserId(userId);

        List<AccountDetail> accountDetails = accounts.stream()
                .map(a -> AccountDetail.builder()
                        .accountId(a.getAccountId())
                        .accountNumber(a.getAccountNumber())
                        .accountName(a.getAccountName())
                        .bankName(a.getBankName() != null ? a.getBankName().name() : null)
                        .accountType(a.getAccountType())
                        .build())
                .toList();

        GetAccountListResponse response = new GetAccountListResponse();
        response.setAccounts(accountDetails);
        return response;
    }
}
