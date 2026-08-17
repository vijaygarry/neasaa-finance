package com.neasaa.finance.service.account.parser.snapshot;

import com.neasaa.csv.parser.CSVFileProcessor;
import com.neasaa.base.app.operation.AuditInfo;
import com.neasaa.finance.dao.entity.account.AccountSnapshot;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FidelityAccountSnapshotParser implements AccountSnapshotParser {

  private static final Pattern DATE_LINE_PATTERN =
      Pattern.compile("Date downloaded (\\w{3}-\\d{2}-\\d{4})");
  private static final DateTimeFormatter DATE_FORMATTER =
      DateTimeFormatter.ofPattern("MMM-dd-yyyy", Locale.ENGLISH);

  @Override
  public List<AccountSnapshot> parseSnapshot(String aCSVSnapshotFilepath, long accountId, AuditInfo auditInfo) throws IOException {
    LocalDate snapshotDate = extractSnapshotDate(aCSVSnapshotFilepath);

    CSVFileProcessor<AccountSnapshot> processor =
        new CSVFileProcessor.Builder<AccountSnapshot>()
            .csvFilePath(aCSVSnapshotFilepath)
            .delimiter(',')
            .skipHeaderRecord(true)
            .columnNames(FidelityAccountSnapshotRowMapper.COLUMN_NAMES)
            .rowMapper(new FidelityAccountSnapshotRowMapper(snapshotDate, accountId, auditInfo))
            .build();

    return processor.loadRecords();
  }

  private LocalDate extractSnapshotDate(String filePath) throws IOException {
    try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
      String line;
      while ((line = reader.readLine()) != null) {
        Matcher matcher = DATE_LINE_PATTERN.matcher(line);
        if (matcher.find()) {
          return LocalDate.parse(matcher.group(1), DATE_FORMATTER);
        }
      }
    }
    throw new IOException("Snapshot date line not found in file: " + filePath);
  }
}
