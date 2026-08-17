package com.neasaa.finance.service.account.parser.snapshot;

import com.neasaa.csv.parser.CSVRowMapper;
import com.neasaa.csv.parser.RecordFilter;
import com.neasaa.util.MathUtils;
import com.neasaa.base.app.operation.AuditInfo;
import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import com.neasaa.finance.util.FidelityUtil;
import com.neasaa.finance.util.OptionSymbol;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import org.apache.commons.csv.CSVRecord;

public class FidelityAccountSnapshotRowMapper extends CSVRowMapper<AccountSnapshot> {

  public static final String COL_ACCOUNT_NUMBER = "Account Number";
  public static final String COL_ACCOUNT_NAME = "Account Name";
  public static final String COL_SYMBOL = "Symbol";
  public static final String COL_DESCRIPTION = "Description";
  public static final String COL_QUANTITY = "Quantity";
  public static final String COL_LAST_PRICE = "Last Price";
  public static final String COL_LAST_PRICE_CHANGE = "Last Price Change";
  public static final String COL_CURRENT_VALUE = "Current Value";
  public static final String COL_TODAY_GAIN_LOSS = "Today's Gain/Loss Dollar";
  public static final String COL_TODAY_GAIN_LOSS_PCT = "Today's Gain/Loss Percent";
  public static final String COL_TOTAL_GAIN_LOSS = "Total Gain/Loss Dollar";
  public static final String COL_TOTAL_GAIN_LOSS_PCT = "Total Gain/Loss Percent";
  public static final String COL_PERCENT_OF_ACCOUNT = "Percent Of Account";
  public static final String COL_COST_BASIS_TOTAL = "Cost Basis Total";
  public static final String COL_AVERAGE_COST_BASIS = "Average Cost Basis";
  public static final String COL_TYPE = "Type";

  public static final List<String> COLUMN_NAMES =
      List.of(
          COL_ACCOUNT_NUMBER,
          COL_ACCOUNT_NAME,
          COL_SYMBOL,
          COL_DESCRIPTION,
          COL_QUANTITY,
          COL_LAST_PRICE,
          COL_LAST_PRICE_CHANGE,
          COL_CURRENT_VALUE,
          COL_TODAY_GAIN_LOSS,
          COL_TODAY_GAIN_LOSS_PCT,
          COL_TOTAL_GAIN_LOSS,
          COL_TOTAL_GAIN_LOSS_PCT,
          COL_PERCENT_OF_ACCOUNT,
          COL_COST_BASIS_TOTAL,
          COL_AVERAGE_COST_BASIS,
          COL_TYPE);

  private final LocalDate snapshotDate;
  private final long accountId;
  private final AuditInfo auditInfo;

  public FidelityAccountSnapshotRowMapper(LocalDate snapshotDate, long accountId, AuditInfo auditInfo) {
    super(new FidelityRecordFilter());
    this.snapshotDate = snapshotDate;
    this.accountId = accountId;
    this.auditInfo = auditInfo;
  }

