package com.neasaa.finance.dao.entity.account;

import com.neasaa.base.app.entity.BaseEntity;
import com.neasaa.finance.util.OptionSymbol;
import java.io.Serial;
import java.math.BigDecimal;
import java.time.LocalDate;
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
public class AccountSnapshot extends BaseEntity {

  @Serial private static final long serialVersionUID = 1745893230092L;
  
  private long accountId; //Neasaa account id
  private String accountNumber; // Bank account number
  private LocalDate snapshotDate;
  private String symbol;
  // For options, this is the full option symbol (e.g., AAPL261218C360). For stocks, this will be null.
  private OptionSymbol optionSymbol;
  private String description;
  private BigDecimal quantity;
  private BigDecimal lastPrice;
  private BigDecimal lastPriceChange;
  private BigDecimal currentValue;
  private BigDecimal averageCostBasis;
  private BigDecimal totalCostBasis;
  private BigDecimal todayGainLoss;
  private BigDecimal totalGainLoss;
  private BigDecimal percentOfAccount;
  private int createdBy;
  private Date createdDate;
  private int lastUpdatedBy;
  private Date lastUpdatedDate;
}
