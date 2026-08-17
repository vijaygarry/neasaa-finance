package com.neasaa.finance.util;

import com.neasaa.finance.enums.OptionType;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.Instant;
import java.time.ZoneOffset;
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
    // Trim the optionSymbol and remove "-" if present
    optionSymbol = optionSymbol.trim().replace("-", "");
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

  /**
   * Builds an OCC-format option contract symbol: {TICKER}{YYMMDD}{C/P}{STRIKE*1000, zero-padded to 8}.
   * Example: AAPL + epoch(2024-11-15) + CALL + 180.00 → "AAPL241115C00180000"
   */
  public static String buildContractSymbol(
      String ticker, long expirationEpoch, OptionType optionType, BigDecimal strike) {
    String date =
        Instant.ofEpochSecond(expirationEpoch)
            .atZone(ZoneOffset.UTC)
            .toLocalDate()
            .format(DateTimeFormatter.ofPattern("yyMMdd"));
    String side = optionType.getCode();
    long strikeEncoded = strike.multiply(BigDecimal.valueOf(1000)).longValue();
    return ticker + date + side + String.format("%08d", strikeEncoded);
  }
}
