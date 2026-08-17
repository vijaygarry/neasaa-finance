package com.neasaa.finance.operation.account;

import com.neasaa.base.app.operation.AbstractOperation;
import com.neasaa.base.app.operation.AuditInfo;
import com.neasaa.base.app.operation.exception.OperationException;
import com.neasaa.base.app.operation.exception.ValidationException;
import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import com.neasaa.finance.dao.pg.account.AccountSnapshotDao;
import com.neasaa.finance.enums.BankEnum;
import com.neasaa.finance.operation.FinanceOperationNames;
import com.neasaa.finance.operation.account.model.UploadAccountSnapshotRequest;
import com.neasaa.finance.operation.account.model.UploadAccountSnapshotResponse;
import com.neasaa.finance.service.account.parser.snapshot.AccountSnapshotParser;
import com.neasaa.finance.service.account.parser.snapshot.AccountSnapshotParserFactory;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Log4j2
@Component("UploadAccountSnapshotOperation")
@Scope("prototype")
public class UploadAccountSnapshotOperation
        extends AbstractOperation<UploadAccountSnapshotRequest, UploadAccountSnapshotResponse> {

    private static final AccountSnapshotParserFactory parserFactory = new AccountSnapshotParserFactory();

    @Autowired
    private AccountSnapshotDao accountSnapshotDao;

    @Override
    public String getOperationName() {
        return FinanceOperationNames.UPLOAD_ACCOUNT_SNAPSHOT;
    }

    @Override
    public void doValidate(UploadAccountSnapshotRequest request) throws OperationException {
        if (request.getAccountId() <= 0) {
            throw new ValidationException("A valid accountId is required.");
        }
        if (request.getSnapshotCSVFilePath() == null || request.getSnapshotCSVFilePath().isBlank()) {
            throw new ValidationException("Snapshot CSV file is required.");
        }
    }

    @Override
    public UploadAccountSnapshotResponse doExecute(UploadAccountSnapshotRequest request)
            throws OperationException {
        log.info("Parsing account snapshot for accountId={}", request.getAccountId());
        // Fetch the account from DAO using account id and logged in user id.
        // If Account not found, throw ValidationException.
        // For now, we will assume the account exists and is valid.
        // Get the bank type for the account. For now, we will assume it's FIDELITY.
        AccountSnapshotParser parser = parserFactory.getParser(BankEnum.FIDELITY);

        List<AccountSnapshot> snapshots;
        try {
            Date currentDate = new Date();
            AuditInfo auditInfo = AuditInfo.builder()
                    .createdBy(3)
                    .createdDate(currentDate)
                    .lastUpdatedBy(3)
                    .lastUpdatedDate(currentDate)
                    .build();

            // TODO: Get bank account number from CSV file and validate it against the account's bank account number.
            // If they don't match, throw ValidationException.
            // Parser should return snapshot date and bank account number from the CSV file. 
            // We can then validate the bank account number against the account's bank account number.
            // This also require the change in response of the parser to return the bank account number and snapshot date.
            snapshots = parser.parseSnapshot(request.getSnapshotCSVFilePath(), request.getAccountId(), auditInfo);
            accountSnapshotDao.insertAccountSnapshots(snapshots);
        } catch (IOException e) {
            throw new ValidationException("Failed to parse snapshot file: " + e.getMessage());
        }

        log.info("Parsed {} snapshot records for accountId={}", snapshots.size(), request.getAccountId());

        UploadAccountSnapshotResponse response = new UploadAccountSnapshotResponse();
        response.setRecordsProcessed(snapshots.size());
        return response;
    }
}
