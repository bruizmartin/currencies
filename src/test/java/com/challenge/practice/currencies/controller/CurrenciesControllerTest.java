package com.challenge.practice.currencies.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureRestTestClient;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.client.RestTestClient;

import java.math.BigDecimal;
import java.time.ZonedDateTime;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureRestTestClient
public class CurrenciesControllerTest {

    @Autowired
    private RestTestClient client;

    @Test
    public void conversionTest() {
        postRates();
        convert();
    }

    private void postRates() {
        client.post()
                .uri("/rates")
                .contentType(MediaType.APPLICATION_JSON)
                .body("""
                [
                    {
                        "currencyCode": "EUR",
                        "currencyBase": "USD",
                        "rate": 0.87,
                        "asOf": "2026-03-06T10:30:00Z"
                    },
                    {
                        "currencyCode": "GBP",
                        "currencyBase": "USD",
                        "rate": 0.75,
                        "asOf": "2026-03-06T10:30:00Z"
                    }
                ]""")
                .accept(MediaType.APPLICATION_JSON)
                .exchange()
                .expectStatus()
                .isOk();
    }

    private void convert() {
        client.get()
                .uri("/convert?from=EUR&to=GBP&amount=100.25")
                .exchangeSuccessfully()
                .expectBody(ConversionResult.class)
                .isEqualTo(new ConversionResult(
                        "EUR",
                        "GBP",
                        new BigDecimal("100.25"),
                        new BigDecimal("0.86"),
                        new BigDecimal("86.22"),
                        ZonedDateTime.parse("2026-03-06T10:30:00Z")));
    }

    record ConversionResult(
        String from,
        String to,
        BigDecimal amount,
        BigDecimal rate,
        BigDecimal convertedAmount,
        ZonedDateTime asOf) {
    }
}
