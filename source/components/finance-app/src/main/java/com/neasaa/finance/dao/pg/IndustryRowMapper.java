package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.finance.dao.entity.Industry;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

public class IndustryRowMapper implements RowMapper<Industry> {

  @Override
  public Industry mapRow(ResultSet aRs, int aRowNum) throws SQLException {
    Industry industry = new Industry();
    industry.setIndustry(aRs.getString("INDUSTRY"));
    industry.setDescription(aRs.getString("DESCRIPTION"));
    industry.setEnable(aRs.getBoolean("ENABLE"));
    industry.setCreatedBy(aRs.getInt("CREATEDBY"));
    industry.setCreatedDate(AbstractDao.getTimestampFromResultSet(aRs, "CREATEDDATE"));
    industry.setLastUpdatedBy(aRs.getInt("LASTUPDATEDBY"));
    industry.setLastUpdatedDate(AbstractDao.getTimestampFromResultSet(aRs, "LASTUPDATEDDATE"));
    return industry;
  }
}
