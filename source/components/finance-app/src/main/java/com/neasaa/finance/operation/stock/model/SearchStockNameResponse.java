package com.neasaa.finance.operation.stock.model;

import com.neasaa.base.app.operation.model.OperationResponse;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SearchStockNameResponse extends OperationResponse {

    @Getter
    @Setter
    @Builder
    @AllArgsConstructor
    public static class StockSuggestion {
        private String symbol;
        private String name;
        private String type;
    }

    private List<StockSuggestion> stockList;

    public SearchStockNameResponse() {
    }
}