  @Override
  public AccountSnapshot mapRow(CSVRecord csvRecord, long rowNum) {
    if (!includeInResult(csvRecord.toString())) {
      return null;
    }
    String rawSymbol = getCSVColumnValue(csvRecord, COL_SYMBOL);
    String description = getCSVColumnValue(csvRecord, COL_DESCRIPTION);
		if(rawSymbol == null || rawSymbol.isEmpty()) {
			rawSymbol = description;
		}
    if (rawSymbol == null
        || rawSymbol.isEmpty()) {
      return null;
    }

    String symbol;
    OptionSymbol parsedOptionSymbol = null;
    if (FidelityUtil.isOptionTxn(rawSymbol)) {
      parsedOptionSymbol = OptionSymbol.parse(rawSymbol);
      symbol = parsedOptionSymbol.getUnderlyingSymbol();
    } else  if (isSpecialSymbol(rawSymbol)) {
      symbol = getSpecialSymbol(rawSymbol);
    } else {
      symbol = rawSymbol;
    }
    
    if(isSpecialSymbol(rawSymbol)) {
      BigDecimal currentValue = parseFidelityDecimalValue(csvRecord, COL_CURRENT_VALUE);
      return AccountSnapshot.builder()
        .accountId(accountId)
        .accountNumber(getCSVColumnValue(csvRecord, COL_ACCOUNT_NUMBER))
        .snapshotDate(snapshotDate)
        .symbol(symbol)
        .optionSymbol(parsedOptionSymbol)
        .description(description)
        .quantity(currentValue)
        .lastPrice(BigDecimal.ONE)
        .lastPriceChange(BigDecimal.ZERO)
        .currentValue(currentValue)
        .todayGainLoss(BigDecimal.ZERO)
        .totalGainLoss(BigDecimal.ZERO)
        .percentOfAccount(parseFidelityDecimalValue(csvRecord, COL_PERCENT_OF_ACCOUNT))
        .totalCostBasis(currentValue)
        .averageCostBasis(BigDecimal.ONE)
        .createdBy(auditInfo.getCreatedBy())
        .createdDate(auditInfo.getCreatedDate())
        .lastUpdatedBy(auditInfo.getLastUpdatedBy())
        .lastUpdatedDate(auditInfo.getLastUpdatedDate())
        .build();
    }

    return AccountSnapshot.builder()
        .accountId(accountId)
        .accountNumber(getCSVColumnValue(csvRecord, COL_ACCOUNT_NUMBER))
        .snapshotDate(snapshotDate)
        .symbol(symbol)
        .optionSymbol(parsedOptionSymbol)
        .description(description)
        .quantity(parseBigDecimal(getCSVColumnValue(csvRecord, COL_QUANTITY)))
        .lastPrice(parseFidelityDecimalValue(csvRecord, COL_LAST_PRICE))
        .lastPriceChange(parseFidelityDecimalValue(csvRecord, COL_LAST_PRICE_CHANGE))
        .currentValue(parseFidelityDecimalValue(csvRecord, COL_CURRENT_VALUE))
        .todayGainLoss(parseFidelityDecimalValue(csvRecord, COL_TODAY_GAIN_LOSS))
        .totalGainLoss(parseFidelityDecimalValue(csvRecord, COL_TOTAL_GAIN_LOSS))
        .percentOfAccount(parseFidelityDecimalValue(csvRecord, COL_PERCENT_OF_ACCOUNT))
        .totalCostBasis(parseFidelityDecimalValue(csvRecord, COL_COST_BASIS_TOTAL))
        .averageCostBasis(parseFidelityDecimalValue(csvRecord, COL_AVERAGE_COST_BASIS))
        .createdBy(auditInfo.getCreatedBy())
        .createdDate(auditInfo.getCreatedDate())
        .lastUpdatedBy(auditInfo.getLastUpdatedBy())
        .lastUpdatedDate(auditInfo.getLastUpdatedDate())
        .build();
  }

  private BigDecimal parseBigDecimal(String raw) {
    if (raw == null) {
      return null;
    }
    String cleaned = raw.trim().replace("$", "").replace(",", "").replace("+", "");
    if (cleaned.isEmpty() || cleaned.equals("--")) {
      return null;
    }
    return new BigDecimal(cleaned);
  }

  private BigDecimal parsePercent(String raw) {
    if (raw == null) {
      return null;
    }
    String cleaned = raw.trim().replace("%", "").replace("+", "");
    if (cleaned.isEmpty() || cleaned.equals("--")) {
      return null;
    }
    return new BigDecimal(cleaned);
  }

  private boolean isSpecialSymbol (String symbol) {
		if(symbol.equals("SPAXX**") || symbol.equals("FDRXX**")) {
			return true;
		}
		return false;
	}

  private String getSpecialSymbol(String snapshotSymbol) {
		if(snapshotSymbol.equals("SPAXX**")) {
			return "SPAXX";
		} else if(snapshotSymbol.equals("FDRXX**")) {
			return "FDRXX";
		} else if(snapshotSymbol.equalsIgnoreCase("Pending Activity")) {
      return "CASH";
    }
		return null;
	}

  protected BigDecimal parseFidelityDecimalValue (CSVRecord aCSVRecord, String aColumnName) {
		String strValue = aCSVRecord.get(aColumnName);
		if(strValue == null || strValue.isEmpty()) {
			throw new RuntimeException ("Column value is not specified for " + aColumnName);
		}
		if(strValue.equals("n/a")) {
			return MathUtils.ZERO_VALUE;
		}
		if(strValue.equals("--")) {
			return MathUtils.ZERO_VALUE;
		}
		if(strValue.indexOf('$') != -1) {
			strValue = strValue.replaceAll("\\$", "");
		}
		if(strValue.indexOf(',') != -1) {
			strValue = strValue.replaceAll(",", "");
		}
		if(strValue.endsWith("%")) {
			strValue = strValue.replaceAll("%", "");
		}
		if(strValue.startsWith("(")) {
			strValue = strValue.substring(1);
			strValue = strValue.substring(0,strValue.length()-1);
			strValue = "-" + strValue;
		}
		return new BigDecimal(strValue);
	}

  private static class FidelityRecordFilter implements RecordFilter {

    @Override
    public boolean includeInResult(String rowLineContent) {
      if (rowLineContent == null || rowLineContent.isBlank()) {
        return false;
      }
      String lower = rowLineContent.toLowerCase();
      return !lower.contains("date downloaded")
          && !lower.contains("the data and information in this spreadsheet")
          && !lower.contains("brokerage services are provided by fidelity")
          // TODO: Currently ignoring the pending activity. Need to support this gradually.
          && !lower.contains("pending activity");
    }
  }
}
