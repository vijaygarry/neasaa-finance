package com.neasaa.finance.util;

import com.neasaa.finance.enums.OptionType;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import lombok.Getter;

@Getter
public class OptionSymbol {

  private static final Pattern OPTION_PATTERN =
      Pattern.compile("^([A-Z0-9]{1,6})(\\d{6})([CP])(\\d+(?:\\.\\d+)?)$");
  private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyMMdd");

  private String optionSymbol;
  private String underlyingSymbol;
  private OptionType optionType;
  private BigDecimal strikePrice;
  private LocalDate expiryDate;

  private OptionSymbol() {}

  public static OptionSymbol parse(String optionSymbol) {
    if (optionSymbol == null) {
      throw new IllegalArgumentException("Option symbol must not be null");
    }
    Matcher matcher = OPTION_PATTERN.matcher(optionSymbol.trim());
    if (!matcher.matches()) {
      throw new IllegalArgumentException("Invalid option symbol format: " + optionSymbol);
    }
    OptionSymbol result = new OptionSymbol();
    result.optionSymbol = optionSymbol;
    result.underlyingSymbol = matcher.group(1);
    result.expiryDate = LocalDate.parse(matcher.group(2), DATE_FORMATTER);
    result.optionType = OptionType.fromCode(matcher.group(3));
    result.strikePrice = new BigDecimal(matcher.group(4));
    return result;
  }
}
