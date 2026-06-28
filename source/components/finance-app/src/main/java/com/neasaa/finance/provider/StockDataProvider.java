package com.neasaa.finance.provider;

import com.neasaa.finance.provider.model.StockFundamentalsData;
import com.neasaa.finance.provider.model.StockPriceData;

public interface StockDataProvider {

    StockPriceData fetchStockPrice(String symbol);

    StockFundamentalsData fetchStockFundamentals(String symbol);
}
