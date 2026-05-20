package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.finance.dao.entity.AssetFundamentals;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

public class AssetFundamentalsRowMapper implements RowMapper<AssetFundamentals> {

  @Override
  public AssetFundamentals mapRow(ResultSet aRs, int aRowNum) throws SQLException {
    AssetFundamentals assetFundamentals = new AssetFundamentals();
    assetFundamentals.setAssetId(aRs.getInt("ASSETID"));
    assetFundamentals.setPeTtm(aRs.getBigDecimal("PETTM"));
    assetFundamentals.setPeFtm(aRs.getBigDecimal("PEFTM"));
    assetFundamentals.setEpsTtm(aRs.getBigDecimal("EPSTTM"));
    assetFundamentals.setEpsForward(aRs.getBigDecimal("EPSFORWARD"));
    assetFundamentals.setEpsCurrentYear(aRs.getBigDecimal("EPSCURRENTYEAR"));
    assetFundamentals.setPriceEpsCurrentYear(aRs.getBigDecimal("PRICEEPSCURRENTYEAR"));
    assetFundamentals.setDividendRate(aRs.getBigDecimal("DIVIDENDRATE"));
    assetFundamentals.setDividendExDate(AbstractDao.getLocalDateFromResultSet(aRs, "DIVIDENDEXDATE"));
    assetFundamentals.setDividendPayDate(AbstractDao.getLocalDateFromResultSet(aRs, "DIVIDENDPAYDATE"));
    assetFundamentals.setNextEarningsDate(AbstractDao.getLocalDateFromResultSet(aRs, "NEXTEARNINGSDATE"));
    assetFundamentals.setEarningsStartDate(AbstractDao.getLocalDateFromResultSet(aRs, "EARNINGSSTARTDATE"));
    assetFundamentals.setEarningsEndDate(AbstractDao.getLocalDateFromResultSet(aRs, "EARNINGSENDDATE"));
    assetFundamentals.setAverageAnalystRating(aRs.getBigDecimal("AVERAGEANALYSTRATING"));
    assetFundamentals.setAnalystRatingLevel(aRs.getString("ANALYSTRATINGLEVEL"));
    assetFundamentals.setOneYearPriceTarget(aRs.getBigDecimal("ONEYEARPRICETARGET"));
    assetFundamentals.setPriceTargetUpdatedDate(AbstractDao.getLocalDateFromResultSet(aRs, "PRICETARGETUPDATEDDATE"));
    assetFundamentals.setCreatedBy(aRs.getInt("CREATEDBY"));
    assetFundamentals.setCreatedDate(AbstractDao.getTimestampFromResultSet(aRs, "CREATEDDATE"));
    assetFundamentals.setLastUpdatedBy(aRs.getInt("LASTUPDATEDBY"));
    assetFundamentals.setLastUpdatedDate(AbstractDao.getTimestampFromResultSet(aRs, "LASTUPDATEDDATE"));
    return assetFundamentals;
  }
}
