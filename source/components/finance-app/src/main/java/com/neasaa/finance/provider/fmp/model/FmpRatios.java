package com.neasaa.finance.provider.fmp.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class FmpRatios {

  @JsonProperty("symbol")
  private String symbol;

  @JsonProperty("date")
  private String date;

  @JsonProperty("fiscalYear")
  private String fiscalYear;

  @JsonProperty("period")
  private String period;

  @JsonProperty("reportedCurrency")
  private String reportedCurrency;

  @JsonProperty("grossProfitMargin")
  private BigDecimal grossProfitMargin;

  @JsonProperty("ebitMargin")
  private BigDecimal ebitMargin;

  @JsonProperty("ebitdaMargin")
  private BigDecimal ebitdaMargin;

  @JsonProperty("operatingProfitMargin")
  private BigDecimal operatingProfitMargin;

  @JsonProperty("pretaxProfitMargin")
  private BigDecimal pretaxProfitMargin;

  @JsonProperty("continuousOperationsProfitMargin")
  private BigDecimal continuousOperationsProfitMargin;

  @JsonProperty("netProfitMargin")
  private BigDecimal netProfitMargin;

  @JsonProperty("bottomLineProfitMargin")
  private BigDecimal bottomLineProfitMargin;

  @JsonProperty("receivablesTurnover")
  private BigDecimal receivablesTurnover;

  @JsonProperty("payablesTurnover")
  private BigDecimal payablesTurnover;

  @JsonProperty("inventoryTurnover")
  private BigDecimal inventoryTurnover;

  @JsonProperty("fixedAssetTurnover")
  private BigDecimal fixedAssetTurnover;

  @JsonProperty("assetTurnover")
  private BigDecimal assetTurnover;

  @JsonProperty("currentRatio")
  private BigDecimal currentRatio;

  @JsonProperty("quickRatio")
  private BigDecimal quickRatio;

  @JsonProperty("solvencyRatio")
  private BigDecimal solvencyRatio;

  @JsonProperty("cashRatio")
  private BigDecimal cashRatio;

  @JsonProperty("priceToEarningsRatio")
  private BigDecimal priceToEarningsRatio;

  @JsonProperty("priceToEarningsGrowthRatio")
  private BigDecimal priceToEarningsGrowthRatio;

  @JsonProperty("forwardPriceToEarningsGrowthRatio")
  private BigDecimal forwardPriceToEarningsGrowthRatio;

  @JsonProperty("priceToBookRatio")
  private BigDecimal priceToBookRatio;

  @JsonProperty("priceToSalesRatio")
  private BigDecimal priceToSalesRatio;

  @JsonProperty("priceToFreeCashFlowRatio")
  private BigDecimal priceToFreeCashFlowRatio;

  @JsonProperty("priceToOperatingCashFlowRatio")
  private BigDecimal priceToOperatingCashFlowRatio;

  @JsonProperty("debtToAssetsRatio")
  private BigDecimal debtToAssetsRatio;

  @JsonProperty("debtToEquityRatio")
  private BigDecimal debtToEquityRatio;

  @JsonProperty("debtToCapitalRatio")
  private BigDecimal debtToCapitalRatio;

  @JsonProperty("longTermDebtToCapitalRatio")
  private BigDecimal longTermDebtToCapitalRatio;

  @JsonProperty("financialLeverageRatio")
  private BigDecimal financialLeverageRatio;

  @JsonProperty("workingCapitalTurnoverRatio")
  private BigDecimal workingCapitalTurnoverRatio;

  @JsonProperty("operatingCashFlowRatio")
  private BigDecimal operatingCashFlowRatio;

  @JsonProperty("operatingCashFlowSalesRatio")
  private BigDecimal operatingCashFlowSalesRatio;

  @JsonProperty("freeCashFlowOperatingCashFlowRatio")
  private BigDecimal freeCashFlowOperatingCashFlowRatio;

  @JsonProperty("debtServiceCoverageRatio")
  private BigDecimal debtServiceCoverageRatio;

  @JsonProperty("interestCoverageRatio")
  private BigDecimal interestCoverageRatio;

  @JsonProperty("shortTermOperatingCashFlowCoverageRatio")
  private BigDecimal shortTermOperatingCashFlowCoverageRatio;

  @JsonProperty("operatingCashFlowCoverageRatio")
  private BigDecimal operatingCashFlowCoverageRatio;

  @JsonProperty("capitalExpenditureCoverageRatio")
  private BigDecimal capitalExpenditureCoverageRatio;

  @JsonProperty("dividendPaidAndCapexCoverageRatio")
  private BigDecimal dividendPaidAndCapexCoverageRatio;

  @JsonProperty("dividendPayoutRatio")
  private BigDecimal dividendPayoutRatio;

  @JsonProperty("dividendYield")
  private BigDecimal dividendYield;

  @JsonProperty("dividendYieldPercentage")
  private BigDecimal dividendYieldPercentage;

  @JsonProperty("revenuePerShare")
  private BigDecimal revenuePerShare;

  @JsonProperty("netIncomePerShare")
  private BigDecimal netIncomePerShare;

  @JsonProperty("interestDebtPerShare")
  private BigDecimal interestDebtPerShare;

  @JsonProperty("cashPerShare")
  private BigDecimal cashPerShare;

  @JsonProperty("bookValuePerShare")
  private BigDecimal bookValuePerShare;

  @JsonProperty("tangibleBookValuePerShare")
  private BigDecimal tangibleBookValuePerShare;

  @JsonProperty("shareholdersEquityPerShare")
  private BigDecimal shareholdersEquityPerShare;

  @JsonProperty("operatingCashFlowPerShare")
  private BigDecimal operatingCashFlowPerShare;

  @JsonProperty("capexPerShare")
  private BigDecimal capexPerShare;

  @JsonProperty("freeCashFlowPerShare")
  private BigDecimal freeCashFlowPerShare;

  @JsonProperty("netIncomePerEBT")
  private BigDecimal netIncomePerEBT;

  @JsonProperty("ebtPerEbit")
  private BigDecimal ebtPerEbit;

  @JsonProperty("priceToFairValue")
  private BigDecimal priceToFairValue;

  @JsonProperty("debtToMarketCap")
  private BigDecimal debtToMarketCap;

  @JsonProperty("effectiveTaxRate")
  private BigDecimal effectiveTaxRate;

  @JsonProperty("enterpriseValueMultiple")
  private BigDecimal enterpriseValueMultiple;

}
