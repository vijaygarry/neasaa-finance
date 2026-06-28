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
public class FmpDividend {

  @JsonProperty("symbol")
  private String symbol;

  @JsonProperty("date")
  private String date;

  @JsonProperty("recordDate")
  private String recordDate;

  @JsonProperty("paymentDate")
  private String paymentDate;

  @JsonProperty("declarationDate")
  private String declarationDate;

  @JsonProperty("adjDividend")
  private BigDecimal adjDividend;

  @JsonProperty("dividend")
  private BigDecimal dividend;

  @JsonProperty("yield")
  private BigDecimal yield;

  @JsonProperty("frequency")
  private String frequency;

}
