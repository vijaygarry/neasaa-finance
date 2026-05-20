package com.neasaa.finance.dao.entity;

import com.neasaa.base.app.entity.BaseEntity;
import java.io.Serial;
import java.math.BigDecimal;
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
public class AssetPrice extends BaseEntity {

  @Serial private static final long serialVersionUID = 1745893230063L;
  private int assetId;
  private BigDecimal currentPrice;
  private BigDecimal previousClose;
  private BigDecimal marketOpen;
  private BigDecimal dayHigh;
  private BigDecimal dayLow;
  private BigDecimal marketChange;
  private BigDecimal marketChangePercent;
  private Long volume;
  private Date marketTime;
  private BigDecimal bid;
  private BigDecimal ask;
  private Integer bidSize;
  private Integer askSize;
  private BigDecimal preMarketPrice;
  private BigDecimal preMarketChange;
  private BigDecimal preMarketChangePercent;
  private BigDecimal week52High;
  private BigDecimal week52Low;
  private BigDecimal fiftyDayAverage;
  private BigDecimal fiftyDayAverageChange;
  private BigDecimal twoHundredDayAverage;
  private BigDecimal twoHundredDayAverageChange;
  private Long avgDailyVolume3Month;
  private Long avgDailyVolume10Day;
  private BigDecimal marketCap;
  private BigDecimal dividendYield;
  private int createdBy;
  private Date createdDate;
  private int lastUpdatedBy;
  private Date lastUpdatedDate;
}
