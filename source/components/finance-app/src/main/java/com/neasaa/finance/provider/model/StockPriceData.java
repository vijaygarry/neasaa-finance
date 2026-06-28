package com.neasaa.finance.provider.model;

import java.math.BigDecimal;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class StockPriceData {

    private String symbol;
  
    private BigDecimal currentPrice;
    private BigDecimal changePercentage;
    private BigDecimal change;

    private Long volume;
    
    private BigDecimal dayHigh;
    private BigDecimal dayLow;
    private BigDecimal week52High;
    private BigDecimal week52Low;
    private BigDecimal marketCap;

    private BigDecimal priceAvg50;
    private BigDecimal priceAvg200;

    private String exchange;

    private BigDecimal previousClose;
    private BigDecimal open;
        
    private Long timestamp;

}
