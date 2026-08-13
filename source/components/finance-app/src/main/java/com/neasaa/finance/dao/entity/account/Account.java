package com.neasaa.finance.dao.entity.account;

import com.neasaa.base.app.entity.BaseEntity;
import com.neasaa.finance.enums.BankEnum;
import java.io.Serial;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Account extends BaseEntity {

  @Serial private static final long serialVersionUID = 1745893230090L;
  private long accountId;
  private int userId;
  private String accountNumber;
  private String accountName;
  private BankEnum bankName;
  private String accountType;
  private int createdBy;
  private Date createdDate;
  private int lastUpdatedBy;
  private Date lastUpdatedDate;
}
