package com.neasaa.finance.dao.pg.account;

import com.neasaa.base.app.dao.pg.AbstractDao;
import com.neasaa.base.app.operation.exception.InternalServerException;
import com.neasaa.finance.dao.entity.account.Account;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Repository;

@Log4j2
@Repository
public class AccountDao extends AbstractDao {

    private static final String SELECT_COLUMNS =
            "SELECT ACCOUNTID, USERID, ACCOUNTNUMBER, ACCOUNTNAME, BANKNAME, ACCOUNTTYPE,"
                    + " CREATEDBY, CREATEDDATE, LASTUPDATEDBY, LASTUPDATEDDATE";

    private static final String SELECT_BY_USER =
            SELECT_COLUMNS + " FROM " + BASE_SCHEMA_NAME + "ACCOUNT WHERE USERID = ? ORDER BY ACCOUNTNAME";

    public List<Account> getAccountsByUserId(int userId) {
        try {
            return getJdbcTemplate().query(SELECT_BY_USER, new AccountRowMapper(), userId);
        } catch (Exception e) {
            log.error("Failed to get accounts for userId {}", userId, e);
            throw new InternalServerException("Internal error while processing your request, please try again.");
        }
    }
}
