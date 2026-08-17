package com.neasaa.finance.controller;

import com.neasaa.finance.operation.account.UploadAccountSnapshotOperation;
import com.neasaa.finance.operation.account.model.UploadAccountSnapshotRequest;
import com.neasaa.finance.operation.account.model.UploadAccountSnapshotResponse;
import com.neasaa.finance.webutils.WebRequestHandler;
import java.io.File;
import java.nio.file.Files;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/account")
public class AccountController {

    @PostMapping(value = "/uploadsnapshot", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<UploadAccountSnapshotResponse> uploadSnapshot(
            @RequestParam("accountId") long accountId,
            @RequestParam("snapshotCSVFile") MultipartFile snapshotCSVFile) throws Exception {

        File tempFile = File.createTempFile("snapshot-", ".csv");
        try {
            snapshotCSVFile.transferTo(tempFile);

            UploadAccountSnapshotRequest request = new UploadAccountSnapshotRequest();
            request.setAccountId(accountId);
            request.setSnapshotCSVFilePath(tempFile.getAbsolutePath());

            return WebRequestHandler.processRequest(UploadAccountSnapshotOperation.class, request);
        } finally {
            Files.deleteIfExists(tempFile.toPath());
        }
    }
}
