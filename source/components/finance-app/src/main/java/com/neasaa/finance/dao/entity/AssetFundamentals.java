package com.neasaa.finance.dao.entity;

import com.neasaa.base.app.entity.BaseEntity;
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
public class AssetFundamentals extends BaseEntity {

  @Serial private static final long serialVersionUID = 1745893230064L;
  private int assetId;
  private BigDecimal peTtm;
  private BigDecimal peFtm;
  private BigDecimal epsTtm;
  private BigDecimal epsForward;
  private BigDecimal epsCurrentYear;
  private BigDecimal priceEpsCurrentYear;
  private BigDecimal dividendRate;
  private LocalDate dividendExDate;
  private LocalDate dividendPayDate;
  private LocalDate nextEarningsDate;
  private LocalDate earningsStartDate;
  private LocalDate earningsEndDate;
  private BigDecimal averageAnalystRating;
  private String analystRatingLevel;
  private BigDecimal oneYearPriceTarget;
  private LocalDate priceTargetUpdatedDate;
  private int createdBy;
  private Date createdDate;
  private int lastUpdatedBy;
  private Date lastUpdatedDate;
}
