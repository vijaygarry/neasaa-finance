package com.neasaa.finance.dao.pg.account;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import com.neasaa.finance.util.OptionSymbol;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

public class AccountSnapshotRowMapper implements RowMapper<AccountSnapshot> {

  @Override
  public AccountSnapshot mapRow(ResultSet aRs, int aRowNum) throws SQLException {
    String symbol = aRs.getString("SYMBOL");
    String rawOptionSymbol = aRs.getString("OPTIONSYMBOL");

    OptionSymbol parsedOptionSymbol = null;
    if (rawOptionSymbol != null && !rawOptionSymbol.equals(symbol)) {
      parsedOptionSymbol = OptionSymbol.parse(rawOptionSymbol);
    }

    return AccountSnapshot.builder()
        .accountId(aRs.getLong("ACCOUNTID"))
        .snapshotDate(AbstractDao.getLocalDateFromResultSet(aRs, "SNAPSHOTDATE"))
        .symbol(symbol)
        .optionSymbol(parsedOptionSymbol)
        .description(aRs.getString("DESCRIPTION"))
        .quantity(aRs.getBigDecimal("QUANTITY"))
        .lastPrice(aRs.getBigDecimal("LASTPRICE"))
        .lastPriceChange(aRs.getBigDecimal("LASTPRICECHANGE"))
        .currentValue(aRs.getBigDecimal("CURRENTVALUE"))
        .averageCostBasis(aRs.getBigDecimal("AVERAGECOSTBASIS"))
        .totalCostBasis(aRs.getBigDecimal("TOTALCOSTBASIS"))
        .todayGainLoss(aRs.getBigDecimal("TODAYGAINLOSS"))
        .totalGainLoss(aRs.getBigDecimal("TOTALGAINLOSS"))
        .percentOfAccount(aRs.getBigDecimal("PERCENTOFACCOUNT"))
        .createdBy(aRs.getInt("CREATEDBY"))
        .createdDate(AbstractDao.getTimestampFromResultSet(aRs, "CREATEDDATE"))
        .lastUpdatedBy(aRs.getInt("LASTUPDATEDBY"))
        .lastUpdatedDate(AbstractDao.getTimestampFromResultSet(aRs, "LASTUPDATEDDATE"))
        .build();
  }
}
