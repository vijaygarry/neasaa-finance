package com.neasaa.finance.integ;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.hasKey;

import com.neasaa.util.config.BaseConfig;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@DisplayName("POST /api/account/uploadsnapshot")
class AccountSnapshotUploadApiTest {

    private static final String UPLOAD_PATH = "/api/account/uploadsnapshot";
    private static final long VALID_ACCOUNT_ID = 1L;

    // Real Fidelity snapshot export — AvyTradingAccount2, Aug-15-2026 after market.
    // SPAXX** (money market) and Pending activity are skipped by the parser, leaving 13 valid records.
    private static final String VALID_CSV = """
            Account number,Account name,Symbol,Description,Quantity,Last price,Last price change,Current value,Today's gain/loss dollar,Today's gain/loss percent,Total gain/loss dollar,Total gain/loss percent,Percent of account,Cost basis total,Average cost basis,Type
            Z29808248,Individual - TOD,SPAXX**,HELD IN MONEY MARKET,,,,$10960.99,,,,,8.49%,,,Cash,
            Z29808248,Individual - TOD,CAVA,CAVA GROUP INC COM,200,$74.42,+$2.24,$14884.00,+$448.00,+3.10%,+$1484.00,+11.07%,11.53%,$13400.00,$67.00,Cash,
            Z29808248,Individual - TOD,MU,MICRON TECHNOLOGY INC COM,3,$971.66,+$21.83,$2914.98,+$65.49,+2.29%,+$605.46,+26.21%,2.26%,$2309.52,$769.84,Cash,
            Z29808248,Individual - TOD,NFLX,NETFLIX INC,200,$78.16,-$0.08,$15632.00,-$16.00,-0.11%,-$2478.69,-13.69%,12.10%,$18110.69,$90.55,Cash,
            Z29808248,Individual - TOD, -NFLX260821C100,NFLX AUG 21 2026 $100 CALL,-1,$0.01,$0.00,-$1.00,$0.00,0.00%,+$63.34,+98.44%,0.00%,$64.34,$0.64,Cash,
            Z29808248,Individual - TOD,ONDS,ONDAS INC COMMON STOCK,1250,$9.24,+$0.33,$11550.00,+$412.50,+3.70%,+$2485.00,+27.41%,8.94%,$9065.00,$7.25,Cash,
            Z29808248,Individual - TOD, -ONDS260821C7,ONDS AUG 21 2026 $7 CALL,-10,$2.20,+$0.31,-$2200.00,-$310.00,-16.41%,-$1366.65,-164.00%,-1.70%,$833.35,$0.83,Cash,
            Z29808248,Individual - TOD,RDDT,REDDIT INC CL A,100,$178.09,+$19.97,$17809.00,+$1997.00,+12.62%,+$4022.00,+29.17%,13.79%,$13787.00,$137.87,Cash,
            Z29808248,Individual - TOD,TEAM,ATLASSIAN CORPORATION CL A,100,$162.22,-$3.76,$16222.00,-$376.00,-2.27%,+$2728.00,+20.21%,12.56%,$13494.00,$134.94,Cash,
            Z29808248,Individual - TOD, -TEAM270115C140,TEAM JAN 15 2027 $140 CALL,-1,$42.01,+$0.21,-$4201.00,-$21.00,-0.51%,-$3281.69,-356.98%,-3.25%,$919.31,$9.19,Cash,
            Z29808248,Individual - TOD,UBER,UBER TECHNOLOGIES INC COM,100,$75.95,+$0.07,$7595.00,+$7.00,+0.09%,+$228.00,+3.09%,5.88%,$7367.00,$73.67,Cash,
            Z29808248,Individual - TOD, -UBER260821C90,UBER AUG 21 2026 $90 CALL,-1,$0.01,$0.00,-$1.00,$0.00,0.00%,+$63.34,+98.44%,0.00%,$64.34,$0.64,Cash,
            Z29808248,Individual - TOD,UNH,UNITEDHEALTH GROUP INC,100,$401.73,+$2.67,$40173.00,+$267.00,+0.66%,+$10100.05,+33.58%,31.11%,$30072.95,$300.73,Cash,
            Z29808248,Individual - TOD, -UNH261218C420,UNH DEC 18 2026 $420 CALL,-1,$21.95,+$0.55,-$2195.00,-$55.00,-2.58%,-$695.71,-46.41%,-1.70%,$1499.29,$14.99,Cash,
            Z29808248,Individual - TOD,Pending activity,,,,,$89998.14,,,,,,,,,

            "The data and information in this spreadsheet is provided to you solely for your use and is not for distribution. The spreadsheet is provided for informational purposes only, and is not intended to provide advice, nor should it be construed as an offer to sell, a solicitation of an offer to buy or a recommendation for any security by Fidelity or any third party. Data and information shown is based on information known to Fidelity as of the date it was exported and is subject to change. It should not be used in place of your account statements or trade confirmations and is not intended for tax reporting purposes. For more information on the data included in this spreadsheet, including any limitations thereof, go to Fidelity.com."

            "Brokerage services are provided by Fidelity Brokerage Services LLC (FBS), 900 Salem Street, Smithfield, RI 02917. Custody and other services provided by National Financial Services LLC (NFS). Both are Fidelity Investment companies and members SIPC, NYSE. Neither FBS nor NFS offer crypto as a direct investment nor provide trading or custody services for such assets."

            "Date downloaded Aug-15-2026 6:00 p.m ET"
            """;

