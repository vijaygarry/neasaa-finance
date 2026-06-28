package com.neasaa.finance.provider.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class StockFundamentalsData {

    private String symbol;

    private BigDecimal priceToEarningsRatioTtm;
    private BigDecimal forwardPriceToEarningsGrowthRatio;
    private BigDecimal earningsPerShareTtm; // netIncomePerShare

    private BigDecimal dividendRate;
    private LocalDate dividendExDate;
    private LocalDate dividendPayDate;

    private LocalDate nextEarningsDate;
    private LocalDate earningsStartDate;
    private LocalDate earningsEndDate;

    private BigDecimal averageAnalystRating;
    private String analystRatingLevel;
    private BigDecimal oneYearPriceTarget;
}
