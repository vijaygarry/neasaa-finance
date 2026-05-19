package com.neasaa.finance.operation.stock.model;

import com.neasaa.base.app.operation.model.OperationRequest;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StockSuggestionRequest extends OperationRequest {
    private String query;

    public StockSuggestionRequest() {
    }

    @Override
    public void normalize() {
        if (query != null) {
            query = query.trim();
        }
    }
}
