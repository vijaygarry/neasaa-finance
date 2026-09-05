package com.neasaa.finance.dao.pg.account;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.finance.dao.entity.account.Account;
import com.neasaa.finance.enums.BankEnum;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

public class AccountRowMapper implements RowMapper<Account> {

    @Override
    public Account mapRow(ResultSet rs, int rowNum) throws SQLException {
        return Account.builder()
                .accountId(rs.getLong("ACCOUNTID"))
                .userId(rs.getInt("USERID"))
                .accountNumber(rs.getString("ACCOUNTNUMBER"))
                .accountName(rs.getString("ACCOUNTNAME"))
                .bankName(BankEnum.getBankByName(rs.getString("BANKNAME")))
                .accountType(rs.getString("ACCOUNTTYPE"))
                .createdBy(rs.getInt("CREATEDBY"))
                .createdDate(AbstractDao.getTimestampFromResultSet(rs, "CREATEDDATE"))
                .lastUpdatedBy(rs.getInt("LASTUPDATEDBY"))
                .lastUpdatedDate(AbstractDao.getTimestampFromResultSet(rs, "LASTUPDATEDDATE"))
                .build();
    }
}
