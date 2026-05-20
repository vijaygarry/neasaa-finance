package com.neasaa.finance.operation.stock;

import com.neasaa.base.app.operation.AbstractOperation;
import com.neasaa.base.app.operation.exception.OperationException;
import com.neasaa.finance.dao.entity.Asset;
import com.neasaa.finance.dao.pg.AssetDao;
import com.neasaa.finance.operation.FinanceOperationNames;
import com.neasaa.finance.operation.stock.model.StockSuggestionRequest;
import com.neasaa.finance.operation.stock.model.StockSuggestionResponse;
import com.neasaa.finance.operation.stock.model.StockSuggestionResponse.StockSuggestion;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Log4j2
@Component("StockSuggestionOperation")
@Scope("prototype")
public class StockSuggestionOperation extends AbstractOperation<StockSuggestionRequest, StockSuggestionResponse> {

    @Autowired
    private AssetDao assetDao;

    @Override
    public String getOperationName() {
        return FinanceOperationNames.STOCK_SUGGESTION;
    }

    @Override
    public void doValidate(StockSuggestionRequest opRequest) throws OperationException {
    }

    @Override
    public StockSuggestionResponse doExecute(StockSuggestionRequest request) throws OperationException {
        StockSuggestionResponse response = new StockSuggestionResponse();

        if (request.getQuery() == null || request.getQuery().isBlank()) {
            response.setStockList(List.of());
            return response;
        }

        List<Asset> assets = assetDao.searchBySymbolOrName(request.getQuery());

        List<StockSuggestion> stockList = assets.stream()
                .map(asset -> StockSuggestion.builder()
                        .symbol(asset.getSymbol())
                        .name(asset.getDisplayName() != null ? asset.getDisplayName() : asset.getName())
                        .type(asset.getAssetType())
                        .build())
                .toList();

        response.setStockList(stockList);
        return response;
    }
}
