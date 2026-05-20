package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.dao.entity.AssetType;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.stereotype.Repository;

@Log4j2
@Repository
public class AssetTypeDao extends AbstractDao {

  private static final String SELECT_ALL_ASSET_TYPES =
      "SELECT ASSETTYPE, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE"
          + " FROM " + BASE_SCHEMA_NAME + "LKPASSETTYPE";

  private static final String SELECT_ALL_ACTIVE_ASSET_TYPES =
      "SELECT ASSETTYPE, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE"
          + " FROM " + BASE_SCHEMA_NAME + "LKPASSETTYPE"
          + " WHERE ENABLE = true";

  private static final String SELECT_ASSET_TYPE_BY_ID =
      "SELECT ASSETTYPE, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE"
          + " FROM " + BASE_SCHEMA_NAME + "LKPASSETTYPE"
          + " WHERE ASSETTYPE = ?";

  public List<AssetType> getAll() {
    try {
      return getJdbcTemplate().query(SELECT_ALL_ASSET_TYPES, new AssetTypeRowMapper());
    } catch (Exception e) {
      log.error("Failed to get all asset types", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public List<AssetType> getAllActive() {
    try {
      return getJdbcTemplate().query(SELECT_ALL_ACTIVE_ASSET_TYPES, new AssetTypeRowMapper());
    } catch (Exception e) {
      log.error("Failed to get all active asset types", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public AssetType getByAssetType(String assetType) {
    try {
      List<AssetType> result =
          getJdbcTemplate().query(SELECT_ASSET_TYPE_BY_ID, new AssetTypeRowMapper(), assetType);
      if (result.isEmpty()) {
        return null;
      }
      return result.get(0);
    } catch (Exception e) {
      log.error("Failed to get asset type {}", assetType, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int insert(AssetType aAssetType) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildInsertStatement(aCon, aAssetType);
        }
      });
    } catch (Exception e) {
      log.error("Failed to insert asset type {}", aAssetType.getAssetType(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int update(AssetType aAssetType) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildUpdateStatement(aCon, aAssetType);
        }
      });
    } catch (Exception e) {
      log.error("Failed to update asset type {}", aAssetType.getAssetType(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int delete(String assetType) {
    try {
      String sql = "DELETE FROM " + BASE_SCHEMA_NAME + "LKPASSETTYPE WHERE ASSETTYPE = ?";
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          PreparedStatement ps = aCon.prepareStatement(sql);
          setStringInStatement(ps, 1, assetType);
          return ps;
        }
      });
    } catch (Exception e) {
      log.error("Failed to delete asset type {}", assetType, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  private PreparedStatement buildInsertStatement(Connection aCon, AssetType aAssetType)
      throws SQLException {
    String sql =
        "INSERT INTO " + BASE_SCHEMA_NAME + "LKPASSETTYPE"
            + " (ASSETTYPE, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE)"
            + " VALUES (?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setStringInStatement(ps, 1, aAssetType.getAssetType());
    setStringInStatement(ps, 2, aAssetType.getDescription());
    setBooleanInStatement(ps, 3, aAssetType.isEnable());
    setIntInStatement(ps, 4, aAssetType.getCreatedBy());
    setTimestampInStatement(ps, 5, aAssetType.getCreatedDate());
    setIntInStatement(ps, 6, aAssetType.getLastUpdatedBy());
    setTimestampInStatement(ps, 7, aAssetType.getLastUpdatedDate());
    return ps;
  }

  private PreparedStatement buildUpdateStatement(Connection aCon, AssetType aAssetType)
      throws SQLException {
    String sql =
        "UPDATE " + BASE_SCHEMA_NAME + "LKPASSETTYPE"
            + " SET DESCRIPTION = ?, ENABLE = ?, LASTUPDATEDBY = ?, LASTUPDATEDDATE = ?"
            + " WHERE ASSETTYPE = ?";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setStringInStatement(ps, 1, aAssetType.getDescription());
    setBooleanInStatement(ps, 2, aAssetType.isEnable());
    setIntInStatement(ps, 3, aAssetType.getLastUpdatedBy());
    setTimestampInStatement(ps, 4, aAssetType.getLastUpdatedDate());
    setStringInStatement(ps, 5, aAssetType.getAssetType());
    return ps;
  }
}
