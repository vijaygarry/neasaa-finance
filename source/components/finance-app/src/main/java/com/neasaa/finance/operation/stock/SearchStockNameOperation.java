package com.neasaa.finance.operation.stock;

import com.neasaa.base.app.operation.AbstractOperation;
import com.neasaa.base.app.operation.exception.OperationException;
import com.neasaa.finance.dao.entity.Asset;
import com.neasaa.finance.dao.pg.AssetDao;
import com.neasaa.finance.operation.FinanceOperationNames;
import com.neasaa.finance.operation.stock.model.SearchStockNameRequest;
import com.neasaa.finance.operation.stock.model.SearchStockNameResponse;
import com.neasaa.finance.operation.stock.model.SearchStockNameResponse.StockSuggestion;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component("SearchStockNameOperation")
@Scope("prototype")
public class SearchStockNameOperation extends AbstractOperation<SearchStockNameRequest, SearchStockNameResponse> {

    @Autowired
    private AssetDao assetDao;

    @Override
    public String getOperationName() {
        return FinanceOperationNames.SEARCH_STOCK_NAME;
    }

    @Override
    public void doValidate(SearchStockNameRequest opRequest) throws OperationException {
    }

    @Override
    public SearchStockNameResponse doExecute(SearchStockNameRequest request) throws OperationException {
        SearchStockNameResponse response = new SearchStockNameResponse();

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
