package com.neasaa.finance.controller;

// import com.neasaa.finance.operation.stock.GetStockDetailsOperation;
import com.neasaa.finance.operation.stock.SearchStockNameOperation;
// import com.neasaa.finance.operation.stock.model.GetStockDetailsRequest;
// import com.neasaa.finance.operation.stock.model.GetStockDetailsResponse;
import com.neasaa.finance.operation.stock.model.SearchStockNameRequest;
import com.neasaa.finance.operation.stock.model.SearchStockNameResponse;
import com.neasaa.finance.webutils.WebRequestHandler;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/stocks")
public class StockController {

    @PostMapping(value = "/search")
    @ResponseBody
    public ResponseEntity<SearchStockNameResponse> searchStockName(@RequestBody SearchStockNameRequest request)
            throws Exception {
        return WebRequestHandler.processRequest(SearchStockNameOperation.class, request);
    }

    // @PostMapping("/details")
    // public ResponseEntity<GetStockDetailsResponse> getStockDetails(@RequestBody GetStockDetailsRequest request)
    //         throws Exception {
    //     return WebRequestHandler.processRequest(GetStockDetailsOperation.class, request);
    // }
}
