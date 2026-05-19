package com.neasaa.finance.operation.stock;

import com.neasaa.base.app.operation.AbstractOperation;
import com.neasaa.base.app.operation.exception.OperationException;
import com.neasaa.finance.operation.FinanceOperationNames;
import com.neasaa.finance.operation.stock.model.StockSuggestionRequest;
import com.neasaa.finance.operation.stock.model.StockSuggestionResponse;
import lombok.extern.log4j.Log4j2;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.util.List;

@Log4j2
@Component("StockSuggestionOperation")
@Scope("prototype")
public class StockSuggestionOperation extends AbstractOperation<StockSuggestionRequest, StockSuggestionResponse> {

    @Override
    public String getOperationName() {
        return FinanceOperationNames.STOCK_SUGGESTION;
    }

    @Override
    public void doValidate(StockSuggestionRequest opRequest) throws OperationException {

    }

    @Override
    public StockSuggestionResponse doExecute (StockSuggestionRequest request) throws OperationException {

        StockSuggestionResponse response = new StockSuggestionResponse();
        if (request.getQuery() == null || request.getQuery().isBlank()) {
            response.setStockList(List.of());
            return response;
        }
        if(request.getQuery().equalsIgnoreCase("AAPL")) {
            StockSuggestionResponse.StockSuggestion stockSuggestion = StockSuggestionResponse.StockSuggestion.builder()
                    .symbol("AAPL")
                    .name("Apple Inc.")
                    .type("Equity")
                    .build();
            response.setStockList(List.of(stockSuggestion));
            return response;
        }
        response.setStockList(List.of());
        return response;
    }

}
