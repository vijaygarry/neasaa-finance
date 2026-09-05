package com.neasaa.finance.operation.account.model;

import java.math.BigDecimal;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AccountDetail {

    private long accountId;
    private String accountNumber;
    private String accountName;
    private String bankName;
    private String accountType;
    private BigDecimal currentBalance;
}
