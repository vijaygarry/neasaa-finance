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
public class FmpQuote {

  @JsonProperty("symbol")
  private String symbol;

  @JsonProperty("name")
  private String name;

  @JsonProperty("price")
  private BigDecimal price;

  @JsonProperty("changePercentage")
  private BigDecimal changePercentage;

  @JsonProperty("change")
  private BigDecimal change;

  @JsonProperty("volume")
  private Long volume;
  
  @JsonProperty("dayLow")
  private BigDecimal dayLow;

  @JsonProperty("dayHigh")
  private BigDecimal dayHigh;

  @JsonProperty("yearHigh")
  private BigDecimal yearHigh;

  @JsonProperty("yearLow")
  private BigDecimal yearLow;

  @JsonProperty("marketCap")
  private BigDecimal marketCap;

  @JsonProperty("priceAvg50")
  private BigDecimal priceAvg50;

  @JsonProperty("priceAvg200")
  private BigDecimal priceAvg200;

  @JsonProperty("exchange")
  private String exchange;

  @JsonProperty("open")
  private BigDecimal open;

  @JsonProperty("previousClose")
  private BigDecimal previousClose;

  @JsonProperty("timestamp")
  private Long timestamp;
  
}
