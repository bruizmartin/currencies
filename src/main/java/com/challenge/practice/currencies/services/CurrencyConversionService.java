package com.challenge.practice.currencies.services;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.Set;

public interface CurrencyConversionService {

    void saveRates(Set<CurrencyRate> rates);

    ConversionResult convert(String from, String to, BigDecimal amount);

    record CurrencyRate (
            String currencyCode,
            String currencyBase,
            BigDecimal rate,
            ZonedDateTime asOf) {
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
