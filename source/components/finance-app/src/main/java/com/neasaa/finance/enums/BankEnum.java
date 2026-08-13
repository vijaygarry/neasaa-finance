package com.neasaa.finance.enums;

public enum BankEnum {
  FIDELITY,
  ETRADE,
  EDWARD_JOHNS,
  ROBINHOOD;

  private BankEnum() {}

  public static BankEnum getBankByName(String name) {
    for (BankEnum bank : values()) {
      if (bank.name().equalsIgnoreCase(name)) {
        return bank;
      }
    }
    throw new IllegalArgumentException("No bank found with name: " + name);
  }
}
