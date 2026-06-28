package com.neasaa.finance.provider.fmp;

import com.neasaa.finance.provider.fmp.model.FmpDividend;
import com.neasaa.finance.provider.fmp.model.FmpEarnings;
import com.neasaa.finance.provider.fmp.model.FmpPriceTargetSummary;
import com.neasaa.finance.provider.fmp.model.FmpQuote;
import com.neasaa.finance.provider.fmp.model.FmpRatingSnapshot;
import com.neasaa.finance.provider.fmp.model.FmpRatios;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Log4j2
@Component
public class FmpStockClient {

  @Value("${fmp.api.base.url}")
  private String baseUrl;

  @Value("${fmp.api.key}")
  private String apiKey;

  @Autowired
  private RestTemplate restTemplate;

  public FmpQuote fetchQuote(String symbol) {
    String url = baseUrl + "/quote?symbol=" + symbol + "&apikey=" + apiKey;
    try {
      FmpQuote[] quotes = restTemplate.getForObject(url, FmpQuote[].class);
      if (quotes != null && quotes.length > 0) {
        return quotes[0];
      }
      log.warn("No quote returned from FMP for symbol {}", symbol);
      return null;
    } catch (Exception e) {
      log.error("Failed to fetch quote from FMP for symbol {}", symbol, e);
      throw new RuntimeException("Failed to fetch quote for " + symbol, e);
    }
  }

  public List<FmpDividend> fetchDividends(String symbol) {
    String url = baseUrl + "/dividends?symbol=" + symbol + "&apikey=" + apiKey;
    try {
      FmpDividend[] dividends = restTemplate.getForObject(url, FmpDividend[].class);
      if (dividends != null && dividends.length > 0) {
        return Arrays.asList(dividends);
      }
      log.warn("No dividends returned from FMP for symbol {}", symbol);
      return Collections.emptyList();
    } catch (Exception e) {
      log.error("Failed to fetch dividends from FMP for symbol {}", symbol, e);
      throw new RuntimeException("Failed to fetch dividends for " + symbol, e);
    }
  }

  public List<FmpEarnings> fetchEarnings(String symbol) {
    String url = baseUrl + "/earnings?symbol=" + symbol + "&apikey=" + apiKey;
    try {
      FmpEarnings[] earnings = restTemplate.getForObject(url, FmpEarnings[].class);
      if (earnings != null && earnings.length > 0) {
        return Arrays.asList(earnings);
      }
      log.warn("No earnings returned from FMP for symbol {}", symbol);
      return Collections.emptyList();
    } catch (Exception e) {
      log.error("Failed to fetch earnings from FMP for symbol {}", symbol, e);
      throw new RuntimeException("Failed to fetch earnings for " + symbol, e);
    }
  }

  public FmpPriceTargetSummary fetchPriceTargetSummary(String symbol) {
    String url = baseUrl + "/price-target-summary?symbol=" + symbol + "&apikey=" + apiKey;
    try {
      FmpPriceTargetSummary[] results = restTemplate.getForObject(url, FmpPriceTargetSummary[].class);
      if (results != null && results.length > 0) {
        return results[0];
      }
      log.warn("No price target summary returned from FMP for symbol {}", symbol);
      return null;
    } catch (Exception e) {
      log.error("Failed to fetch price target summary from FMP for symbol {}", symbol, e);
      throw new RuntimeException("Failed to fetch price target summary for " + symbol, e);
    }
  }

  public FmpRatingSnapshot fetchRatingSnapshot(String symbol) {
    String url = baseUrl + "/ratings-snapshot?symbol=" + symbol + "&apikey=" + apiKey;
    try {
      FmpRatingSnapshot[] results = restTemplate.getForObject(url, FmpRatingSnapshot[].class);
      if (results != null && results.length > 0) {
        return results[0];
      }
      log.warn("No rating snapshot returned from FMP for symbol {}", symbol);
      return null;
    } catch (Exception e) {
      log.error("Failed to fetch rating snapshot from FMP for symbol {}", symbol, e);
      throw new RuntimeException("Failed to fetch rating snapshot for " + symbol, e);
    }
  }

  public FmpRatios fetchRatios(String symbol) {
    String url = baseUrl + "/ratios?symbol=" + symbol + "&apikey=" + apiKey;
    try {
      FmpRatios[] ratios = restTemplate.getForObject(url, FmpRatios[].class);
      if (ratios != null && ratios.length > 0) {
        return ratios[0];
      }
      log.warn("No ratios returned from FMP for symbol {}", symbol);
      return null;
    } catch (Exception e) {
      log.error("Failed to fetch ratios from FMP for symbol {}", symbol, e);
      throw new RuntimeException("Failed to fetch ratios for " + symbol, e);
    }
  }
}
