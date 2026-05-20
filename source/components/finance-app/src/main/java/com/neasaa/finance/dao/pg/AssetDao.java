package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.dao.entity.Asset;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

@Log4j2
@Repository
public class AssetDao extends AbstractDao {

  private static final String SELECT_COLUMNS =
      "SELECT ASSETID, SYMBOL, NAME, DISPLAYNAME, ASSETTYPE, INDUSTRY, MARKET,"
          + " OPTIONSUPPORTED, TRACKPRICE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE";

  private static final String SELECT_ALL_ASSETS =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSET";

  private static final String SELECT_ASSET_BY_ID =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSET WHERE ASSETID = ?";

  private static final String SELECT_ASSET_BY_SYMBOL =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSET WHERE SYMBOL = ?";

  private static final String SELECT_ASSETS_BY_TRACK_PRICE =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSET WHERE TRACKPRICE = true";

  private static final String SEARCH_ASSETS_BY_SYMBOL_OR_NAME =
      SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "MSTASSET"
          + " WHERE SYMBOL ILIKE ? OR NAME ILIKE ?"
          + " ORDER BY SYMBOL LIMIT 20";

  public List<Asset> getAll() {
    try {
      return getJdbcTemplate().query(SELECT_ALL_ASSETS, new AssetRowMapper());
    } catch (Exception e) {
      log.error("Failed to get all assets", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public Asset getByAssetId(int assetId) {
    try {
      List<Asset> result =
          getJdbcTemplate().query(SELECT_ASSET_BY_ID, new AssetRowMapper(), assetId);
      if (result.isEmpty()) {
        return null;
      }
      return result.get(0);
    } catch (Exception e) {
      log.error("Failed to get asset by id {}", assetId, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public Asset getBySymbol(String symbol) {
    try {
      List<Asset> result =
          getJdbcTemplate().query(SELECT_ASSET_BY_SYMBOL, new AssetRowMapper(), symbol);
      if (result.isEmpty()) {
        return null;
      }
      return result.get(0);
    } catch (Exception e) {
      log.error("Failed to get asset by symbol {}", symbol, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public List<Asset> searchBySymbolOrName(String query) {
    try {
      String pattern = "%" + query + "%";
      return getJdbcTemplate().query(
          SEARCH_ASSETS_BY_SYMBOL_OR_NAME, new AssetRowMapper(), pattern, pattern);
    } catch (Exception e) {
      log.error("Failed to search assets by symbol or name for query {}", query, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public List<Asset> getAllTrackPrice() {
    try {
      return getJdbcTemplate().query(SELECT_ASSETS_BY_TRACK_PRICE, new AssetRowMapper());
    } catch (Exception e) {
      log.error("Failed to get assets with track price enabled", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int insert(Asset aAsset) {
    try {
      KeyHolder keyHolder = new GeneratedKeyHolder();
      getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildInsertStatement(aCon, aAsset);
        }
      }, keyHolder);
      Number key = keyHolder.getKey();
      int assetId = (key != null) ? key.intValue() : -1;
      log.info("New asset created with assetId {}", assetId);
      return assetId;
    } catch (Exception e) {
      log.error("Failed to insert asset {}", aAsset.getSymbol(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int update(Asset aAsset) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildUpdateStatement(aCon, aAsset);
        }
      });
    } catch (Exception e) {
      log.error("Failed to update asset {}", aAsset.getAssetId(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int delete(int assetId) {
    try {
      String sql = "DELETE FROM " + BASE_SCHEMA_NAME + "MSTASSET WHERE ASSETID = ?";
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          PreparedStatement ps = aCon.prepareStatement(sql);
          setIntInStatement(ps, 1, assetId);
          return ps;
        }
      });
    } catch (Exception e) {
      log.error("Failed to delete asset {}", assetId, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  private PreparedStatement buildInsertStatement(Connection aCon, Asset aAsset)
      throws SQLException {
    String sql =
        "INSERT INTO " + BASE_SCHEMA_NAME + "MSTASSET"
            + " (SYMBOL, NAME, DISPLAYNAME, ASSETTYPE, INDUSTRY, MARKET,"
            + " OPTIONSUPPORTED, TRACKPRICE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE)"
            + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = aCon.prepareStatement(sql, new String[]{"assetid"});
    setStringInStatement(ps, 1, aAsset.getSymbol());
    setStringInStatement(ps, 2, aAsset.getName());
    setStringInStatement(ps, 3, aAsset.getDisplayName());
    setStringInStatement(ps, 4, aAsset.getAssetType());
    setStringInStatement(ps, 5, aAsset.getIndustry());
    setStringInStatement(ps, 6, aAsset.getMarket());
    setBooleanInStatement(ps, 7, aAsset.isOptionSupported());
    setBooleanInStatement(ps, 8, aAsset.isTrackPrice());
    setIntInStatement(ps, 9, aAsset.getCreatedBy());
    setTimestampInStatement(ps, 10, aAsset.getCreatedDate());
    setIntInStatement(ps, 11, aAsset.getLastUpdatedBy());
    setTimestampInStatement(ps, 12, aAsset.getLastUpdatedDate());
    return ps;
  }

  private PreparedStatement buildUpdateStatement(Connection aCon, Asset aAsset)
      throws SQLException {
    String sql =
        "UPDATE " + BASE_SCHEMA_NAME + "MSTASSET"
            + " SET SYMBOL = ?, NAME = ?, DISPLAYNAME = ?, ASSETTYPE = ?, INDUSTRY = ?, MARKET = ?,"
            + " OPTIONSUPPORTED = ?, TRACKPRICE = ?, LASTUPDATEDBY = ?, LASTUPDATEDDATE = ?"
            + " WHERE ASSETID = ?";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setStringInStatement(ps, 1, aAsset.getSymbol());
    setStringInStatement(ps, 2, aAsset.getName());
    setStringInStatement(ps, 3, aAsset.getDisplayName());
    setStringInStatement(ps, 4, aAsset.getAssetType());
    setStringInStatement(ps, 5, aAsset.getIndustry());
    setStringInStatement(ps, 6, aAsset.getMarket());
    setBooleanInStatement(ps, 7, aAsset.isOptionSupported());
    setBooleanInStatement(ps, 8, aAsset.isTrackPrice());
    setIntInStatement(ps, 9, aAsset.getLastUpdatedBy());
    setTimestampInStatement(ps, 10, aAsset.getLastUpdatedDate());
    setIntInStatement(ps, 11, aAsset.getAssetId());
    return ps;
  }
}
