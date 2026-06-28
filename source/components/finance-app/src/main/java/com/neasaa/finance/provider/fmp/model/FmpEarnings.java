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
public class FmpEarnings {

  @JsonProperty("symbol")
  private String symbol;

  @JsonProperty("date")
  private String date;

  @JsonProperty("epsActual")
  private BigDecimal epsActual;

  @JsonProperty("epsEstimated")
  private BigDecimal epsEstimated;

  @JsonProperty("revenueActual")
  private BigDecimal revenueActual;

  @JsonProperty("revenueEstimated")
  private BigDecimal revenueEstimated;

  @JsonProperty("lastUpdated")
  private String lastUpdated;

}
