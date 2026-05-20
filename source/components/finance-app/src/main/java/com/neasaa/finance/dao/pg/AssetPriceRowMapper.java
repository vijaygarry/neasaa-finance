package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.finance.dao.entity.AssetPrice;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

public class AssetPriceRowMapper implements RowMapper<AssetPrice> {

  @Override
  public AssetPrice mapRow(ResultSet aRs, int aRowNum) throws SQLException {
    AssetPrice assetPrice = new AssetPrice();
    assetPrice.setAssetId(aRs.getInt("ASSETID"));
    assetPrice.setCurrentPrice(aRs.getBigDecimal("CURRENTPRICE"));
    assetPrice.setPreviousClose(aRs.getBigDecimal("PREVIOUSCLOSE"));
    assetPrice.setMarketOpen(aRs.getBigDecimal("MARKETOPEN"));
    assetPrice.setDayHigh(aRs.getBigDecimal("DAYHIGH"));
    assetPrice.setDayLow(aRs.getBigDecimal("DAYLOW"));
    assetPrice.setMarketChange(aRs.getBigDecimal("MARKETCHANGE"));
    assetPrice.setMarketChangePercent(aRs.getBigDecimal("MARKETCHANGEPERCENT"));
    assetPrice.setVolume(aRs.getObject("VOLUME", Long.class));
    assetPrice.setMarketTime(AbstractDao.getTimestampFromResultSet(aRs, "MARKETTIME"));
    assetPrice.setBid(aRs.getBigDecimal("BID"));
    assetPrice.setAsk(aRs.getBigDecimal("ASK"));
    assetPrice.setBidSize(aRs.getObject("BIDSIZE", Integer.class));
    assetPrice.setAskSize(aRs.getObject("ASKSIZE", Integer.class));
    assetPrice.setPreMarketPrice(aRs.getBigDecimal("PREMARKETPRICE"));
    assetPrice.setPreMarketChange(aRs.getBigDecimal("PREMARKETCHANGE"));
    assetPrice.setPreMarketChangePercent(aRs.getBigDecimal("PREMARKETCHANGEPERCENT"));
    assetPrice.setWeek52High(aRs.getBigDecimal("WEEK52HIGH"));
    assetPrice.setWeek52Low(aRs.getBigDecimal("WEEK52LOW"));
    assetPrice.setFiftyDayAverage(aRs.getBigDecimal("FIFTYDAYAVERAGE"));
    assetPrice.setFiftyDayAverageChange(aRs.getBigDecimal("FIFTYDAYAVERAGECHANGE"));
    assetPrice.setTwoHundredDayAverage(aRs.getBigDecimal("TWOHUNDREDDAYAVERAGE"));
    assetPrice.setTwoHundredDayAverageChange(aRs.getBigDecimal("TWOHUNDREDDAYAVERAGECHANGE"));
    assetPrice.setAvgDailyVolume3Month(aRs.getObject("AVGDAILYVOLUME3MONTH", Long.class));
    assetPrice.setAvgDailyVolume10Day(aRs.getObject("AVGDAILYVOLUME10DAY", Long.class));
    assetPrice.setMarketCap(aRs.getBigDecimal("MARKETCAP"));
    assetPrice.setDividendYield(aRs.getBigDecimal("DIVIDENDYIELD"));
    assetPrice.setCreatedBy(aRs.getInt("CREATEDBY"));
    assetPrice.setCreatedDate(AbstractDao.getTimestampFromResultSet(aRs, "CREATEDDATE"));
    assetPrice.setLastUpdatedBy(aRs.getInt("LASTUPDATEDBY"));
    assetPrice.setLastUpdatedDate(AbstractDao.getTimestampFromResultSet(aRs, "LASTUPDATEDDATE"));
    return assetPrice;
  }
}