    // Header-only CSV (no data rows — recordsProcessed should be 0)
    private static final String EMPTY_CSV =
            "Account number,Account name,Symbol,Description,Quantity,Last price,Last price change,"
            + "Current value,Today's gain/loss dollar,Today's gain/loss percent,"
            + "Total gain/loss dollar,Total gain/loss percent,Percent of account,"
            + "Cost basis total,Average cost basis,Type\n"
            + "\n"
            + "\"Date downloaded Aug-15-2026 6:00 p.m ET\"\n";

    @BeforeAll
    static void setup() throws Exception {
        BaseConfig.initialize("integ-test.properties");
        RestAssured.baseURI = BaseConfig.getProperty("BASE.URL");
    }

    // ── Tests that do not reach the operation (Spring MVC level) ─────────────

    @Test
    @DisplayName("Wrong Content-Type returns 415 Unsupported Media Type")
    void upload_wrongContentType_returns415() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"accountId\": 1}")
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(415);
    }

    @Test
    @DisplayName("Missing snapshotCSVFile part returns 400")
    void upload_missingFile_returns400() {
        given()
            .multiPart("accountId", VALID_ACCOUNT_ID)
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(400);
    }

    @Test
    @DisplayName("Missing accountId part returns 400")
    void upload_missingAccountId_returns400() {
        given()
            .multiPart("snapshotCSVFile", "snapshot.csv", VALID_CSV.getBytes(), "text/csv")
        .log().all()
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(400);
    }

    // ── Operation-level tests ─────────────────────────────────────────────────

    @Test
    @DisplayName("Valid CSV returns 200 with recordsProcessed=14 (SPAXX** and Pending activity skipped)")
    void upload_validCsv_returns200WithRecordCount() {
        given()
            .multiPart("accountId", VALID_ACCOUNT_ID)
            .multiPart("snapshotCSVFile", "snapshot.csv", VALID_CSV.getBytes(), "text/csv")
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(200)
            .contentType(ContentType.JSON)
            .body("$", hasKey("recordsProcessed"))
            .body("recordsProcessed", equalTo(14));
    }

    @Test
    @DisplayName("CSV with no data rows returns 200 with recordsProcessed=0")
    void upload_emptyCsv_returns200WithZeroRecords() {
        given()
            .multiPart("accountId", VALID_ACCOUNT_ID)
            .multiPart("snapshotCSVFile", "snapshot.csv", EMPTY_CSV.getBytes(), "text/csv")
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(200)
            .body("recordsProcessed", equalTo(0));
    }

    @Test
    @DisplayName("accountId=0 returns 400 Bad Request")
    void upload_zeroAccountId_returns400() {
        given()
            .multiPart("accountId", 0L)
            .multiPart("snapshotCSVFile", "snapshot.csv", VALID_CSV.getBytes(), "text/csv")
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(400);
    }

    @Test
    @DisplayName("Negative accountId returns 400 Bad Request")
    void upload_negativeAccountId_returns400() {
        given()
            .multiPart("accountId", -1L)
            .multiPart("snapshotCSVFile", "snapshot.csv", VALID_CSV.getBytes(), "text/csv")
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(400);
    }

    @Test
    @DisplayName("Response always contains recordsProcessed field on success")
    void upload_response_containsRecordsProcessedField() {
        given()
            .multiPart("accountId", VALID_ACCOUNT_ID)
            .multiPart("snapshotCSVFile", "snapshot.csv", VALID_CSV.getBytes(), "text/csv")
        .when()
            .post(UPLOAD_PATH)
        .then()
            .statusCode(200)
            .body("$", hasKey("recordsProcessed"))
            .body("recordsProcessed", greaterThanOrEqualTo(0));
    }
}
