package com.neasaa.finance.dao.pg.account;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

@Log4j2
@Repository
public class AccountSnapshotDao extends AbstractDao {

  private static final String SELECT_COLUMNS =
      "SELECT ACCOUNTID, SNAPSHOTDATE, SYMBOL, OPTIONSYMBOL, DESCRIPTION,"
          + " QUANTITY, LASTPRICE, LASTPRICECHANGE, CURRENTVALUE,"
          + " AVERAGECOSTBASIS, TOTALCOSTBASIS, TODAYGAINLOSS, TOTALGAINLOSS,"
          + " PERCENTOFACCOUNT, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE";

  private static final String TABLE = BASE_SCHEMA_NAME + "ACCOUNTSNAPSHOT";

  private static final String SELECT_BY_ACCOUNT_AND_DATE =
      SELECT_COLUMNS + " FROM " + TABLE + " WHERE ACCOUNTID = ? AND SNAPSHOTDATE = ?";

  private static final String SELECT_SNAPSHOT_DATES =
      "SELECT DISTINCT SNAPSHOTDATE FROM " + TABLE
          + " WHERE ACCOUNTID = ? AND SNAPSHOTDATE >= ? AND SNAPSHOTDATE <= ?"
          + " ORDER BY SNAPSHOTDATE";

  private static final String DELETE_BY_ACCOUNT_AND_DATE =
      "DELETE FROM " + TABLE + " WHERE ACCOUNTID = ? AND SNAPSHOTDATE = ?";

  private static final String INSERT =
      "INSERT INTO " + TABLE
          + " (ACCOUNTID, SNAPSHOTDATE, SYMBOL, OPTIONSYMBOL, DESCRIPTION,"
          + " QUANTITY, LASTPRICE, LASTPRICECHANGE, CURRENTVALUE,"
          + " AVERAGECOSTBASIS, TOTALCOSTBASIS, TODAYGAINLOSS, TOTALGAINLOSS,"
          + " PERCENTOFACCOUNT, CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE)"
          + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

  public void insertAccountSnapshots(List<AccountSnapshot> snapshots) {
    if (snapshots == null || snapshots.isEmpty()) {
      return;
    }
    AccountSnapshot first = snapshots.get(0);
    long accountId = first.getAccountId();
    LocalDate snapshotDate = first.getSnapshotDate();
    try {
      getJdbcTemplate().update(connection -> {
        PreparedStatement ps = connection.prepareStatement(DELETE_BY_ACCOUNT_AND_DATE);
        setLongInStatement(ps, 1, accountId);
        setLocalDateInStatement(ps, 2, snapshotDate);
        return ps;
      });
      getJdbcTemplate().batchUpdate(INSERT, new BatchPreparedStatementSetter() {
        @Override
        public void setValues(PreparedStatement ps, int i) throws SQLException {
          setSnapshotParameters(ps, snapshots.get(i));
        }

        @Override
        public int getBatchSize() {
          return snapshots.size();
        }
      });
    } catch (Exception e) {
      log.error(
          "Failed to insert account snapshots for accountId {} date {}", accountId, snapshotDate, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public List<AccountSnapshot> getAccountSnapshot(long accountId, LocalDate date) {
    try {
      return getJdbcTemplate()
          .query(SELECT_BY_ACCOUNT_AND_DATE, new AccountSnapshotRowMapper(), accountId, date);
    } catch (Exception e) {
      log.error("Failed to get account snapshot for accountId {} date {}", accountId, date, e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  public List<LocalDate> getSnapshotDates(long accountId, LocalDate startDate, LocalDate endDate) {
    try {
      return getJdbcTemplate()
          .query(
              SELECT_SNAPSHOT_DATES,
              (rs, rowNum) -> getLocalDateFromResultSet(rs, "SNAPSHOTDATE"),
              accountId,
              startDate,
              endDate);
    } catch (Exception e) {
      log.error(
          "Failed to get snapshot dates for accountId {} between {} and {}",
          accountId,
          startDate,
          endDate,
          e);
      throw new InternalServerException(
          "Internal error while processing your request, please try again.");
    }
  }

  private void setSnapshotParameters(PreparedStatement ps, AccountSnapshot snapshot)
      throws SQLException {
    setLongInStatement(ps, 1, snapshot.getAccountId());
    setLocalDateInStatement(ps, 2, snapshot.getSnapshotDate());
    setStringInStatement(ps, 3, snapshot.getSymbol());
    String optionSymbolStr = snapshot.getOptionSymbol() != null
        ? snapshot.getOptionSymbol().getOptionSymbol()
        : snapshot.getSymbol();
    setStringInStatement(ps, 4, optionSymbolStr);
    setStringInStatement(ps, 5, snapshot.getDescription());
    setBigDecimalInStatement(ps, 6, snapshot.getQuantity());
    setBigDecimalInStatement(ps, 7, snapshot.getLastPrice());
    setBigDecimalInStatement(ps, 8, snapshot.getLastPriceChange());
    setBigDecimalInStatement(ps, 9, snapshot.getCurrentValue());
    setBigDecimalInStatement(ps, 10, snapshot.getAverageCostBasis());
    setBigDecimalInStatement(ps, 11, snapshot.getTotalCostBasis());
    setBigDecimalInStatement(ps, 12, snapshot.getTodayGainLoss());
    setBigDecimalInStatement(ps, 13, snapshot.getTotalGainLoss());
    setBigDecimalInStatement(ps, 14, snapshot.getPercentOfAccount());
    setIntInStatement(ps, 15, snapshot.getCreatedBy());
    setTimestampInStatement(ps, 16, snapshot.getCreatedDate());
    setIntInStatement(ps, 17, snapshot.getLastUpdatedBy());
    setTimestampInStatement(ps, 18, snapshot.getLastUpdatedDate());
  }
}
