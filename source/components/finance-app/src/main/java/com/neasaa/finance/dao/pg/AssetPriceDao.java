package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.dao.entity.AssetPrice;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.stereotype.Repository;

@Log4j2
@Repository
public class AssetPriceDao extends AbstractDao {

  private static final String SELECT_COLUMNS =
      "SELECT ASSETID, CURRENTPRICE, PREVIOUSCLOSE, MARKETOPEN, DAYHIGH, DAYLOW,"
          + " MARKETCHANGE, MARKETCHANGEPERCENT, VOLUME, MARKETTIME, BID, ASK, BIDSIZE, ASKSIZE,"
          + " PREMARKETPRICE, PREMARKETCHANGE, PREMARKETCHANGEPERCENT,"
          + " WEEK52HIGH, WEEK52LOW, FIFTYDAYAVERAGE, FIFTYDAYAVERAGECHANGE,"
          + " TWOHUNDREDDAYAVERAGE, TWOHUNDREDDAYAVERAGECHANGE,"
          + " AVGDAILYVOLUME3MONTH, AVGDAILYVOLUME10DAY, MARKETCAP, DIVIDENDYIELD,"
          + " CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE";

  private static final String SELECT_ALL_ASSET_PRICES =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSETPRICE";

  private static final String SELECT_ASSET_PRICE_BY_ID =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSETPRICE WHERE ASSETID = ?";

