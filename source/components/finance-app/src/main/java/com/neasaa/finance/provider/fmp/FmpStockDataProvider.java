package com.neasaa.finance.provider.fmp;

import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.provider.StockDataProvider;
import com.neasaa.finance.provider.fmp.model.FmpDividend;
import com.neasaa.finance.provider.fmp.model.FmpEarnings;
import com.neasaa.finance.provider.fmp.model.FmpPriceTargetSummary;
import com.neasaa.finance.provider.fmp.model.FmpQuote;
import com.neasaa.finance.provider.fmp.model.FmpRatingSnapshot;
import com.neasaa.finance.provider.fmp.model.FmpRatios;
import java.math.BigDecimal;
import com.neasaa.finance.provider.model.StockFundamentalsData;
import com.neasaa.finance.provider.model.StockPriceData;
import java.time.LocalDate;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FmpStockDataProvider implements StockDataProvider {

    @Autowired
    private FmpStockClient fmpStockClient;

    @Override
    public StockPriceData fetchStockPrice(String symbol) {
        FmpQuote quote = fmpStockClient.fetchQuote(symbol);

        if (quote == null) {
            throw new InternalServerException("No data returned from FMP for symbol " + symbol);
        }

        return StockPriceData.builder()
                .symbol(quote.getSymbol())
                .currentPrice(quote.getPrice())
                .changePercentage(quote.getChangePercentage())
                .change(quote.getChange())
                .volume(quote.getVolume())
                .dayHigh(quote.getDayHigh())
                .dayLow(quote.getDayLow())
                .week52High(quote.getYearHigh())
                .week52Low(quote.getYearLow())
                .marketCap(quote.getMarketCap())
                .priceAvg50(quote.getPriceAvg50())
                .priceAvg200(quote.getPriceAvg200())
                .exchange(quote.getExchange())
                .previousClose(quote.getPreviousClose())
                .open(quote.getOpen())
                .timestamp(quote.getTimestamp())
                .build();
    }

    @Override
    public StockFundamentalsData fetchStockFundamentals(String symbol) {
        FmpRatios ratios = fmpStockClient.fetchRatios(symbol);
        List<FmpDividend> dividends = fmpStockClient.fetchDividends(symbol);
        List<FmpEarnings> earningsList = fmpStockClient.fetchEarnings(symbol);
        FmpPriceTargetSummary priceTargetSummary = fmpStockClient.fetchPriceTargetSummary(symbol);
        FmpRatingSnapshot ratingSnapshot = fmpStockClient.fetchRatingSnapshot(symbol);

        StockFundamentalsData.StockFundamentalsDataBuilder builder = StockFundamentalsData.builder()
                .symbol(symbol);

        if (ratios != null) {
            builder.priceToEarningsRatioTtm(ratios.getPriceToEarningsRatio())
                   .forwardPriceToEarningsGrowthRatio(ratios.getForwardPriceToEarningsGrowthRatio())
                   .earningsPerShareTtm(ratios.getNetIncomePerShare());
        }

        if (!dividends.isEmpty()) {
            FmpDividend latest = dividends.get(0);
            builder.dividendRate(latest.getDividend());
            if (latest.getDate() != null) {
                builder.dividendExDate(LocalDate.parse(latest.getDate()));
            }
            if (latest.getPaymentDate() != null) {
                builder.dividendPayDate(LocalDate.parse(latest.getPaymentDate()));
            }
        }

        earningsList.stream()
                .filter(e -> e.getEpsActual() == null && e.getDate() != null)
                .findFirst()
                .ifPresent(next -> {
                    LocalDate nextDate = LocalDate.parse(next.getDate());
                    builder.nextEarningsDate(nextDate)
                           .earningsStartDate(nextDate)
                           .earningsEndDate(nextDate);
                });

        if (priceTargetSummary != null) {
            builder.oneYearPriceTarget(priceTargetSummary.getLastYearAvgPriceTarget());
        }

        if (ratingSnapshot != null) {
            builder.analystRatingLevel(ratingSnapshot.getRating())
                   .averageAnalystRating(ratingSnapshot.getOverallScore() != null
                           ? BigDecimal.valueOf(ratingSnapshot.getOverallScore()) : null);
        }

        return builder.build();
    }
}
