package com.neasaa.finance.service.account.parser.snapshot;

import com.neasaa.finance.enums.BankEnum;
import java.util.EnumMap;
import java.util.Map;

public class AccountSnapshotParserFactory {

  private final Map<BankEnum, AccountSnapshotParser> parsers;

  public AccountSnapshotParserFactory() {
    Map<BankEnum, AccountSnapshotParser> map = new EnumMap<>(BankEnum.class);
    map.put(BankEnum.FIDELITY, new FidelityAccountSnapshotParser());
    this.parsers = map;
  }

  public AccountSnapshotParser getParser(BankEnum bank) {
    AccountSnapshotParser parser = parsers.get(bank);
    if (parser == null) {
      throw new IllegalStateException("No snapshot parser defined for bank: " + bank);
    }
    return parser;
  }
}
