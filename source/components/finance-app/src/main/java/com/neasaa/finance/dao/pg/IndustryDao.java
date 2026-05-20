package com.neasaa.finance.dao.pg;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.dao.entity.Industry;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.stereotype.Repository;

@Log4j2
@Repository
public class IndustryDao extends AbstractDao {

  private static final String SELECT_ALL_INDUSTRIES =
      "SELECT INDUSTRY, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE"
          + " FROM " + BASE_SCHEMA_NAME + "LKPINDUSTRY";

  private static final String SELECT_ALL_ACTIVE_INDUSTRIES =
      "SELECT INDUSTRY, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE"
          + " FROM " + BASE_SCHEMA_NAME + "LKPINDUSTRY"
          + " WHERE ENABLE = true";

  private static final String SELECT_INDUSTRY_BY_ID =
      "SELECT INDUSTRY, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE"
          + " FROM " + BASE_SCHEMA_NAME + "LKPINDUSTRY"
          + " WHERE INDUSTRY = ?";

  public List<Industry> getAll() {
    try {
      return getJdbcTemplate().query(SELECT_ALL_INDUSTRIES, new IndustryRowMapper());
    } catch (Exception e) {
      log.error("Failed to get all industries", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public List<Industry> getAllActive() {
    try {
      return getJdbcTemplate().query(SELECT_ALL_ACTIVE_INDUSTRIES, new IndustryRowMapper());
    } catch (Exception e) {
      log.error("Failed to get all active industries", e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public Industry getByIndustry(String industry) {
    try {
      List<Industry> result =
          getJdbcTemplate().query(SELECT_INDUSTRY_BY_ID, new IndustryRowMapper(), industry);
      if (result.isEmpty()) {
        return null;
      }
      return result.get(0);
    } catch (Exception e) {
      log.error("Failed to get industry {}", industry, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int insert(Industry aIndustry) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildInsertStatement(aCon, aIndustry);
        }
      });
    } catch (Exception e) {
      log.error("Failed to insert industry {}", aIndustry.getIndustry(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int update(Industry aIndustry) {
    try {
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          return buildUpdateStatement(aCon, aIndustry);
        }
      });
    } catch (Exception e) {
      log.error("Failed to update industry {}", aIndustry.getIndustry(), e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public int delete(String industry) {
    try {
      String sql = "DELETE FROM " + BASE_SCHEMA_NAME + "LKPINDUSTRY WHERE INDUSTRY = ?";
      return getJdbcTemplate().update(new PreparedStatementCreator() {
        @Override
        public PreparedStatement createPreparedStatement(Connection aCon) throws SQLException {
          PreparedStatement ps = aCon.prepareStatement(sql);
          setStringInStatement(ps, 1, industry);
          return ps;
        }
      });
    } catch (Exception e) {
      log.error("Failed to delete industry {}", industry, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  private PreparedStatement buildInsertStatement(Connection aCon, Industry aIndustry)
      throws SQLException {
    String sql =
        "INSERT INTO " + BASE_SCHEMA_NAME + "LKPINDUSTRY"
            + " (INDUSTRY, DESCRIPTION, ENABLE, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE)"
            + " VALUES (?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setStringInStatement(ps, 1, aIndustry.getIndustry());
    setStringInStatement(ps, 2, aIndustry.getDescription());
    setBooleanInStatement(ps, 3, aIndustry.isEnable());
    setIntInStatement(ps, 4, aIndustry.getCreatedBy());
    setTimestampInStatement(ps, 5, aIndustry.getCreatedDate());
    setIntInStatement(ps, 6, aIndustry.getLastUpdatedBy());
    setTimestampInStatement(ps, 7, aIndustry.getLastUpdatedDate());
    return ps;
  }

  private PreparedStatement buildUpdateStatement(Connection aCon, Industry aIndustry)
      throws SQLException {
    String sql =
        "UPDATE " + BASE_SCHEMA_NAME + "LKPINDUSTRY"
            + " SET DESCRIPTION = ?, ENABLE = ?, LASTUPDATEDBY = ?, LASTUPDATEDDATE = ?"
            + " WHERE INDUSTRY = ?";
    PreparedStatement ps = aCon.prepareStatement(sql);
    setStringInStatement(ps, 1, aIndustry.getDescription());
    setBooleanInStatement(ps, 2, aIndustry.isEnable());
    setIntInStatement(ps, 3, aIndustry.getLastUpdatedBy());
    setTimestampInStatement(ps, 4, aIndustry.getLastUpdatedDate());
    setStringInStatement(ps, 5, aIndustry.getIndustry());
    return ps;
  }
}
