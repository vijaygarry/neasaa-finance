package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.finance.dao.entity.AssetType;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

public class AssetTypeRowMapper implements RowMapper<AssetType> {

  @Override
  public AssetType mapRow(ResultSet aRs, int aRowNum) throws SQLException {
    AssetType assetType = new AssetType();
    assetType.setAssetType(aRs.getString("ASSETTYPE"));
    assetType.setDescription(aRs.getString("DESCRIPTION"));
    assetType.setEnable(aRs.getBoolean("ENABLE"));
    assetType.setCreatedBy(aRs.getInt("CREATEDBY"));
    assetType.setCreatedDate(AbstractDao.getTimestampFromResultSet(aRs, "CREATEDDATE"));
    assetType.setLastUpdatedBy(aRs.getInt("LASTUPDATEDBY"));
    assetType.setLastUpdatedDate(AbstractDao.getTimestampFromResultSet(aRs, "LASTUPDATEDDATE"));
    return assetType;
  }
}