  public List<AssetPrice> getAll() {
    try {
      return getJdbcTemplate().query(SELECT_ALL_ASSET_PRICES, new AssetPriceRowMapper());
    } catch (Exception e) {
      log.error("Failed to get all asset prices", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public AssetPrice getByAssetId(int assetId) {
    try {
      List<AssetPrice> result =
          getJdbcTemplate().query(SELECT_ASSET_PRICE_BY_ID, new AssetPriceRowMapper(), assetId);
      if (result.isEmpty()) {
        return null;
      }
      return result.get(0);
    } catch (Exception e) {
      log.error("Failed to get asset price for assetId {}", assetId, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int insert(AssetPrice aAssetPrice) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildInsertStatement(aCon, aAssetPrice);
        }
      });
    } catch (Exception e) {
      log.error("Failed to insert asset price for assetId {}", aAssetPrice.getAssetId(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int update(AssetPrice aAssetPrice) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildUpdateStatement(aCon, aAssetPrice);
        }
      });
    } catch (Exception e) {
      log.error("Failed to update asset price for assetId {}", aAssetPrice.getAssetId(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int delete(int assetId) {
    try {
      String sql = "DELETE FROM " + BASE_SCHEMA_NAME + "MSTASSETPRICE WHERE ASSETID = ?";
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          PreparedStatement ps = aCon.prepareStatement(sql);
          setIntInStatement(ps, 1, assetId);
          return ps;
        }
      });
    } catch (Exception e) {
      log.error("Failed to delete asset price for assetId {}", assetId, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  private PreparedStatement buildInsertStatement(Connection aCon, AssetPrice aAssetPrice)
      throws SQLException {
    String sql =
        "INSERT INTO " + BASE_SCHEMA_NAME + "MSTASSETPRICE"
            + " (ASSETID, CURRENTPRICE, PREVIOUSCLOSE, MARKETOPEN, DAYHIGH, DAYLOW,"
            + " MARKETCHANGE, MARKETCHANGEPERCENT, VOLUME, MARKETTIME, BID, ASK, BIDSIZE, ASKSIZE,"
            + " PREMARKETPRICE, PREMARKETCHANGE, PREMARKETCHANGEPERCENT,"
            + " WEEK52HIGH, WEEK52LOW, FIFTYDAYAVERAGE, FIFTYDAYAVERAGECHANGE,"
            + " TWOHUNDREDDAYAVERAGE, TWOHUNDREDDAYAVERAGECHANGE,"
            + " AVGDAILYVOLUME3MONTH, AVGDAILYVOLUME10DAY, MARKETCAP, DIVIDENDYIELD,"
            + " CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE)"
            + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setAssetPriceParameters(ps, aAssetPrice);
    return ps;
  }

  private PreparedStatement buildUpdateStatement(Connection aCon, AssetPrice aAssetPrice)
      throws SQLException {
    String sql =
        "UPDATE " + BASE_SCHEMA_NAME + "MSTASSETPRICE"
            + " SET CURRENTPRICE = ?, PREVIOUSCLOSE = ?, MARKETOPEN = ?, DAYHIGH = ?, DAYLOW = ?,"
            + " MARKETCHANGE = ?, MARKETCHANGEPERCENT = ?, VOLUME = ?, MARKETTIME = ?,"
            + " BID = ?, ASK = ?, BIDSIZE = ?, ASKSIZE = ?,"
            + " PREMARKETPRICE = ?, PREMARKETCHANGE = ?, PREMARKETCHANGEPERCENT = ?,"
            + " WEEK52HIGH = ?, WEEK52LOW = ?, FIFTYDAYAVERAGE = ?, FIFTYDAYAVERAGECHANGE = ?,"
            + " TWOHUNDREDDAYAVERAGE = ?, TWOHUNDREDDAYAVERAGECHANGE = ?,"
            + " AVGDAILYVOLUME3MONTH = ?, AVGDAILYVOLUME10DAY = ?, MARKETCAP = ?, DIVIDENDYIELD = ?,"
            + " LASTUPDATEDBY = ?, LASTUPDATEDDATE = ?"
            + " WHERE ASSETID = ?";
    PreparedStatement ps = aCon.prepareStatement(sql);
    // skip assetid (index 1) — set all other fields then WHERE clause
    setBigDecimalInStatement(ps, 1, aAssetPrice.getCurrentPrice());
    setBigDecimalInStatement(ps, 2, aAssetPrice.getPreviousClose());
    setBigDecimalInStatement(ps, 3, aAssetPrice.getMarketOpen());
    setBigDecimalInStatement(ps, 4, aAssetPrice.getDayHigh());
    setBigDecimalInStatement(ps, 5, aAssetPrice.getDayLow());
    setBigDecimalInStatement(ps, 6, aAssetPrice.getMarketChange());
    setBigDecimalInStatement(ps, 7, aAssetPrice.getMarketChangePercent());
    setNullableLongInStatement(ps, 8, aAssetPrice.getVolume());
    setTimestampInStatement(ps, 9, aAssetPrice.getMarketTime());
    setBigDecimalInStatement(ps, 10, aAssetPrice.getBid());
    setBigDecimalInStatement(ps, 11, aAssetPrice.getAsk());
    setNullableIntInStatement(ps, 12, aAssetPrice.getBidSize());
    setNullableIntInStatement(ps, 13, aAssetPrice.getAskSize());
    setBigDecimalInStatement(ps, 14, aAssetPrice.getPreMarketPrice());
    setBigDecimalInStatement(ps, 15, aAssetPrice.getPreMarketChange());
    setBigDecimalInStatement(ps, 16, aAssetPrice.getPreMarketChangePercent());
    setBigDecimalInStatement(ps, 17, aAssetPrice.getWeek52High());
    setBigDecimalInStatement(ps, 18, aAssetPrice.getWeek52Low());
    setBigDecimalInStatement(ps, 19, aAssetPrice.getFiftyDayAverage());
    setBigDecimalInStatement(ps, 20, aAssetPrice.getFiftyDayAverageChange());
    setBigDecimalInStatement(ps, 21, aAssetPrice.getTwoHundredDayAverage());
    setBigDecimalInStatement(ps, 22, aAssetPrice.getTwoHundredDayAverageChange());
    setNullableLongInStatement(ps, 23, aAssetPrice.getAvgDailyVolume3Month());
    setNullableLongInStatement(ps, 24, aAssetPrice.getAvgDailyVolume10Day());
    setBigDecimalInStatement(ps, 25, aAssetPrice.getMarketCap());
    setBigDecimalInStatement(ps, 26, aAssetPrice.getDividendYield());
    setIntInStatement(ps, 27, aAssetPrice.getLastUpdatedBy());
    setTimestampInStatement(ps, 28, aAssetPrice.getLastUpdatedDate());
    setIntInStatement(ps, 29, aAssetPrice.getAssetId());
    return ps;
  }

  private void setAssetPriceParameters(PreparedStatement ps, AssetPrice aAssetPrice)
      throws SQLException {
    setIntInStatement(ps, 1, aAssetPrice.getAssetId());
    setBigDecimalInStatement(ps, 2, aAssetPrice.getCurrentPrice());
    setBigDecimalInStatement(ps, 3, aAssetPrice.getPreviousClose());
    setBigDecimalInStatement(ps, 4, aAssetPrice.getMarketOpen());
    setBigDecimalInStatement(ps, 5, aAssetPrice.getDayHigh());
    setBigDecimalInStatement(ps, 6, aAssetPrice.getDayLow());
    setBigDecimalInStatement(ps, 7, aAssetPrice.getMarketChange());
    setBigDecimalInStatement(ps, 8, aAssetPrice.getMarketChangePercent());
    setNullableLongInStatement(ps, 9, aAssetPrice.getVolume());
    setTimestampInStatement(ps, 10, aAssetPrice.getMarketTime());
    setBigDecimalInStatement(ps, 11, aAssetPrice.getBid());
    setBigDecimalInStatement(ps, 12, aAssetPrice.getAsk());
    setNullableIntInStatement(ps, 13, aAssetPrice.getBidSize());
    setNullableIntInStatement(ps, 14, aAssetPrice.getAskSize());
    setBigDecimalInStatement(ps, 15, aAssetPrice.getPreMarketPrice());
    setBigDecimalInStatement(ps, 16, aAssetPrice.getPreMarketChange());
    setBigDecimalInStatement(ps, 17, aAssetPrice.getPreMarketChangePercent());
    setBigDecimalInStatement(ps, 18, aAssetPrice.getWeek52High());
    setBigDecimalInStatement(ps, 19, aAssetPrice.getWeek52Low());
    setBigDecimalInStatement(ps, 20, aAssetPrice.getFiftyDayAverage());
    setBigDecimalInStatement(ps, 21, aAssetPrice.getFiftyDayAverageChange());
    setBigDecimalInStatement(ps, 22, aAssetPrice.getTwoHundredDayAverage());
    setBigDecimalInStatement(ps, 23, aAssetPrice.getTwoHundredDayAverageChange());
    setNullableLongInStatement(ps, 24, aAssetPrice.getAvgDailyVolume3Month());
    setNullableLongInStatement(ps, 25, aAssetPrice.getAvgDailyVolume10Day());
    setBigDecimalInStatement(ps, 26, aAssetPrice.getMarketCap());
    setBigDecimalInStatement(ps, 27, aAssetPrice.getDividendYield());
    setIntInStatement(ps, 28, aAssetPrice.getCreatedBy());
    setTimestampInStatement(ps, 29, aAssetPrice.getCreatedDate());
    setIntInStatement(ps, 30, aAssetPrice.getLastUpdatedBy());
    setTimestampInStatement(ps, 31, aAssetPrice.getLastUpdatedDate());
  }

  private static void setNullableLongInStatement(PreparedStatement ps, int index, Long value)
      throws SQLException {
    if (value == null) {
      ps.setNull(index, Types.BIGINT);
    } else {
      ps.setLong(index, value);
    }
  }

  private static void setNullableIntInStatement(PreparedStatement ps, int index, Integer value)
      throws SQLException {
    if (value == null) {
      ps.setNull(index, Types.INTEGER);
    } else {
      ps.setInt(index, value);
    }
  }
}
