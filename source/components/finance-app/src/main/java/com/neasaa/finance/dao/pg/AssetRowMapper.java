package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.finance.dao.entity.Asset;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

public class AssetRowMapper implements RowMapper<Asset> {

  @Override
  public Asset mapRow(ResultSet aRs, int aRowNum) throws SQLException {
    Asset asset = new Asset();
    asset.setAssetId(aRs.getInt("ASSETID"));
    asset.setSymbol(aRs.getString("SYMBOL"));
    asset.setName(aRs.getString("NAME"));
    asset.setDisplayName(aRs.getString("DISPLAYNAME"));
    asset.setAssetType(aRs.getString("ASSETTYPE"));
    asset.setIndustry(aRs.getString("INDUSTRY"));
    asset.setMarket(aRs.getString("MARKET"));
    asset.setOptionSupported(aRs.getBoolean("OPTIONSUPPORTED"));
    asset.setTrackPrice(aRs.getBoolean("TRACKPRICE"));
    asset.setCreatedBy(aRs.getInt("CREATEDBY"));
    asset.setCreatedDate(AbstractDao.getTimestampFromResultSet(aRs, "CREATEDDATE"));
    asset.setLastUpdatedBy(aRs.getInt("LASTUPDATEDBY"));
    asset.setLastUpdatedDate(AbstractDao.getTimestampFromResultSet(aRs, "LASTUPDATEDDATE"));
    return asset;
  }
}
