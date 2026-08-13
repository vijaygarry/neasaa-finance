package com.neasaa.finance.service.account.parser.snapshot;

import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import java.io.IOException;
import java.util.List;

public interface AccountSnapshotParser {
    List<AccountSnapshot> parseSnapshot (String aCSVSnapshotFilepath) throws IOException;
}
