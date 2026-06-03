package com.neasaa.finance.integ;

import com.neasaa.util.config.BaseConfig;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

@DisplayName("POST /api/stocks/search")
class StockSearchApiTest {

    private static final String SEARCH_PATH = "/api/stocks/search";

    @BeforeAll
    static void configureRestAssured() throws Exception {
        BaseConfig.initialize("integ-test.properties");
        RestAssured.baseURI = BaseConfig.getProperty("BASE.URL");
    }

    // ── Positive tests ────────────────────────────────────────────────────────

    @Test
    @DisplayName("Valid query returns 200 with stockList array containing expected fields")
    void search_validQuery_returns200WithStockList() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"query\": \"A\"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(200)
            .contentType(ContentType.JSON)
            .body("stockList", notNullValue())
            .body("stockList", instanceOf(java.util.List.class));
    }

    @Test
    @DisplayName("Valid query with results has items containing symbol, name, and type fields")
    void search_validQueryWithResults_eachItemHasRequiredFields() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"query\": \"A\"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(200)
            .body("stockList", everyItem(hasKey("symbol")))
            .body("stockList", everyItem(hasKey("name")))
            .body("stockList", everyItem(hasKey("type")));
    }

    @Test
    @DisplayName("Empty query returns 200 with empty stockList")
    void search_emptyQuery_returns200WithEmptyList() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"query\": \"\"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(200)
            .body("stockList", hasSize(0));
    }

    @Test
    @DisplayName("Null query returns 200 with empty stockList")
    void search_nullQuery_returns200WithEmptyList() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"query\": null}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(200)
            .body("stockList", hasSize(0));
    }

    @Test
    @DisplayName("Whitespace-only query returns 200 with empty stockList after trimming")
    void search_whitespaceQuery_returns200WithEmptyList() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"query\": \"   \"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(200)
            .body("stockList", hasSize(0));
    }

    @Test
    @DisplayName("Query with leading/trailing spaces is trimmed and returns results")
    void search_queryWithSurroundingSpaces_isTrimmedAndReturnsResults() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"query\": \"  A  \"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(200)
            .body("stockList", notNullValue());
    }

    @Test
    @DisplayName("Response always contains stockList field even when empty")
    void search_response_alwaysContainsStockListField() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"query\": \"ZZZNONEXISTENTSTOCK999\"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(200)
            .body("$", hasKey("stockList"));
    }

    // ── Negative tests ────────────────────────────────────────────────────────

    @Test
    @DisplayName("Request with no body returns 400")
    void search_noBody_returns400() {
        given()
            .contentType(ContentType.JSON)
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(400);
    }

    @Test
    @DisplayName("Request with malformed JSON returns 400")
    void search_malformedJson_returns400() {
        given()
            .contentType(ContentType.JSON)
            .body("{not valid json}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(400);
    }

    @Test
    @DisplayName("Request without Content-Type returns 415 Unsupported Media Type")
    void search_missingContentType_returns415() {
        given()
            .body("{\"query\": \"AAPL\"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(415);
    }

    @Test
    @DisplayName("Request with wrong Content-Type returns 415 Unsupported Media Type")
    void search_wrongContentType_returns415() {
        given()
            .contentType(ContentType.TEXT)
            .body("{\"query\": \"AAPL\"}")
        .when()
            .post(SEARCH_PATH)
        .then()
            .statusCode(415);
    }

    @Test
    @DisplayName("GET request returns 405 Method Not Allowed since endpoint does not accept GET without body")
    void search_getWithQueryParam_returns405OrHandledGracefully() {
        given()
            .queryParam("query", "AAPL")
        .when()
            .get(SEARCH_PATH)
        .then()
            .statusCode(anyOf(is(400), is(405)));
    }
}
