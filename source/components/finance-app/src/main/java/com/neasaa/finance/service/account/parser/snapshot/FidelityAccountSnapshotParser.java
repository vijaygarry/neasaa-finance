package com.neasaa.finance.service.account.parser.snapshot;

import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import com.neasaa.finance.util.OptionSymbol;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FidelityAccountSnapshotParser implements AccountSnapshotParser {

  private static final Pattern DATE_LINE_PATTERN =
      Pattern.compile("Date downloaded (\\w{3}-\\d{2}-\\d{4})");
  private static final DateTimeFormatter DATE_FORMATTER =
      DateTimeFormatter.ofPattern("MMM-dd-yyyy", Locale.ENGLISH);
  private static final int EXPECTED_MIN_COLUMNS = 15;

  @Override
  public List<AccountSnapshot> parseSnapshot(String aCSVSnapshotFilepath) throws IOException {
    List<AccountSnapshot> snapshots = new ArrayList<>();
    LocalDate snapshotDate = null;

    try (BufferedReader reader = new BufferedReader(new FileReader(aCSVSnapshotFilepath))) {
      String line;
      boolean isFirstLine = true;
      while ((line = reader.readLine()) != null) {
        if (isFirstLine) {
          isFirstLine = false;
          continue; // skip header
        }
        LocalDate extractedDate = tryExtractDate(line);
        if (extractedDate != null) {
          snapshotDate = extractedDate;
          continue;
        }
        if (shouldSkipLine(line)) {
          continue;
        }
        AccountSnapshot snapshot = parseLine(line, snapshotDate);
        if (snapshot != null) {
          snapshots.add(snapshot);
        }
      }
    }
    if (snapshotDate == null) {
      throw new IOException("Snapshot date line not found in file: " + aCSVSnapshotFilepath);
    }
    return snapshots;
  }

  // Matches: "Date downloaded Aug-02-2026 11:49 a.m ET"
  private LocalDate tryExtractDate(String line) {
    Matcher matcher = DATE_LINE_PATTERN.matcher(line);
    if (matcher.find()) {
      return LocalDate.parse(matcher.group(1), DATE_FORMATTER);
    }
    return null;
  }

  private boolean shouldSkipLine(String line) {
    if (line.isBlank() || line.startsWith("\"")) {
      return true;
    }
    String[] cols = line.split(",", -1);
    if (cols.length < 3) {
      return true;
    }
    String symbol = cols[2].trim();
    return symbol.equals("SPAXX**") || symbol.equals("Pending activity");
  }

  private AccountSnapshot parseLine(String line, LocalDate snapshotDate) {
    String[] cols = line.split(",", -1);
    if (cols.length < EXPECTED_MIN_COLUMNS) {
      return null;
    }

    // col[2]: Symbol — options have a leading " -" (space + dash)
    String rawSymbol = cols[2].trim();
    String symbol;
    OptionSymbol parsedOptionSymbol = null;
    if (rawSymbol.startsWith("-")) {
      parsedOptionSymbol = OptionSymbol.parse(rawSymbol.substring(1).trim());
      symbol = parsedOptionSymbol.getUnderlyingSymbol();
    } else {
      symbol = rawSymbol;
    }

    return AccountSnapshot.builder()
        .snapshotDate(snapshotDate)
        .symbol(symbol)
        .optionSymbol(parsedOptionSymbol)
        .description(cols[3].trim())
        .quantity(parseBigDecimal(cols[4]))
        .lastPrice(parseBigDecimal(cols[5]))
        .lastPriceChange(parseBigDecimal(cols[6]))
        .currentValue(parseBigDecimal(cols[7]))
        .todayGainLoss(parseBigDecimal(cols[8]))
        // col[9] today gain/loss percent — not mapped
        .totalGainLoss(parseBigDecimal(cols[10]))
        // col[11] total gain/loss percent — not mapped
        .percentOfAccount(parsePercent(cols[12]))
        .totalCostBasis(parseBigDecimal(cols[13]))
        .averageCostBasis(parseBigDecimal(cols[14]))
        .build();
  }

  private BigDecimal parseBigDecimal(String raw) {
    if (raw == null) {
      return null;
    }
    String cleaned = raw.trim().replace("$", "").replace(",", "").replace("+", "");
    if (cleaned.isEmpty() || cleaned.equals("--")) {
      return null;
    }
    return new BigDecimal(cleaned);
  }

  private BigDecimal parsePercent(String raw) {
    if (raw == null) {
      return null;
    }
    String cleaned = raw.trim().replace("%", "").replace("+", "");
    if (cleaned.isEmpty() || cleaned.equals("--")) {
      return null;
    }
    return new BigDecimal(cleaned);
  }
}
