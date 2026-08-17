package com.neasaa.finance.service.account.parser.snapshot;

import com.neasaa.base.app.operation.AuditInfo;
import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import java.io.IOException;
import java.util.List;

public interface AccountSnapshotParser {
    List<AccountSnapshot> parseSnapshot(
            String aCSVSnapshotFilepath, long accountId, AuditInfo auditInfo)
            throws IOException;
}
