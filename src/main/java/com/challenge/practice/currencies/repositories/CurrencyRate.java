package com.challenge.practice.currencies.repositories;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

import java.math.BigDecimal;
import java.time.ZonedDateTime;

@Entity
public class CurrencyRate {

    @Id
    private String code;
    private String base;
    private BigDecimal rate;
    private ZonedDateTime asOf;

    CurrencyRate() {}

    public CurrencyRate(
            String code,
            String base,
            BigDecimal rate,
            ZonedDateTime asOf) {
        this.code = code;
        this.base = base;
        this.rate = rate;
        this.asOf = asOf;
    }

    public String getCode() {
        return code;
    }

    public String getBase() {
        return base;
    }

    public BigDecimal getRate() {
        return rate;
    }

    public ZonedDateTime getAsOf() {
        return asOf;
    }
}
