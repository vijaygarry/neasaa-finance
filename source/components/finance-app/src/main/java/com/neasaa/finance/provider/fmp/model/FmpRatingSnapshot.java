package com.neasaa.finance.provider.fmp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class FmpRatingSnapshot {

  @JsonProperty("symbol")
  private String symbol;

  @JsonProperty("rating")
  private String rating;

  @JsonProperty("overallScore")
  private Integer overallScore;

  @JsonProperty("discountedCashFlowScore")
  private Integer discountedCashFlowScore;

  @JsonProperty("returnOnEquityScore")
  private Integer returnOnEquityScore;

  @JsonProperty("returnOnAssetsScore")
  private Integer returnOnAssetsScore;

  @JsonProperty("debtToEquityScore")
  private Integer debtToEquityScore;

  @JsonProperty("priceToEarningsScore")
  private Integer priceToEarningsScore;

  @JsonProperty("priceToBookScore")
  private Integer priceToBookScore;

}
