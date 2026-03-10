# currencies

A simple currency conversion service used as a proof of concept for earning hands on experience with AWS infrastructure.

## Overview

This repository contains the backend service code and the infrastructure code used to run it on AWS.

## Tech Stack

- Java 25
- Spring Boot 4
- Gradle (Kotlin DSL)
- H2 (runtime dependency)
- Terraform (AWS infrastructure)

## Prerequisites

- JDK 25
- Docker (optional, for containerized runs)
- Terraform and AWS CLI (only for infrastructure work)

## Getting Started

Build the project:

```bash
./gradlew clean build
```

Run the application locally:

```bash
./gradlew bootRun
```

Run tests:

```bash
./gradlew test
```

## Docker

Build the container image:

```bash
docker build --build-arg APP_VERSION=0.0.2-SNAPSHOT -t currencies:0.0.2-SNAPSHOT .
```

Run the container:

```bash
docker run --rm -p 8080:8080 currencies:0.0.2-SNAPSHOT
```

## Project Structure

- `src/main/java`: application source code
- `src/main/resources`: application configuration (`application.yaml`)
- `src/infrastructure`: Terraform code for AWS deployment

## Infrastructure

Infrastructure documentation (Terraform usage, AWS auth, ECS/ECR/DynamoDB setup) is maintained here:

- [Infrastructure README](./src/infrastructure/README.md)

## Usage

Post a new currency conversion rate

```bash
curl -X POST http://localhost:8080/rates \
     -H "Content-Type: application/json" \
     -d @- <<EOF
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
]
EOF
```

Convert a currency

```bash
curl http://localhost:8080/convert?from=EUR&to=GBP&amount=100.25
```
## Limitations

The service currently assumes a USD base currency is always used. 
