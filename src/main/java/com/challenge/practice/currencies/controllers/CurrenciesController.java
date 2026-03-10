package com.challenge.practice.currencies.controllers;

import com.challenge.practice.currencies.services.CurrencyConversionService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
public class CurrenciesController {

    private final CurrencyConversionService currencyConversionService;

    public CurrenciesController(CurrencyConversionService currencyConversionService) {
        this.currencyConversionService = currencyConversionService;
    }

    @PostMapping("/rates")
    public void rates(@RequestBody Set<CurrencyRate> rates) {
        var serviceRates = rates.stream()
                .map(r -> new CurrencyConversionService.CurrencyRate(
                        r.currencyCode,
                        r.currencyBase,
                        r.rate,
                        r.asOf))
                .collect(Collectors.toSet());
        currencyConversionService.saveRates(serviceRates);
    }

    @GetMapping("/convert")
    public CurrencyConversion convert(
            @RequestParam String from,
            @RequestParam String to,
            @RequestParam BigDecimal amount) {
        var conversion = currencyConversionService.convert(from, to, amount);
        return new CurrencyConversion(
                conversion.from(),
                conversion.to(),
                conversion.amount(),
                conversion.rate(),
                conversion.convertedAmount(),
                conversion.asOf());
    }

    public record CurrencyRate (
            String currencyCode,
            String currencyBase,
            BigDecimal rate,
            ZonedDateTime asOf) {
    }

    public record CurrencyConversion(
            String from,
            String to,
            BigDecimal amount,
            BigDecimal rate,
            BigDecimal convertedAmount,
            ZonedDateTime asOf) {}
}
