package com.neasaa.finance.provider.fmp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class FmpPriceTargetSummary {

  @JsonProperty("symbol")
  private String symbol;

  @JsonProperty("lastMonthCount")
  private Integer lastMonthCount;

  @JsonProperty("lastMonthAvgPriceTarget")
  private BigDecimal lastMonthAvgPriceTarget;

  @JsonProperty("lastQuarterCount")
  private Integer lastQuarterCount;

  @JsonProperty("lastQuarterAvgPriceTarget")
  private BigDecimal lastQuarterAvgPriceTarget;

  @JsonProperty("lastYearCount")
  private Integer lastYearCount;

  @JsonProperty("lastYearAvgPriceTarget")
  private BigDecimal lastYearAvgPriceTarget;

  @JsonProperty("allTimeCount")
  private Integer allTimeCount;

  @JsonProperty("allTimeAvgPriceTarget")
  private BigDecimal allTimeAvgPriceTarget;

  @JsonProperty("publishers")
  private String publishers;

}
