package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.dao.entity.AssetFundamentals;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.stereotype.Repository;

@Log4j2
@Repository
public class AssetFundamentalsDao extends AbstractDao {

  private static final String SELECT_COLUMNS =
      "SELECT ASSETID, PETTM, PEFTM, EPSTTM, EPSFORWARD, EPSCURRENTYEAR, PRICEEPSCURRENTYEAR,"
          + " DIVIDENDRATE, DIVIDENDEXDATE, DIVIDENDPAYDATE, NEXTEARNINGSDATE,"
          + " EARNINGSSTARTDATE, EARNINGSENDDATE, AVERAGEANALYSTRATING, ANALYSTRATINGLEVEL,"
          + " ONEYEARPRICETARGET, PRICETARGETUPDATEDDATE,"
          + " CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE";

  private static final String SELECT_ALL_ASSET_FUNDAMENTALS =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSETFUNDAMENTALS";

  private static final String SELECT_ASSET_FUNDAMENTALS_BY_ID =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSETFUNDAMENTALS WHERE ASSETID = ?";

  public List<AssetFundamentals> getAll() {
    try {
      return getJdbcTemplate().query(SELECT_ALL_ASSET_FUNDAMENTALS, new AssetFundamentalsRowMapper());
    } catch (Exception e) {
      log.error("Failed to get all asset fundamentals", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public AssetFundamentals getByAssetId(int assetId) {
    try {
      List<AssetFundamentals> result =
          getJdbcTemplate().query(
              SELECT_ASSET_FUNDAMENTALS_BY_ID, new AssetFundamentalsRowMapper(), assetId);
      if (result.isEmpty()) {
        return null;
      }
      return result.get(0);
    } catch (Exception e) {
      log.error("Failed to get asset fundamentals for assetId {}", assetId, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int insert(AssetFundamentals aAssetFundamentals) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildInsertStatement(aCon, aAssetFundamentals);
        }
      });
    } catch (Exception e) {
      log.error("Failed to insert asset fundamentals for assetId {}",
          aAssetFundamentals.getAssetId(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int update(AssetFundamentals aAssetFundamentals) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildUpdateStatement(aCon, aAssetFundamentals);
        }
      });
    } catch (Exception e) {
      log.error("Failed to update asset fundamentals for assetId {}",
          aAssetFundamentals.getAssetId(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int delete(int assetId) {
    try {
      String sql = "DELETE FROM " + BASE_SCHEMA_NAME + "MSTASSETFUNDAMENTALS WHERE ASSETID = ?";
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          PreparedStatement ps = aCon.prepareStatement(sql);
          setIntInStatement(ps, 1, assetId);
          return ps;
        }
      });
    } catch (Exception e) {
      log.error("Failed to delete asset fundamentals for assetId {}", assetId, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  private PreparedStatement buildInsertStatement(Connection aCon, AssetFundamentals aFundamentals)
      throws SQLException {
    String sql =
        "INSERT INTO " + BASE_SCHEMA_NAME + "MSTASSETFUNDAMENTALS"
            + " (ASSETID, PETTM, PEFTM, EPSTTM, EPSFORWARD, EPSCURRENTYEAR, PRICEEPSCURRENTYEAR,"
            + " DIVIDENDRATE, DIVIDENDEXDATE, DIVIDENDPAYDATE, NEXTEARNINGSDATE,"
            + " EARNINGSSTARTDATE, EARNINGSENDDATE, AVERAGEANALYSTRATING, ANALYSTRATINGLEVEL,"
            + " ONEYEARPRICETARGET, PRICETARGETUPDATEDDATE,"
            + " CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE)"
            + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setFundamentalsParameters(ps, aFundamentals, true);
    return ps;
  }

  private PreparedStatement buildUpdateStatement(Connection aCon, AssetFundamentals aFundamentals)
      throws SQLException {
    String sql =
        "UPDATE " + BASE_SCHEMA_NAME + "MSTASSETFUNDAMENTALS"
            + " SET PETTM = ?, PEFTM = ?, EPSTTM = ?, EPSFORWARD = ?, EPSCURRENTYEAR = ?,"
            + " PRICEEPSCURRENTYEAR = ?, DIVIDENDRATE = ?, DIVIDENDEXDATE = ?, DIVIDENDPAYDATE = ?,"
            + " NEXTEARNINGSDATE = ?, EARNINGSSTARTDATE = ?, EARNINGSENDDATE = ?,"
            + " AVERAGEANALYSTRATING = ?, ANALYSTRATINGLEVEL = ?,"
            + " ONEYEARPRICETARGET = ?, PRICETARGETUPDATEDDATE = ?,"
            + " LASTUPDATEDBY = ?, LASTUPDATEDDATE = ?"
            + " WHERE ASSETID = ?";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setFundamentalsParameters(ps, aFundamentals, false);
    return ps;
  }

  private void setFundamentalsParameters(
      PreparedStatement ps, AssetFundamentals aFundamentals, boolean isInsert) throws SQLException {
    int idx = 1;
    if (isInsert) {
      setIntInStatement(ps, idx++, aFundamentals.getAssetId());
    }
    setBigDecimalInStatement(ps, idx++, aFundamentals.getPeTtm());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getPeFtm());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getEpsTtm());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getEpsForward());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getEpsCurrentYear());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getPriceEpsCurrentYear());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getDividendRate());
    setLocalDateInStatement(ps, idx++, aFundamentals.getDividendExDate());
    setLocalDateInStatement(ps, idx++, aFundamentals.getDividendPayDate());
    setLocalDateInStatement(ps, idx++, aFundamentals.getNextEarningsDate());
    setLocalDateInStatement(ps, idx++, aFundamentals.getEarningsStartDate());
    setLocalDateInStatement(ps, idx++, aFundamentals.getEarningsEndDate());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getAverageAnalystRating());
    setStringInStatement(ps, idx++, aFundamentals.getAnalystRatingLevel());
    setBigDecimalInStatement(ps, idx++, aFundamentals.getOneYearPriceTarget());
    setLocalDateInStatement(ps, idx++, aFundamentals.getPriceTargetUpdatedDate());
    if (isInsert) {
      setIntInStatement(ps, idx++, aFundamentals.getCreatedBy());
      setTimestampInStatement(ps, idx++, aFundamentals.getCreatedDate());
    }
    setIntInStatement(ps, idx++, aFundamentals.getLastUpdatedBy());
    setTimestampInStatement(ps, idx++, aFundamentals.getLastUpdatedDate());
    if (!isInsert) {
      setIntInStatement(ps, idx, aFundamentals.getAssetId());
    }
  }
}
