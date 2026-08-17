package com.neasaa.finance.enums;

public enum OptionType {
  CALL("C"),
  PUT("P");

  private final String code;

  OptionType(String code) {
    this.code = code;
  }

  public String getCode() {
    return code;
  }

  public static OptionType fromCode(String code) {
    for (OptionType type : values()) {
      if (type.code.equalsIgnoreCase(code)) {
        return type;
      }
    }
    throw new IllegalArgumentException("Unknown option type code: " + code);
  }
}