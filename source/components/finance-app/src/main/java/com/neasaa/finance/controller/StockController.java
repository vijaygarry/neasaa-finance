package com.neasaa.finance.controller;

import com.neasaa.finance.operation.stock.StockSuggestionOperation;
import com.neasaa.finance.operation.stock.model.StockSuggestionRequest;
import com.neasaa.finance.operation.stock.model.StockSuggestionResponse;
import com.neasaa.finance.webutils.WebRequestHandler;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@Log4j2
@RestController
@RequestMapping("/api/stocks")
public class StockController {

    @RequestMapping(value = "/search")
    @ResponseBody
    public ResponseEntity<StockSuggestionResponse> getStockSuggestion(@RequestBody StockSuggestionRequest request)
            throws Exception {
        return WebRequestHandler.processRequest(StockSuggestionOperation.class, request);
    }

    @GetMapping("/details/{symbol}")
    public ResponseEntity details(@PathVariable String symbol) {

//        StockDetail detail = stockService.getStockDetails(symbol.toUpperCase().trim());
//        if (detail == null) {
//            return ResponseEntity.notFound().build();
//        }
//        return ResponseEntity.ok(detail);
        return null;
    }    
}
