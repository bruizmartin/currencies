package com.challenge.practice.currencies.services;

import com.challenge.practice.currencies.repositories.CurrencyRateRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Set;

@Service
class CurrencyConversionServiceImpl implements CurrencyConversionService {

    private final CurrencyRateRepository currencyRateRepository;

    CurrencyConversionServiceImpl(CurrencyRateRepository currencyRateRepository) {
        this.currencyRateRepository = currencyRateRepository;
    }

    @Override
    public void saveRates(Set<CurrencyRate> rates) {
        var rateEntities = rates.stream()
                .map(rate -> new com.challenge.practice.currencies.repositories.CurrencyRate(
                        rate.currencyCode(),
                        rate.currencyBase(),
                        rate.rate(),
                        rate.asOf()))
                .toList();
        currencyRateRepository.saveAll(rateEntities);
    }

    @Override
    public ConversionResult convert(String from, String to, BigDecimal amount) {
        var sourceCurrency = from.trim().toUpperCase();
        var targetCurrency = to.trim().toUpperCase();

        var sourceRateEntity = currencyRateRepository.findById(sourceCurrency)
                .orElseThrow(() -> new IllegalArgumentException("Rate not found for " + sourceCurrency));
        var targetRateEntity = currencyRateRepository.findById(targetCurrency)
                .orElseThrow(() -> new IllegalArgumentException("Rate not found for " + targetCurrency));

        var sourceRate = sourceRateEntity.getRate();
        var targetRate = targetRateEntity.getRate();

        var conversionRate = targetRate.divide(sourceRate, 2, RoundingMode.HALF_EVEN);

        var convertedAmount = amount.multiply(conversionRate)
                .setScale(2, RoundingMode.HALF_EVEN);

        var asOf = sourceRateEntity.getAsOf().isAfter(targetRateEntity.getAsOf()) ?
                sourceRateEntity.getAsOf() :
                targetRateEntity.getAsOf();

        return new ConversionResult(
                sourceCurrency,
                targetCurrency,
                amount,
                conversionRate,
                convertedAmount,
                asOf);
    }
}
